<?php

require_once ("websocket.functions.php");
require_once ("websocket.exceptions.php");
require_once ("websocket.framing.php");
require_once ("websocket.message.php");
require_once ("websocket.resources.php");
require_once ("websocket.socket.php");

class WebSocket implements WebSocketObserver {

    protected $socket;
    protected $handshakeChallenge;
    protected $hixieKey1;
    protected $hixieKey2;
    protected $host;
    protected $port;
    protected $origin;
    protected $requestUri;
    protected $url;
    protected $hybi;
    protected $_frames = array();
    protected $_messages = array();
    protected $_head = '';
    protected $_timeOut = 1;

    /**
     * @param string $origin
     */
    public function setOrigin($origin)
    {
        $this->origin = $origin;
    }

    /**
     * @return string
     */
    public function getOrigin()
    {
        return $this->origin;
    }



    // mamta
    public function __construct($url, $useHybie = true, $showHeaders = false) {
        define("WS_DEBUG_HEADER", $showHeaders);
        $this->hybi = $useHybie;
        $parts = parse_url($url);

        $this->url = $url;

        if (in_array($parts['scheme'], array('ws', 'wss')) === false)
            throw new WebSocketInvalidUrlScheme();

        $this->scheme = $parts['scheme'];

        $this->host = $parts['host'];
        $this->port = array_key_exists('port', $parts) ? $parts['port'] : 80;
        $this->path = array_key_exists('path', $parts) ? $parts['path'] : '/';
        $this->query = array_key_exists("query", $parts) ? $parts['query'] : null ;

        if(array_key_exists('query', $parts))
            $this->path .= "?".$parts['query'];

        $this->origin = 'http://' . $this->host;

        if (isset($parts['path']))
            $this->requestUri = $parts['path'];
        else
            $this->requestUri = "/";

        if (isset($parts['query']))
            $this->requestUri .= "?" . $parts['query'];


    }

    public function onDisconnect(WebSocketSocket $s) {
    	echo "WebSocket hung up!\n";
        $this->close();
    }

    public function onConnectionEstablished(WebSocketSocket $s) {
        
    }

    public function onMessage(IWebSocketConnection $s, IWebSocketMessage $msg) {
        $this->_messages[] = $msg;
    }

    public function onFlashXMLRequest(WebSocketConnectionFlash $connection) {
        
    }

    public function setTimeOut($seconds) {
        $this->_timeOut = $seconds;
    }

    public function getTimeOut() {
        return $this->_timeOut;
    }

    /**
     * TODO: Proper header generation!
     * TODO: Check server response!
     */
    public function open() {
        $errno = $errstr = null;

        $protocol = $this->scheme == 'ws' ? "tcp" : "ssl";

        $this->socket = stream_socket_client("$protocol://{$this->host}:{$this->port}", $errno, $errstr, $this->getTimeOut());
        // socket_connect($this->socket, $this->host, $this->port);

        // mamta
        if ($this->hybi) {
            $this->buildHeaderArray();
        } else {
            $this->buildHeaderArrayHixie76();
        }
        $buffer = $this->serializeHeaders();

        fwrite($this->socket, $buffer, strlen($buffer));

        // wait for response
        $buffer = WebSocketFunctions::readWholeBuffer($this->socket);
        $headers = WebSocketFunctions::parseHeaders($buffer);

        $s = new WebSocketSocket($this, $this->socket, $immediateWrite = true);

        if ($this->hybi)
            $this->_connection = new WebSocketConnectionHybi($s, $headers);
        else
            $this->_connection = new WebSocketConnectionHixie($s, $headers, $buffer);

        $s->setConnection($this->_connection);

        return true;
    }

    private function serializeHeaders() {
        $str = '';

        foreach ($this->headers as $k => $v) {
            $str .= $k . " " . $v . "\r\n";
        }

        return $str."\r\n";
    }

    public function addHeader($key, $value) {
        $this->headers[$key . ":"] = $value;
    }

    protected function buildHeaderArray() {
        $this->handshakeChallenge = WebSocketFunctions::randHybiKey();

        $this->headers = array("GET" => "{$this->path}{$this->query} HTTP/1.1", "Connection:" => "Upgrade", "Host:" => "{$this->host}", "Sec-WebSocket-Key:" => "{$this->handshakeChallenge}", "Origin:" => "{$this->origin}", "Sec-WebSocket-Version:" => 13, "Upgrade:" => "websocket");

        return $this->headers;
    }

    # mamta: hixie 76

    protected function buildHeaderArrayHixie76() {
        $this->hixieKey1 = WebSocketFunctions::randHixieKey();
        $this->hixieKey2 = WebSocketFunctions::randHixieKey();
        $this->headers = array("GET" => "{$this->url} HTTP/1.1", "Connection:" => "Upgrade", "Host:" => "{$this->host}", "Origin:" => "{$this->origin}", "Sec-WebSocket-Key1:" => "{$this->hixieKey1->key}", "Sec-WebSocket-Key2:" => "{$this->hixieKey2->key}", "Upgrade:" => "websocket", "Sec-WebSocket-Protocol: " => "hiwavenet");

        return $this->headers;
    }

    public function send($string) {
        $this->_connection->sendString($string);
    }

    public function sendMessage($msg) {
        $this->_connection->sendMessage($msg);
    }

    public function sendFrame(IWebSocketFrame $frame) {
        $this->_connection->sendFrame($frame);
    }

    /**
     * @return WebSocketFrame
     */
    public function readFrame() {
        $buffer = WebSocketFunctions::readWholeBuffer($this->socket);

        $this->_frames = array_merge($this->_frames, $this->_connection->readFrame($buffer));

        return array_shift($this->_frames);
    }

    /**
     * 
     * @return IWebSocketMessage
     */
    public function readMessage() {
        while (count($this->_messages) == 0)
            $this->readFrame();



        return array_shift($this->_messages);
    }

    public function close() {
        /**
         * @var WebSocketFrame
         */
        $frame = null;
        $this->sendFrame(WebSocketFrame::create(WebSocketOpcode::CloseFrame));

        $i = 0;
        do {
            $i++;
            $frame = @$this->readFrame();
        } while ($i < 2 && $frame && $frame->getType() == WebSocketOpcode::CloseFrame);

        @fclose($this->socket);
    }

}
