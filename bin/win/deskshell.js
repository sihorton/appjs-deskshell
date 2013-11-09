/**
* deskshell apple script or windows executable will run this script and pass in any command line arguments.
* it will read the application json file, setup required environment and then run the application.
*/
process.title = "Deskshell";

process.on('SIGINT', function() {
  deskShell.rescueDeskshell('Shutting Down:Recieved SIGINT','SIGINT',function() {process.exit();});
});
process.on('SIGQUIT', function() {
  deskShell.rescueDeskshell('Shutting Down:Recieved SIGQUIT','SIGQUIT',function() {process.exit();  });
});
process.on('SIGABRT', function() {
  deskShell.rescueDeskshell('Shutting Down:Recieved SIGABRT','SIGABRT',function() {process.exit();  });
});
process.on('SIGTERM', function() {
  deskShell.rescueDeskshell('Shutting Down:Recieved SIGTERM','SIGTERM',function() {process.exit();  });
});
process.on('uncaughtException',function(err) {
	deskShell.rescueDeskshell('UncaughtException:'+(err.message||err),err);
});

var Q = require("q"),fs=require("fs"),path = require("path")
,appfs = require(__dirname + "/node_modules/sihorton-vfs/sihorton-vfs.js");
GLOBAL.deskShell = require(__dirname + "/node_modules/deskshell-api").api;
deskShell.platformDir = __dirname+"/";
deskShell.installDir = path.normalize(__dirname + "/../../")+"/";
deskShell.envPath = deskShell.installDir + "/deskshell-env.js";
	
	deskShell
	.loadEnv()
	.then(function() {
		//force chrome path upgrade (windows code)
		if (deskShell.env['chromiumPath'] == 'GoogleChromePortable/App/Chrome-bin/chrome.exe') {
			deskShell.env['chromiumPath'] = 'DeskshellChrome/App/Chrome-bin/deskshell-chrome.exe';
		}
	
		deskShell.defaultApp = false;
		if (process.argv.length <3) {
			//if no args run default application.
			deskShell.defaultApp = true;
			process.argv[2] = deskShell.installDir+deskShell.env.defaultApp;
		}
		deskShell.appFile = process.argv[2];
		deskShell.appDir = path.dirname(process.argv[2]) + "/";
		return deskShell.ifexists(deskShell.appFile);
	}).then(function() {
		if (deskShell.defaultApp) {
			//running default app, so also check for updates.
			if (deskShell.env['checkForPlatformUpdates']) {
				var request = require("request");
				request(deskShell.env.platformUpdateVersionUrl, function(error, response, body) {
					if (error) return console.log("update failed:"+error);
					var lines = body.split("\n");
					fs.readFile(__dirname+"/installer-version.txt", 'utf8', function (err, data) {
						if (err) {
							//installer version not defined, you are probably running from a git checkout.
						} else {
							var lines2 = data.split("\n");
							console.log("checking if upgrade available:",lines[0].replace(/\r/, '')+">"+lines2[0]);
							if (upgradeNeeded(lines[0],lines2[0])) {
								console.log("upgrade available, launching updater.");
								console.log(path.normalize(deskShell.platformDir + "/" +deskShell.env.updaterPath));
								require('child_process').exec(path.normalize(deskShell.platformDir + "/" +deskShell.env.updaterPath),function(error, stdout, stderr) {
									if (error) console.log("upgrade failed.");
								});
							} else {
								console.log("no upgrade available.");
							}
						}
					});
				});
			}
		}
		//file found.
		var reading = Q.defer();
		if (deskShell.env.appHandlers && deskShell.env.appHandlers[path.extname(deskShell.appFile)]) {
			console.log("handler file");
			deskShell.appLaunchFile = deskShell.appFile;
			var appHandler = deskShell.env.appHandlers[path.extname(deskShell.appFile)];
			deskShell.appFile = deskShell.installDir+"plugins/"+appHandler.app;
			deskShell.appDir = path.dirname(deskShell.appFile)+"/";
			
			console.log("launching handler:",deskShell.appFile);
			//ideally handlers would actually be a package file.
			deskShell.packageFile = false;
			deskShell.appfs = fs;
			fs.readFile(deskShell.appFile, 'utf8', function (err, data) {
				if (err) {
					return reading.reject(err);
				}
				try {
					deskShell.appDef = JSON.parse(data);
					deskShell.mainFile = deskShell.appDir + deskShell.appDef.main;
				} catch(e) {
					return reading.reject(e);
				}
				return reading.resolve();
			});
		} else {
			if (path.extname(deskShell.appFile) == ".appfs" || path.extname(deskShell.appFile) == ".exe") {
				console.log("package file");
				deskShell.packageFile = true;
				appfs.Mount(deskShell.appFile,function(vfs) {			
					deskShell.appfs = vfs;
					deskShell.appfs.readFile("app.desk", 'utf8', function (err, data) {
						if (err) {
							return reading.reject(err);
						}
						try {
							deskShell.appDef = JSON.parse(data);
							deskShell.mainFile = deskShell.appDef.main;
						} catch(e) {
							return reading.reject(e);
						}
						return reading.resolve();
					});
				});
			} else {
				deskShell.packageFile = false;
				deskShell.appfs = fs;
				fs.readFile(deskShell.appFile, 'utf8', function (err, data) {
					if (err) {
						return reading.reject(err);
					}
					try {
						deskShell.appDef = JSON.parse(data);
						deskShell.mainFile = deskShell.appDir + deskShell.appDef.main;
					} catch(e) {
						return reading.reject(e);
					}
					return reading.resolve();
				});
			}
		}
		return reading.promise;
	}).then(function() {
		
		switch(deskShell.appDef.backend) {
			case "node":
			case "nodejs":
				if (deskShell.packageFile) {
					
					deskShell.appfs.readFile(deskShell.mainFile, 'utf8', function (err, data) {
						try {
							process.chdir(deskShell.appDir);
							var oldDir = __dirname;
							__dirname = deskShell.appDir;
							eval(data.toString());
							__dirname = oldDir;
						} catch(e) {
							throw e;
						}
					});
				} else {
					require(deskShell.mainFile);
					
				}
			break;
			case "none":
				//html only backend...
				var running = deskShell.startApp({});
			break;
			default:
				return new Error("Backend not implemented:" + deskShell.appDef.backend);
			break;
		}
	}).fail(function(err) {
		//we should popup a window or write out error to disk.
		//maybe we can have a separate exe or similar to popup the message in windows.
		var fs = require('fs');
		errortext = "";
		switch (typeof err) {
			case "string":
				errortext += "Error:"+err+"\n";
			break;
			default:
				errortext += "Error:"+err.toString()+"\n";
				console.log(err);
			break;
		}
		fs.appendFile("deskshell.log", errortext, function(err) {});
	});
	
/**
* Compare requested version number against installed version number
* and return true if an upgrade is needed.
* UpgradeNeeded("0.3.2345.5","0.3")=>true
* UpgradeNeeded("0.3.2345.5","0.3.2345")=>true
* UpgradeNeeded("0.3.2345.5","0.3.2345.5")=>false
* UpgradeNeeded("0.3.2345.5","0.4")=>false
*/
function upgradeNeeded(requested,installed) {
		var req = requested.replace("v","").split(".");
		var got = installed.replace("v","").split(".");
		var diff = req.length - got.length;
		if (diff > 0) {
			for(var i = diff;diff>0;diff--) {
				got.push(0);
			}
		} else {
			for(var i = diff;diff<0;diff++) {
				req.push(0);
			}
		}
		for(var p=0;p<req.length;p++) {
			if (req[p] == "x") return false;
			var r = parseFloat(req[p]);
			var g = parseFloat(got[p]);
			if (r > g) return true;
			if (r < g) return false;
			//if equal compare next figure
		}
		return false;
}