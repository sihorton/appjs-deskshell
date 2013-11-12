/**
* @author: sihorton
* Implementation of a deskshell api.
*
var shellApp = deskShell.startApp({
	openSocket:true
	,openAppWin:true
	,htdocs:'/content'
	,width:500
	,height:500
		//optional parameters
		,port:8086
		,cport:8087
		,chromiumPath:'..path_to_chromium_binary'
});
*/
var Q = require("q");
var freeport = require("freeport");
var rDebug = require('chrome-rdebug').rDebug;
var request = require("request");
var fs = require("fs");
var path = require("path");
var mime = require("mime");

var shellApi = {
	v:"0.1"
	,loadEnv:function() {
		var loadingenv = Q.defer();
		try {
			deskShell.env = require(deskShell.envPath);
			deskShell.sysAppsDir = path.normalize(deskShell.installDir + deskShell.sysAppsDir)+path.sep;

			loadingenv.resolve();
		} catch(e) {
			//env setup was not found...
			//create it..
			var os = require('os');
			fs.readFile(deskShell.platformDir+"deskshell-env.js.sample."+os.platform(), 'utf8', function (err, data) {
				if (err) return loadingenv.reject(err);
				deskShell.env = JSON.parse(data);
				deskShell.sysAppsDir = path.normalize(deskShell.installDir + deskShell.sysAppsDir);

				fs.writeFile(deskShell.envPath,"module.exports="+ JSON.stringify(deskShell.env,null,4) , 'utf8', function (err, data) {
					if (err) return loadingenv.reject(err);
					loadingenv.resolve();
				});
			});
		}
		return loadingenv.promise;		
	}
	,getFreePort:function(app, port) {
		var getting = Q.defer();
		if (!port) {
			freeport(function(er, port) {
				if (er) getting.reject({error:er,app:app});
				getting.resolve({app:app,port:port});
			});
		} else {
			getting.resolve({app:app,port:port});
		}
		return getting.promise;		
	},getDebugSocket:function(app,appUrl,launching,timeout,tries) {
		if (tries == undefined) tries = 3;
		
		setTimeout(function() {
			request("http://localhost:"+app.cport+"/json", function(error, response, body) {
				var err = null;
				try {
					var chromeDebugOptions = JSON.parse(body);
				} catch(e) {
					launching.reject({error:e,app:app});
					err = e;
				}
				
				if (!err) {
					var chromeDebugUrl;
					for(var s=0;s<chromeDebugOptions.length;s++) {
						if ((chromeDebugOptions[s]['url'] == appUrl) && (chromeDebugOptions[s]['webSocketDebuggerUrl'])) {
							chromeDebugUrl = chromeDebugOptions[s].webSocketDebuggerUrl;
							console.log("found debug socket",chromeDebugUrl);
							break;
						}
					}
					if (!chromeDebugUrl) {
						if (tries > 40) {
							launching.reject({error:"Could not find debug websocket"});
						} else {
							shellApi.getDebugSocket(app,appUrl,launching,500,tries+1);
						}
					} else {
						//bugfix for wierd portable chrome on windows.
						if (chromeDebugUrl.indexOf('ws:///') > -1) {
							chromeDebugUrl = chromeDebugUrl.replace('ws:///','ws://localhost:'+app.cport+'/');
						}
						app.chromiumDebugUrl = chromeDebugUrl;
						app.rDebugApi = rDebug.openSocket(chromeDebugUrl);
						app.rDebugApi.on('*',function(event) {
							if (event.method == "Inspector.detached" && event.params && event.params['reason'] == "target_closed") {
								if (app.params['exitOnAppWinClose']) {
									console.log("auto close");
									process.exit(0);
								}
							}
							console.log("Event:",event);
						});
						launching.resolve(app);
					}
				}
				
			})
			
		},timeout);
		
	},startApp:function(params) {
		var starting = Q.defer();
		var myApp = {
			params:shellApi.appDef
		}
		for(var p in params) {
			myApp.params[p] = params[p];
		}
		if (typeof myApp.params['appSocket'] == 'undefined') myApp.params['appSocket'] = true;
		if (typeof myApp.params['openAppWin'] == 'undefined') myApp.params['openAppWin'] = true;
		if (typeof myApp.params['exitOnAppWinClose'] == 'undefined') myApp.params['exitOnAppWinClose'] = true;
		
			shellApi.getFreePort(myApp,myApp.params['port'])
			.then(function(dat) {
				var app = dat.app;
				app.port = dat.port;
				deskShell.env.port = dat.port;
				
				if (app.params['htdocs']) {
					//var fs = require('fs');
					if (!deskShell.appfs) deskShell.appfs = fs;
					app.server = require('http').createServer(myApp.params['serverHandler'] || function handler (req, res) {
						var handle = true;
						if (app.params['requestHandler']) {
							handle = app.params.requestHandler(req, res);
						}
						if (handle) {
							var serveFile = '';
							var reqfile = require("url").parse(req.url).pathname;	
							switch (reqfile) {
								case '/deskShell/clientApi.js':
									serveFile = __dirname + '/clientApi.js'
								break;
								default:
									if (deskShell.packageFile) {
										serveFile = app.params['htdocs'] + reqfile;
										if (serveFile.slice(-1) == '/') {
											serveFile += myApp.params['defaultLocation'];
										}
									} else {
										serveFile = deskShell.appDir + app.params['htdocs'] + reqfile;
										if (serveFile.slice(-1) == '/') {
											serveFile += myApp.params['defaultLocation'];
										}
									}
								break;
							}
							//console.log("serveFile",serveFile);
							var mimetype = require("mime").lookup(serveFile);
							
							var reader = deskShell.appfs.createReadStream(serveFile);
							var header = false;
							reader.on('data',function(buf) {
								if (!header) {
									header = true;
									res.writeHead(200,{"Content-Type": mimetype});
								}
								res.write(buf);
							});
							reader.on('end',function(buf) {
								res.end(buf);
							});
							reader.on('error',function(err) {
								switch(err.code) {
									case 'ENOENT':
										res.writeHead(404);
								 		return res.end('File not found '+req.url);
									break;
									default:
										res.writeHead(500);
										return res.end('Error loading '+req.url+" "+err.message);
									break;
								}
							});
						}
					});
					app.server.listen(app.port);
					console.log("serving application on port:",app.port);
				}
				return app;
			}).then(function(app) {
				
				if (app.params['appSocket']) {
					var io = require("socket.io").listen(app.server);
					io.set('log level',1);
					app.socketio = io;
					deskShell.socketio = io;
					if (app.params['deskShellSocketClient']) {
						app.socketio.on('connection', function(socket) {
							//send them deskshell info.
							console.log(deskShell.env);
							socket.emit('deskShell',{
								app:deskShell.appDef
							});
						});
					}
				}
				return app;
			}).then(function(app) {
				//launch chrome
				var launching = Q.defer();
				if (app.params['openAppWin']) {
					shellApi.getFreePort(app,shellApi.env.chromeDebugPort||app.params['port'])
					.then(function(dat) {
						var app = dat.app;
						app.cport = dat.port;
						shellApi.env.chromeDebugPort = dat.port;
						//launch chrome
						if (!app.params['chromiumPath']) app.params['chromiumPath'] = path.normalize(deskShell.platformDir + "/" +shellApi.env.chromiumPath);
						//http://peter.sh/experiments/chromium-command-line-switches/
						//--window-position
						
						var appUrl ='http://localhost:'+myApp.port+'/';
						if (shellApi.appDef['startUri']) appUrl += shellApi.appDef['startUri'];
						
						if (shellApi.appDef['mode'] && shellApi.appDef['mode'] == 'kiosk') {
							if (!app.params['chromiumCmd']) app.params['chromiumCmd'] =  [	
								'--kiosk'
								,'--remote-debugging-port='+app.cport
								/*,'--user-data-dir=../../../../chrome-profile'*/
					 		];
							console.log("kiosk mode");
							console.log(app.params['chromiumPath']+" "+app.params['chromiumCmd'].join(' ')+' '+appUrl);
							app.chromium = require('child_process')
								.exec(app.params['chromiumPath']+" "+app.params['chromiumCmd'].join(' ')+' '+appUrl,function(error, stdout, stderr) {
									if (error) console.log("chromium exec error:"+error);
							});
						} else {
							if (!app.params['chromiumCmd']) app.params['chromiumCmd'] =  [	
								'--app='+appUrl
								,'--remote-debugging-port='+app.cport
								,'--disable-translate'
							];
							if (app.params['user-data-dir']) {
								app.params['chromiumCmd'].push('--user-data-dir='+app.params['user-data-dir']);
							} else {
								app.params['chromiumCmd'].push('--user-data-dir=../../../../chrome-profile');
							}
							if (app.params['width']) {
								app.params['chromiumCmd'].push('--app-window-size='+(app.params['width'])+','+app.params['height']);
							} else if (shellApi.appDef['width']) {
								app.params['chromiumCmd'].push('--app-window-size='+(shellApi.appDef['width'])+','+shellApi.appDef['height']);
							}
							
							if (app.params['chromiumFlags']) {
								for(var i=0;i<app.params['chromiumFlags'];i++) {
									app.params['chromiumCmd'].push(app.params['chromiumFlags'][i]);
								}
							}
							
							var exec = require('child_process').exec;
							app.chromium = require('child_process')
								.exec('"'+app.params['chromiumPath']+'" '+app.params['chromiumCmd'].join(' '),function(error, stdout, stderr) {
									if (error) console.log("chromium exec error:"+error);
							});
							
						}
						console.log("chrome debug port:",app.cport);
						console.log(appUrl);
						
						var findSocket = Q.defer();
						shellApi.getDebugSocket(app,appUrl,findSocket,200)
						launching.resolve(app);
					});
				} else {
					launching.resolve(app);
				}
				return launching.promise;
			}).then(function(app) {
				starting.resolve(app);
			}).fail(function(error) {
				console.log("error starting app",error);
				starting.reject(error);
			});
		return starting.promise;
	},rescueDeskshell:function(reason,err,exit) {
		//Super handler called whenever something major happens to keep deskshell running
		//or to respond before shutting down.
		
		//tell console
		console.log(reason,err);
		try {
			//try to tell the browser about this problem
			deskShell.socketio.sockets.emit("exit",{reason:reason,err:err});
		} catch(e) {
		}
		try {
			//try to write the error to disk.
			fs.appendFile(deskShell.appDir+"deskshell.log", reason+(err.message||err)+"\n", function(err) {});
		} catch(e) {
		}
		if(exit) exit();
	},platformUpdateAvailable:function(callback) {
		var request = require("request");
		request(deskShell.env.platformUpdateVersionUrl, function(error, response, body) {
			if (error) {
				console.log("update failed:"+error);
			} else {
				var lines = body.split("\n");
				fs.readFile(deskShell.platformDir+"installer-version.txt", 'utf8', function (err, data) {
					if (err) {
						//installer version not defined, you are probably running from a git checkout.
					} else {
						var lines2 = data.split("\n");
						if (upgradeNeeded(lines[0],lines2[0])) {
							callback(lines[0].replace(/\r/, ''),lines2[0]);
						}
					}
				});
			}
		});
	
	},appUpdateAvailable:function(callback) {
		var request = require("request");
		request(deskShell.appInfo.appUpdateVersionUrl, function(error, response, body) {
			if (error) {
				console.log("update failed:"+error);
			} else {
				var lines = body.split("\n");
				if (upgradeNeeded(lines[0],deskShell.appInfo.version)) {
					callback(lines[0].replace(/\r/, ''),deskShell.appInfo.version);
				}
			}
		});
	
	}
	
	//simple wrappers
	,ifexists:function(path) {
		var checking = Q.defer();
		fs.exists(path, function(exists) {
			if (!exists) {
				return checking.reject(path + "not found");
			} else {
				return checking.resolve();
			}
		});
		return checking.promise;
	}
	,launchApp:function(path) {
		//launch another app.
		require('child_process')
			.exec('"'+deskShell.installDir+deskShell.env.deskShellExe+'" "'+path+'"',function(error, stdout, stderr) {
				if (error) console.log("launchApp exec error:"+error);
		});
	},launchAppDebug:function(path) {
		//launch another app.
		console.log(path);
		require('child_process')
			.exec('"'+deskShell.installDir+deskShell.env.deskShellExeDebug+'" "'+path+'"',function(error, stdout, stderr) {
				if (error) console.log("launchApp exec error:"+error);
		});
	},clientApiData:function() {
		/**
		* Provide a json file to the client holding information about deskshell.
		*/
		var deskShellClientApi = {
			v:shellApi.v
			,userAppDir:path.normalize(deskShell.platformDir+path.sep+'..'+path.sep+'..'+path.sep+'..'+path.sep+'deskshell-apps')
		}
		return deskShellClientApi;
	}
}

exports.api = shellApi;