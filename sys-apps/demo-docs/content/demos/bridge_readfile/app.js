var mapOfProxy = {};
var counter = 0;

var running = deskShell.startApp({
}).then(function(app) {
	//app.socketio holds the socket that can recieve and send messages to the client.
	app.socketio.on('connection', function(socket) {
		socket.on('exitApp',function(params) {
			console.log("exitApp");
			process.exit();
		});

		socket.emit('deskShell');
		
		socket.on('hello',function(params) {
			socket.emit('world', "hello browser");
		});

		socket.on('require', function(module) {
			var mod = require(module);
			counter = counter + 1;
			mapOfProxy[counter] = mod;
			var sendProxy = {proxy : counter, keys_proxy : null};
			sendProxy.keys_proxy = Object.keys(mod);
			//console.log(mod);
			//console.log("*******************\n");
			//console.log(Object.keys(mod));
			socket.emit('require-response', sendProxy);
		});

		socket.on('call-function', function(funcDetails) {
			var proxy = funcDetails.proxy;
			var actualObject = mapOfProxy[proxy];
			//console.log("*******************\n");
			//console.log(funcDetails.funcName);
			actualObject[funcDetails.funcName](funcDetails.arguments_, function(err, data) {
				if(!err) {
					console.log("Yaa proxy worked " + data);
				} else {
					console.log(err);
				}
			});
		});

		socket.on('XX', function(param) {
			var x = "abc";
			console.log("abc abc");
			var proxyObject = {};
			proxyObject[x] = function() {
				console.log(x);
			};
			proxyObject.abc();
		});
	});
});