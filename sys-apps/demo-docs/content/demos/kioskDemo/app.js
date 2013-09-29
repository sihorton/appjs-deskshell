var running = deskShell.startApp({
	htdocs:__dirname+'/htdocs/'
	,openSocket:true
	,launchChromium:true
	,exitOnChromiumClose:true
	,chromiumFlags:['--kiosk']
}).then(function(app) {
	//app.socketio holds the socket that can recieve and send messages to the client.
	app.socketio.on('connection', function(socket) {
		socket.on('exitApp',function(params) {
			console.log("exitApp");
			process.exit();
		});
	});
});