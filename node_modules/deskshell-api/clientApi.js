var deskShell = {
	v:0.9
	,status:'awaitingSocket'
	,ready:function(callback) {
		deskShell.readyCallbacks.push(callback);
		if (deskShell.status == 'ready') {
			callback(deskShell);
		}
	},readyCallbacks:[]
	,sendMessage:function(name,data,callback) {
		deskShell.socket.emit(name,data,function(data) {
			if (callback) callback(data);
		});
	},exitApp:function() {
		deskShell.socket.emit('exitApp',{});
		setTimeout(function() {window.close();},500);
	}
}
if (io) {
console.log("socket connecting");
	deskShell.socket = io.connect('http://localhost:'+location.port);
	deskShell.socket.on('deskShell', function (data) {
console.log("deskShell message",data);
		for(var i in data) {
			deskShell[i] = data[i];
		}
		deskShell.status = 'ready';
		for(var c in deskShell.readyCallbacks) {
			deskShell.readyCallbacks[c](deskShell);
		}
	});
}else {
	console.log("io not found");
}