/**
* deskshell apple script or windows executable will run this script and pass in any command line arguments.
*/
//debug for now, write all command line args to a log file.
var fs = require('fs');
fs.writeFile("deskshell.log", process.argv.join("\n"), function(err) {
	if(err) {
		console.log(err);
	}
});
if (process.argv.length <3) {
	//no arguments passed, run default app.
	//maybe detect os and then run default for that os...
	//as a quick demo for now just include and run...
	//we can create default objects / api and everything here.
	require(__dirname + "/../../sys-apps/default-win/default.desk");
} else {
	//again quick demo for now, just include the script.
	require(process.argv[3]);
}