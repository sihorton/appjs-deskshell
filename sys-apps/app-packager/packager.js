var path = require("path")
	,fs = require("fs")
	,appfs = require("sihorton-vfs")
;

var config = {
	packageExt:'.appfs'
	,deployFolder:'deploy'
	,extractFolder:'/extract/'
}

if (process.argv.length < 3) {
	console.log("usage: "+path.basename(__filename,".js")+" <desk file to package>");
	console.log("usage: "+path.basename(__filename,".js")+" <package file to unpackage>");
	process.exit(1);
}
var appFolder = './';
var appPackage = 'app.desk';

fs.stat(process.argv[2], function(err, stats) {
	if (err) {
		console.log(err);
		process.exit(1);
	}
	console.log(process.argv[2]);
	console.log(path.extname(process.argv[2]));
	switch(path.extname(process.argv[2])) {
		case '.desk':
			//package this application...
			appFolder = path.dirname(process.argv[2]);
			appFolder = path.resolve(appFolder);
			appPackage = path.resolve(process.argv[2]);
			
			console.log("appFolder",appFolder);
			console.log("appPackage",appPackage);

			fs.mkdir(appFolder+'/'+config.deployFolder, function(err) {
				//if (err) console.log(err);
				
				
				fs.readFile(appPackage, 'utf8', function (err,data) {
				  if (err) {
					console.log(err);
				  } else {
					try { 
						appInfo = JSON.parse(data);
					} catch(e) {
						console.log("error reading desk file");
						console.log(e);
					}
				  }
				  console.log(appInfo);
					var exclude= {
						'bin':'bin'
						,'node_modules':'node_modules'
						,'deploy':'deploy'
					}
					console.log(appFolder);
					walk(appFolder,function(err,files) {
						if (err) {
							process.stdout.write('Error:' + err);
						} else {
							//we should now have a complete list of files to add to package...
							//delete existing and create new package file...
							fs.unlink(appFolder+'/'+config.deployFolder+'/app.appfs',function() {
							appfs.Mount(appFolder+'/'+config.deployFolder+'/app.appfs',function(vfs) {
								var filepos=files.length;
								var addAnotherFile = function() {
									filepos--;
									if (filepos>-1) {
										//console.log(files[filepos].name);
										var reader = fs.createReadStream(files[filepos].path);
										var packageFile = path.relative(appFolder,files[filepos].path);
										var writer = vfs.createWriteStream(packageFile);
										writer.on('close',function() {
											console.log("wrote "+packageFile);
											addAnotherFile();
										});
										reader.pipe(writer);
									} else {
										console.log(vfs.dirs);
										vfs._writeFooter(function() {
											console.log("wrote footer");
										});
									}
								}
								addAnotherFile();
							});
							});
						}
					},exclude,appFolder,true);
				});
					
				
			});
			break;
			case '.appfs':
			appPackage = path.resolve(process.argv[2]);
			appFolder = path.dirname(appPackage)+config.extractFolder;
			appfs.Mount(appPackage,function(vfs) {
				var files = [];
				for(var f in vfs.dirs) {
					files.push(f);
				}
				process.stdout.write("unpacking "+appPackage+'\n');
				var filepos=files.length;
				var extractAnotherFile = function() {
					filepos--;
					if (filepos>-1) {
						fs.mkdir(path.dirname(appFolder+'/'+files[filepos]), function(err) {
							var writer = fs.createWriteStream(appFolder+'/'+files[filepos]);
							var reader = vfs.createReadStream(files[filepos]);
							writer.on('close',function() {
								console.log("extracted "+files[filepos]);
								extractAnotherFile();
							});
							reader.pipe(writer);
						});
					} else {
						console.log("completed");
					}
				}
				extractAnotherFile();
			});
			break;
		break;
	}
});




//Support function to scan dir recursively
var walk = function(dir, done, exclude, basePath, silent) {
  var results = [];
  if (!basePath) basePath = dir.length+1;
  fs.readdir(dir, function(err, list) {
    if (err) return done(err);
    var pending = list.length;
    if (!pending) return done(null, results);
    list.forEach(function(file) {
      file = dir + '/' + file;
	  	  fs.stat(file, function(err, stat) {
			if (exclude[file.substring(basePath)]) {
				//process.stdout.write("excluding:"+file.substring(basePath)+'\n');
				if (!--pending) done(null, results);
			} else {
		  
				if (stat && stat.isDirectory()) {
				  walk(file, function(err, res) {
					results = results.concat(res);
					if (!--pending) done(null, results);
				  },exclude, basePath, silent);
				} else {
					if (silent) {
					}else {
						console.log("\t",file.substring(basePath));
					}
					results.push({name:file.substring(basePath),path:file});
				  if (!--pending) done(null, results);
				}
			}
		  });
		 
    });
  });
};