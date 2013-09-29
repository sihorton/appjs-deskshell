/**
* this demo shows usage of a deskshell api.
*/

var running = deskShell.startApp({
}).then(function(app) {
	//app.socketio holds the socket that can recieve and send messages to the client.
	app.socketio.on('connection', function(socket) {
		console.log("connected to client");
		socket.on('LaunchApp',function(params,back) {
		console.log(params);
			var f = require("path").normalize(deskShell.appDir + params.relpath);
			console.log("Launching App",f);
			deskShell.launchApp(f);
		});
		socket.on('controlMe',function(params,back) {
			console.log("controlMe message recieved");
			app.rDebugApi.pageNavigate("http://appjs.com").then(function() {
				console.log("wait 5 seconds and you will return to the app");
				setTimeout(function(){
					app.rDebugApi.pageNavigate('http://localhost:'+app.port)
				},5000);
					
			}).fail(function(err) {
			console.log("error:"+err.error.code+" "+err.error.message);
			});
		});
	});
	
});