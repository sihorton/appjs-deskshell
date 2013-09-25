/**
* this demo shows usage of a deskshell api.
*/
var htdocs = __dirname+'/content'
var fs = require("fs"),path=require('path');

var running = deskShell.startApp({
	htdocs:htdocs
	,openSocket:true
	,launchChromium:true
	,exitOnChromiumClose:true
	,width:400
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
		socket.on('newApp',function(params) {
			try {
				console.log("newApp",params);
				//create a new minimal application...
				var defaults = {
					folder:path.normalize(deskShell.platformDir+'\\..\\..\\..\\deskshell-apps')
					,name:'test'
					,v:"0.1"
					,author:"changeme@example.com"
					,htdocs:"htdocs"
				}
				for(var d in defaults) {
					if (!params[d]) params[d] = defaults[d];
				}
				var appFolder = params.folder+"/"+(params.name||'test');
				
				delete params.folder;
				
				fs.mkdir(appFolder,function(err){
					try {
						if (err && err['code'] == 'EEXIST') {
							//folder already exists.
						} else {
							console.log(err);
						}
						//create new application.
						fs.writeFile(appFolder+"/"+params.name+".desk", JSON.stringify(params,null, 4) , function(err) {
							if(err) {
								console.log(err);
							} else {
								socket.emit('progress','created '+appFolder);
								fs.mkdir(appFolder+"/"+params.htdocs,function(err){
									socket.emit('progress','created '+appFolder+"/"+params.htdocs);
									fs.writeFile(appFolder+"/"+params.htdocs+"/index.htm", "<html><title>"+params.name+"</title><body><h2>Hello World</h2><p>Edit me and add your content</p></body></html>" ); 
									fs.writeFile(appFolder+"/app.js","var running = deskShell.startApp({\n	htdocs:__dirname+'/"+params.htdocs+"/'\n	,openSocket:true\n	,launchChromium:true\n	,exitOnChromiumClose:true\n	,width:400\n});");
									socket.emit('AppCreated',appFolder+"/"+params.name+".desk");
								});
								
							}
						});
					} catch(err) {
						socket.emit('progress',err.toString());
					}
				});
			} catch(err) {
				socket.emit('progress',err.toString());
			}
		});
	});
	
});