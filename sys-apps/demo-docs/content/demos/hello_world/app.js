var running = deskShell.startApp({
}).then(function(app) {
	//app.socketio holds the socket that can recieve and send messages to the client.
	app.socketio.on('connection', function(socket) {
		socket.on('exitApp',function(params) {
			console.log("exitApp");
			process.exit();
		});
		socket.on('hello',function(params) {
			socket.emit('world', "hello browser");
		});
	});
});