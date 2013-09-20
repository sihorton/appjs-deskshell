/**
* @author: sihorton
* Implementation of a deskshell api.
*
var shellApp = deskShell.startApp({
	openSocket:true
	,launchChromium:true
	,htdocs:'/content'
		//optional parameters
		,port:8086
		,cport:8087
		,chromiumPath:'..path_to_chromium_binary'
});
*/
var defaultChromiumPath = require('path').normalize(__dirname +"/../../GoogleChromePortable/App/Chrome-bin/chrome.exe");
var Q = require("q");
var freeport = require("freeport");
var rDebug = require('chrome-rdebug').rDebug;
var request = require("request");

var shellApi = {
	v:0.1
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
	},startApp:function(params) {
		var starting = Q.defer();
		var myApp = {
			params:params
		}
			shellApi.getFreePort(myApp,myApp.params['port'])
			.then(function(dat) {
				var app = dat.app;
				app.port = dat.port;
				if (app.params['htdocs']) {
					var fs = require('fs');
					app.server = require('http').createServer(myApp.params['serverHandler'] || function handler (req, res) {
						if (req.url =='/')req.url = '/index.htm';
					  fs.readFile(app.params['htdocs'] + req.url,function (err, data) {
						if (err) {
						  res.writeHead(500);
						  return res.end('Error loading '+req.url);
						}
						res.writeHead(200);
						res.end(data);
					  });
					});
					app.server.listen(app.port);
					console.log("serving application on port:",app.port);
				}
				return app;
			}).then(function(app) {
				if (app.params['openSocket']) {
					var io = require("socket.io").listen(app.server);
					io.set('log level',1);
					app.socketio = io
				}
				return app;
			}).then(function(app) {
				//launch chrome
				var launching = Q.defer();
				if (app.params['launchChromium']) {
					shellApi.getFreePort(app,app.params['port'])
					.then(function(dat) {
						var app = dat.app;
						app.cport = dat.port;
				
						//launch chrome
						if (!app.params['chromiumPath']) app.params['chromiumPath'] =defaultChromiumPath;
						//http://peter.sh/experiments/chromium-command-line-switches/
						//currently these extra switches are not working, more investigation required.
						if (!app.params['chromiumCmd']) app.params['chromiumCmd'] =  [
							
							'--app=http://localhost:'+myApp.port+'/'
							,'--remote-debugging-port='+app.cport
							,'--user-data-dir=../../../../chrome-profile'
							,'--app-window-size=400,500'
							
						];
						var exec = require('child_process').exec;
						
						app.chromium = require('child_process')
							.exec(app.params['chromiumPath']+" "+app.params['chromiumCmd'].join(' '),function(error, stdout, stderr) {
							console.log(stdout);
							console.log(stderr);
							if (error) console.log("chromium exec error:"+error);
						});
						console.log("chrome debug port:",app.cport);
						request("http://localhost:"+app.cport+"/json", function(error, response, body) {
							var err = null;
							try {
								var chromeDebugOptions = JSON.parse(body);
							} catch(e) {
								launching.reject({error:e,app:app});
								err = e;
							}
							if (!err) {
								var chromeDebugUrl = chromeDebugOptions[0].webSocketDebuggerUrl;
							
								//bugfix for wierd portable chrome on windows.
								if (chromeDebugUrl.indexOf('ws:///') > -1) {
									chromeDebugUrl = chromeDebugUrl.replace('ws:///','ws://localhost:'+myApp.cport+'/');
								}
								console.log("websocket url",chromeDebugUrl);
								app.chromiumDebugUrl = chromeDebugUrl;
								app.rDebugApi = rDebug.openSocket(chromeDebugUrl);
								app.rDebugApi.on('*',function(event) {
									console.log("Event:",event);
								});
								launching.resolve(app);
							}
						});
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
	}
}

exports.api = shellApi;