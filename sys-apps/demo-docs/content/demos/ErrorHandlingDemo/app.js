var running = deskShell.startApp({})
.then(function(app) {
	//app.socketio holds the socket that can recieve and send messages to the client.
	app.socketio.on('connection', function(socket) {
		console.log("socket connected");
		socket.on('makeError',function() {
			throw new Error("Pretend Error Exception");
		});
	});
});