var fs = require('fs');
fs.writeFile("deskshell.log", process.argv.join("\n"), function(err) {
	if(err) {
		console.log(err);
	}
});