<?php
	
	/* 
	 	At this point, the browser and server are started, and their threads available as $server and $browser.
	 	You can take influence in basically everything, so to say.
	 	
	 	In the most case, you may want to override the Request::send(WebServer $instance) function, since that is what makes up a request.
	 	For that...well, this is not implemented, yet. In a future version, $server will expose a proxy to the method of WebServer::handleRequest.
	 	That way, you can re-define how requests are handled. If you dont change it, an apache-like rythm is used.
	 	
	 	You also can register events with Event::on($name, Closure $callback). Consider any vaild rDebug event as vaild :)
	 	
	 	Actualy, in a future update to this port, you will get to know appIO. it's syntax may be ported to the nodejs port too.
	 	
	 	If your editor is smart, you are using a block-per-char font - so, the parantheses () may look like an O for you, so dont get confused on the 
	 	following...as I like weird things :p
	 	
	 	During the setup process, the initial code will include appIO.php, which exposes:
	 		- class appIO {
	 			bool directCall(mixed $input)
	 				// $input may be object or array. Upon json_encode, it must look like a vaild rDebug object.
	 				// Returns true once the send has been done (aka. once the JSON string has been send)
	 			mixed call($name, $method, $args)
	 				// Reaches over to the WK-RDP class and performs a call with a more familar way.
	 				// Returns whatever there is to be returned.
	 			void on(...)
	 				// Proxy -> Event::on()
	 		}
	 		- function appI(mixed)
	 	
	 	The more important thing is the singleton function appI(). It has different usages all in once, and is a neat piece of a thing :)
	 	
	 	example usages
	 	
	 		appI("CSS.styleSheetAdded", function($params){ print_r($params); });
	 		// Proxy to appIO::on()
	 		
	 		appI()->Page->navigate($url)
	 		// Crates instance to class Page, then calls navigate with parameter $url
	 		
	 		appI(["justReturn"=>true])->Page->navigate($url)
	 		// This will actually RETURN the JSON string! :)
	 		
	 		appI(["activeBackend"=>true])
	 		// Will return an array:
	 			[
	 				"port"=>NNNN,
	 				"ws"=>"ws://localhost:{$port}/{uniqid}",
	 				"instance"=>\appIO\ActiveBackend
	 			]
	 		// This can be used to use something else than AJAX, and have an actual real-time connection to the backend. See the phpws documentation 
	 		// for more information on the WebSocket Server.
	 		// The third value is actualy a class that just then gets included. It is a WebSocket server, to which you may attach methods and alike, 
	 		// or override existing methods, since it can. :)
	 		
	 		appI("{'id':1,'method':'Page.navigate','params':['url':'http://google.de']}")
	 		// Proxy to appIO::directCall
	 		
	 		
	 		As you see, it accepts nothing, a string, or an array as the parameter. It is a very strange function, but it is uber-powerful.
	 		This will be ported to nodejs too - including all the weird arguments. But if you look at it again, you'll realize,
	 		that I simply wanted to create the swiss-knife for apps that need more advanced technology :)
	 		
	 		For now however, the only thing we can do is make a dump of the current $browser and $server instances, because we're curios.
	 	*/
	 /*ob_start();
	 var_dump($browser); #Note, this causes a memory-leak :p
	 $bData = ob_get_clean();
	 
	 ob_start();
	 var_dump($server); #this is less to.
	 $bServer = ob_get_clean();
	 
	 file_put_contents(
	 	dirname(__file__)."/ThreadDump.txt",
	 	"Browser: $bData\n\n\n"
	 	."Server: $bServer\n\n\n"	 	
	 );*/