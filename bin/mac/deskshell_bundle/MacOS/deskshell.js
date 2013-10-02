/**
* deskshell apple script or windows executable will run this script and pass in any command line arguments.
* it will read the application json file, setup required environment and then run the application.
*/
if (process.argv.length <3) {
	//if no args run default application.
	process.argv[2] = __dirname + "/../../../../../sys-apps/demo-docs/demo-docs.desk";
}
var Q = require("q"),fs=require("fs"),path = require("path");

GLOBAL.deskShell = require("deskshell-api").api;
deskShell.appFile = process.argv[2];
deskShell.appDir = path.dirname(process.argv[2]) + "/";
if (deskShell.appDir == "./") {
	//todo fix relative path launches...
}
deskShell.platformDir = __dirname;
deskShell.ifexists(deskShell.appFile)
	.then(function() {
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
		require(deskShell.mainFile);
	}).fail(function(err) {
		//we should popup a window or write out error to disk.
		//maybe we can have a separate exe or similar to popup the message in windows.
		// TODO: No biggie on Mac, CocoaDialog can resolve this. Will be added later~
		errortext = "";
		switch (typeof err) {
			case "string":
				errortext += "Error:"+err+"\n";
			break;
			default:
				errortext += "Error:"+err.toString()+"\n";
			break;
		}
		require("child_process").spawn(
			__dirname+"/CocoaDialog.app/Contents/MacOS/CocoaDialog",
			[
				"msgbox",
				"--title","nodeJS error",
				"--informative-text","There was an error while processing the application. ('+errortext+')",
				"--button1","Okay"
			]
		);
	});