<?php
	/*
     *	Copyright (c) 2010 Tristan Roberts
	 *
     *  Permission is hereby granted, free of charge, to any person obtaining
     *  a copy of this software and associated documentation files (the
     *  "Software"), to deal in the Software without restriction, including
     *  without limitation the rights to use, copy, modify, merge, publish,
     *  distribute, sublicense, and/or sell copies of the Software, and to
     *  permit persons to whom the Software is furnished to do so, subject to
     *  the following conditions:
     *  
     *  The above copyright notice and this permission notice shall be included
     *  in all copies or substantial portions of the Software.
     *  
     *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
     *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
     *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
     *  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
     *  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
     *  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
     *  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	 */
	
	/**
		The default address of the webserver (0.0.0.0 is localhost).
	*/
	define("WS_ADDR", "0.0.0.0");
	
	/**
		The default port of the webserver (80 is normal HTTP).
	*/
	define("WS_PORT", 8421);
	
	/**
		The default time limit for the server to run (0 is unlimited).
	*/
	define("WS_TIME_LIMIT", 0);

	/**
		The default type of IP address (IPv4 or IPv6). The following
		values are allowed: 4 (IPv4) or 6 (IPv6).
	*/
	define("WS_INET_TYPE", 4);
	
	/**
		The default maximum number of queued requests.
		@see	http://au.php.net/socket_listen
	*/
	define("WS_MAX_QUEUED_REQUESTS", 15);
	
	/**
		The server tagline sent in headers (and in $_SERVER["SERVER_SOFTWARE"]).
		This should be short, and alphanumeric only (but not required). For
		example, Apache sends just "Apache".
	*/
	define("WS_SERVER_TAGLINE", "WebServerPHP");

	/**
		Acts as a webserver, taking control of WS_DEFAULT_PORT and responding
		to each request. It sets the $_SERVER, $_GET, $_POST and $_COOKIE variables
		correctly for each request and then calls the $callback function or method.
		
		@author	 Tristan Roberts
	*/
	class WebServer {
		protected $_socket = null; /**< The web spcket for all connections. */
		
		protected $_port = null; /**< The port to bind to. */
		
		protected $_addr = null; /**< The address to bind to. */

		protected $_headers = array(); /**< An array of headers to send in the response. */
		
		/**
			Dies on a fatal error and writes the error message. The output looks
			like "[WEBSERVER_ERROR_00] [2010-12-18T15:19:21+00:00] [Unknown FATAL ERROR]".
			If you're running in daemon mode, you can tunnel output with 
			"php myapp >> /var/log/myapp.log" or similar. If you want to send a non-fatal
			error or message to the terminal or log, use error_log("...", 0).
			
			@param	$number		The error message number.
			@param	$extra_info	An array of extra variables to output (NULL default)
			@return NONE - Kills the script.
			@see	http://php.net/error_log
		*/
		protected function fatalError($number, $extra_info = null) {
			$error = null;
			$message = "Unknown FATAL ERROR.";
			
			switch ($number) {
				case 1:
					$message = "Unable to CREATE SOCKET.";
				break;
				case 2:
					$message = "Unable to BIND SOCKET to " . $extra_info[1] . ":" . $extra_info[0] . ".";
				break;
				case 3:
					$message = "Unable to LISTEN ON SOCKET.";
				break;
				case 4:
					$message = "Unknown CALLBACK FUNCTION '" . $extra_info[0] . "'.";
				break;
			}
			
			$error  = "[WEBSERVER_ERROR_" . str_pad($number, 2, "0", STR_PAD_LEFT) . "] ";
			$error .= "[" . @date("c") . "] ";
			$error .= $message . "\n";
			
			// Because threading damages this logic some x3
			$this->hasError = true;
			
			die($error);
		}
		
		/**
			Creates the socket as a TCP stream and returns its status.
			This will set the stream to be either IPv4 or IPv6, depending
			on WS_INET_TYPE.
			
			@return	TRUE on success, FALSE on error
			@see	WS_INET_TYPE, _socket
		*/
		protected function createSocket() {
			$type = (WS_INET_TYPE < 5 ? AF_INET : AF_INET6);
			$this->_socket = socket_create($type, SOCK_STREAM, SOL_TCP);
			return (bool) $this->_socket;
		}
		
		/**
			Bind the port and address to the socket and set them in _port and _addr.
			
			@param	$port	The port to bind to (WS_PORT default)
			@param	$addr	The address to bind to (WS_ADDR default)
			@return	TRUE on success, FALSE on error
			@see	_addr, _port, _socket, WS_PORT, WS_ADDR
		*/
		protected function bindSocket($port = WS_PORT, $addr = WS_ADDR) {
			$this->_port = $port;
			$this->_addr = $addr;
			return (bool) socket_bind($this->_socket, $addr, $port);
		}
		
		/**
			Listens on the socket, queuing requests as it is only single-threaded.
			
			@param	$backlog The maximum number to queue (WS_MAX_QUEUED_REQUESTS)
			@return	TRUE on success, FALSE on error.
			@see	WS_MAX_QUEUED_REQUESTS, _socket
		*/
		protected function listenOnSocket($backlog = WS_MAX_QUEUED_REQUESTS) {
			return (bool) socket_listen($this->_socket, $backlog);
		}
		
		/**
			Sets the $_SERVER, $_GET, $_POST and $_COOKIE variables with their correct
			values based on the request. To get the requested URL, use $_SERVER["REQUEST_URI"].
			All headers will be set in $_SERVER as HTTP_HEADER_NAME, including user agent,
			languages and encoding. Currently, $_SERVER["REMOTE_ADDR"] is not set.
			
			@param	$headers	The dump from the request.
			@see	http://php.net/superglobals
			@see	WS_SERVER_TAGLINE, _port
		*/
		protected function setEnvironment($headers) {
			$lines = explode("\n", $headers);
			$request = trim(array_shift($lines));
			$request = explode(" ", $request);
			$file = explode("?", trim($request[1]), 2);
			
			if (isset($file[1])) {
				$_SERVER["QUERY_STRING"] = $file[1];
				parse_str($file[1], $_GET);
			} else {
				$_SERVER["QUERY_STRING"] = "";
			}
			
			$_SERVER["REQUEST_URI"] = $file[0];
			$_SERVER["SCRIPT_URL"] = $file[0];
			$_SERVER["SERVER_PORT"] = $this->_port;
			$_SERVER["REQUEST_TIME"] = time();
			$_SERVER["REQUEST_METHOD"] = trim($request[0]);
			$_SERVER["SERVER_SOFTWARE"] = WS_SERVER_TAGLINE;
			$_SERVER["SERVER_PROTOCOL"] = trim($request[2]);
			
			foreach ($lines as $i => $line) {
				$parts = explode(":", $line, 2);
				if (isset($parts[1])) {
					$name = strtoupper(str_replace("-", "_", trim($parts[0])));
					if (!empty($name)) {
						$_SERVER["HTTP_" . $name] = trim($parts[1]);
					}
				} else {
					parse_str($parts[0], $_POST);
				}
			}
			
			$cookies = explode(";", $_SERVER["HTTP_COOKIE"]);
			
			foreach ($cookies as $i => $cookie) {
				$cookie = explode("=", trim($cookie), 2);
				$name = trim($cookie[0]);
				$_COOKIE[$name] = trim($cookie[1]);
			}
		}
		
		/**
			Adds a header that will be sent in the response. This MUST be 
			used instead of PHP's header() because header() goes straight 
			to a PHP's internal buffer. A strange bug makes internally redirecting
			stuff up (and ocntinuously redirects). Instead, rework your code 
			to call the (callback) function/method itself (you may need to 
			change the value of $_SERVER["REQUEST_URI"]).
			
			@param	$name	The name of the header to send (or the full header).
			@param	$value	The value to send (NULL makes this work like PHP's normal header() function, default)
			@return	TRUE on success, FALSE on error
			@see	http://php.net/header
			@see	_headers
		*/
		public function header($name, $value = null) {
			if (is_null($value)) {
				$parts = explode(":", $name, 2);
				$name = trim($parts[0]);
				$value = trim($parts[1]);
			}
			$this->_headers[$name] = $value;
		}
		
		/**
			Sets a cookie using the Set-cookie header. This MUST be used 
			instead of PHP's setcookie() as setcookie() uses PHP's header()
			function, which cannot be used (or overriden). Also, as of current
			only one (1) cookie can be sent back in each response. This bug
			should be fixed soon.
			
			@param	$name	 The name of the cookie.
			@param	$value	 The value of the cookie
			@param	$expires The max-age of the cookie (0 is forever, default)
			@see	http://php.net/setcookie
			@see	header()
		*/
		public function setcookie($name, $value = "", $expires = 0) {
			$this->header("Set-cookie", $name . "=" . urlencode($value) . "; Max-Age: " . $expires);
		}
		
		/**
			Initializes the webserver on $addr:$port and allows the script to 
			run for $time seconds. Falls back to the WS_* constants if no parameters
			are passed. If it cannot create, bind or listen on the socket, it will
			kill the PHP application with a fatal error.
			
			@param	$port	The port to use (WS_PORT default)
			@param	$addr	The address (IP or hostname) to bind to (WS_ADDR default)
			@param	$time	The time to let the server run (WS_TIME_LIMIT default)
			@see	WS_PORT, WS_ADDR, WS_TIME_LIMIT
			@see	createSocket(), bindSocket(), listenOnSocket(), fatalError()
		*/
		public function __construct($port = WS_PORT, $addr = WS_ADDR, $time = WS_TIME_LIMIT) {
			//	Make sure the server runs for X seconds.
			@set_time_limit($time);
			
			if (!$this->createSocket()) {
				$this->fatalError(1);
			}
			
			if (!$this->bindSocket($port, $addr)) {
				$this->fatalError(2, array($port, $addr));
			}
			
			if (!$this->listenOnSocket()) {
				$this->fatalError(3);
			}
		}
		
		/**
			Closes the socket and quits the webserver.
			
			@return	bool	TRUE on success, FALSE on error
			@see	_socket, __construct()
		*/
		public function __destruct() {
			return (bool) socket_close($this->_socket);
		}
		
		/**
			Handles the requests and calls the callback function/method for each request. 
			The callback function/method should take one (1) parameter: this instance of WebServer.
			To get the requested URL, look up $_SERVER["REQUEST_URI"]. The default headers
			are also sent, including Server (WS_SERVER_TAGLINE), X-Powered-By (PHP/VERSION),
			Cache-control ("max-age=600, private, must-revalidate"), Date (current date in RFC2822),
			Connection (close) and the Contennt-type (text/html; charset=UTF-8). All of these
			can be overriden by calling $instance->header(name, value) in the callback function.
			
			@param	$object	The object (as a string or instance) or the function name.
			@param	$method	The method name if using OOP-style usage.
			@see	header(), setEnvironment()
			@see	_socket, _headers, WS_SERVER_TAGLINE
			@see	example.php
		*/
		public function handleRequests($object, $method = null) {
			$this->header("Server", WS_SERVER_TAGLINE);
			$this->header("X-Powered-By", "PHP/" . phpversion());
			$this->header("Cache-control", "max-age=600, private, must-revalidate");
			$this->header("Vary", "Accept-Encoding");
			$this->header("Date", @date("r"));
			$this->header("Connection", "close");
			$this->header("Content-type", "text/html; charset=UTF-8");
			
			while (true) {
				$spawn = socket_accept($this->_socket);
				while (false == ($input = socket_read($spawn, 1024)));
				
				ob_start();
				$this->setEnvironment($input);
				
				$status = 200;
				
				if (is_null($method)) {
					$status = $object($this);
				} else if (is_string($object)) {
					$instance = new $object();
					$status = $instance->$method($this);
				} else {
					$status = $object->$method($this);
				}
				
				if (!is_string($status)) {
					$status = "200 OK";	
				}
				
				if (isset($this->_headers["Location"])) {
					$status = "302 Found";
				}
				
				$body = ob_get_clean();
				$this->header("Content-length", strlen($body));
				
				$headers = "HTTP/1.0 " . $status . "\n";
				
				foreach ($this->_headers as $name => $value) {
					$headers .= $name . ": " . $value . "\n";
				}
				
				socket_write($spawn, $headers . "\n" . $body);
				socket_close($spawn);
			}
		}
	}
?>