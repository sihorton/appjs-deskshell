/**
* this demo shows usage of a deskshell api.
*/
var fs = require("fs"),path=require('path');

var running = deskShell.startApp({
}).then(function(app) {
	//app.socketio holds the socket that can recieve and send messages to the client.
	app.socketio.on('connection', function(socket) {
		console.log("connected to client");
		socket.emit('deskShell',deskShell.clientApiData());
		socket.on('LaunchApp',function(params) {
			console.log("launchApp",params);
			if (params.relpath) {
				deskShell.launchApp(require("path").normalize(deskShell.appDir + params.relpath));
			}
			if (params.abspath) {
				deskShell.launchApp(require("path").normalize(params.abspath));
			}
		});
		socket.on('GetAppForEdit',function(params) {
			console.log("GetAppForEdit",params);
			fs.readFile(params.file, 'utf8', function (err, data) {
				if (err) {
					socket.emit('progress',{type:"error",text:err.toString()});
				} else {
					try {
						var appDef = JSON.parse(data);
						
						socket.emit('AppFileLoaded',appDef);
					} catch(e) {
						socket.emit('progress',{type:"error",text:e.toString()});
					}
				}
			});
		});
		socket.on('OpenFolder',function(params) {
			console.log("openfolder",params);
			var p;
			if (params.relpath) {
				p = require("path").normalize(deskShell.appDir + params.relpath);
			}
			if (params.abspath) {
				p = require("path").normalize(params.abspath);
			}
			p=require("path").dirname(p);
			console.log('explorer '+p);
			require('child_process').exec('explorer '+p);
		});
		socket.on('SaveAppDef',function(params) {
			try {
				var appFile = params.file;
				delete params.file;
				console.log("SaveAppDef",params);
				//attempt to round-trip the application definition
				fs.readFile(appFile, 'utf8', function (err, data) {
					if (err) {
						socket.emit('progress',{type:"error",text:err.toString()});
					} else {
						try {
							var appDef = JSON.parse(data);
							for(var d in params) {
								appDef[d] = params[d];
							}
							//save application.
							fs.writeFile(appFile, JSON.stringify(appDef,null, 4) , function(err) {
								try {
									if(err) {
										console.log(err);
									} else {
										socket.emit('AppUpdated',appFile);
										socket.emit('progress',{type:"success",text:'saved '+appFile});
									}
								} catch(e) {
									socket.emit('progress',{type:"error",text:e.toString()});
								}
							});
						} catch(e) {
							socket.emit('progress',{type:"error",text:e.toString()});
						}
					}
				});
				
			} catch(err) {
				socket.emit('progress',{type:"error",text:err.toString()});
			}
		});
		
		socket.on('newApp',function(params) {
			try {
				console.log("newApp",params);
				//create a new minimal application...
				var defaults = {
					folder:path.normalize(deskShell.platformDir+'/../../../deskshell-apps')
					,name:'test'
					,v:"0.1"
					,author:"changeme@example.com"
					,htdocs:"htdocs"
					,defaultLocation:"index.htm"
					,exitOnAppWinClose:true
				}
				for(var d in defaults) {
					if (!params[d]) params[d] = defaults[d];
				}
				var appFolder = params.folder+path.sep+(params.name||'test');
				
				delete params.folder;
				
				fs.mkdir(appFolder,function(err){
					try {
						if (err && err['code'] == 'EEXIST') {
							//folder already exists.
						} else {
							console.log(err);
						}
						//create new application.
						fs.writeFile(appFolder+path.sep+params.name+".desk", JSON.stringify(params,null, 4) , function(err) {
							if(err) {
								console.log(err);
							} else {
								socket.emit('progress','created '+appFolder);
								fs.mkdir(appFolder+path.sep+params.htdocs,function(err){
									socket.emit('progress',{type:"info",text:appFolder+path.sep+params.htdocs});
									
									fs.writeFile(appFolder+path.sep+params.htdocs+path.sep+"index.htm", "<html><title>"+params.name+"</title><body><h2>Hello World</h2><p>Edit me and add your content</p></body></html>" ); 
									fs.writeFile(appFolder+path.sep+"app.js","var running = deskShell.startApp({});");
									socket.emit('AppCreated',appFolder+path.sep+params.name+".desk");
									socket.emit('progress',{type:"success",text:appFolder+path.sep+params.name+".desk"});
								});
								
							}
						});
					} catch(err) {
						socket.emit('progress',{type:"error",text:err.toString()});
					}
				});
			} catch(err) {
				socket.emit('progress',{type:"error",text:err.toString()});
			}
		});
		socket.on('appExe',function(params) {
			try {
				console.log("appExe",params);
				fs.readFile(__dirname+path.sep+"app.sample.nsi", 'utf8', function (err, data) {
					fs.writeFile(params.folder+path.sep+"app.nsi", data,function(err) {
						socket.emit('AppExeCreated',params.folder+path.sep+"app.nsi");
						socket.emit('progress',{type:"success",text:params.folder+path.sep+"app.nsi"});
					}); 
							
				});
			} catch(err) {
				socket.emit('progress',{type:"error",text:err.toString()});
			}
		});
	});
	
});