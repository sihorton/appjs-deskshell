/**
* deskshell apple script or windows executable will run this script and pass in any command line arguments.
* it will read the application json file, setup required environment and then run the application.
*/
var Q = require("q"),fs=require("fs"),path = require("path");
GLOBAL.deskShell = require(__dirname + "/node_modules/deskshell-api").api;
deskShell.defaultApp = false;
if (process.argv.length <3) {
	//if no args run default application.
	deskShell.defaultApp = true;
	process.argv[2] = __dirname + "/../../sys-apps/demo-docs/demo-docs.desk";
}
deskShell.appFile = process.argv[2];
deskShell.appDir = path.dirname(process.argv[2]) + "/";
if (deskShell.appDir == "./") {
	//todo fix relative path launches...
}
deskShell.platformDir = __dirname;
deskShell.ifexists(deskShell.appFile)
	.then(function() {
		var loadingenv = Q.defer();
		try {
			deskShell.env = require(__dirname+"/deskshell-env.js");
			loadingenv.resolve();
		} catch(e) {
			//env setup was not found...
			//create it..
			var os = require('os');
			fs.readFile(__dirname+"/deskshell-env.js.sample."+os.platform(), 'utf8', function (err, data) {
				if (err) return loadingenv.reject(err);
				deskShell.env = JSON.parse(data);
				fs.writeFile(__dirname+"/deskshell-env.js","module.exports="+ JSON.stringify(deskShell.env,null,4) , 'utf8', function (err, data) {
					if (err) return loadingenv.reject(err);
					loadingenv.resolve();
				});
			});
		}
		return loadingenv.promise;
	}).then(function() {
		if (deskShell.defaultApp) {
			//running default app, so also check for updates.
			var request = require("request");
			request("http://raw.github.com/sihorton/appjs-deskshell/master/installer/win/common/installer-version.txt", function(error, response, body) {
				if (error) return console.log("update failed:"+error);
				var lines = body.split("\n");
				fs.readFile(__dirname+"/../../version.txt", 'utf8', function (err, data) {
					var lines2 = data.split("\n");
					console.log("checking if upgrade needed:",lines[0]+">"+lines2[0]);
					if (upgradeNeeded(lines[0],lines2[0])) {
						require('child_process').exec(__dirname+"/../../deskshell-updater.exe",function(error, stdout, stderr) {
							if (error) console.log(error);
						});
					}
				});
			});
		}
		//file found.
		var reading = Q.defer();
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
		return reading.promise;
	}).then(function() {
		
		switch(deskShell.appDef.backend) {
			case "node":
			case "nodejs":
				require(deskShell.mainFile);
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