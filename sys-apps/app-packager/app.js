var path = require("path")
	,fs = require("fs")
	,appfs = require("sihorton-vfs")
	,path = require("path")
;

var config = {
	packageExt:'.appfs'
	,deployFolder:'deploy'
	,extractFolder:'/extract/'
}

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
					folder:path.normalize(deskShell.platformDir+'\\..\\..\\..\\deskshell-apps')
					,name:'test'
					,v:"0.1"
					,author:"changeme@example.com"
					,htdocs:"htdocs"
					,defaultLocation:"index.htm"
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
									socket.emit('progress',{type:"info",text:appFolder+"/"+params.htdocs});
									
									fs.writeFile(appFolder+"/"+params.htdocs+"/index.htm", "<html><title>"+params.name+"</title><body><h2>Hello World</h2><p>Edit me and add your content</p></body></html>" ); 
									fs.writeFile(appFolder+"/app.js","var running = deskShell.startApp({});");
									socket.emit('AppCreated',appFolder+"/"+params.name+".desk");
									socket.emit('progress',{type:"success",text:appFolder+"/"+params.name+".desk"});
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
				fs.readFile(__dirname+"/app.sample.nsi", 'utf8', function (err, data) {
					fs.writeFile(params.folder+"/app.nsi", data,function(err) {
						socket.emit('AppExeCreated',params.folder+"/app.nsi");
						socket.emit('progress',{type:"success",text:params.folder+"/app.nsi"});
					}); 
							
				});
			} catch(err) {
				socket.emit('progress',{type:"error",text:err.toString()});
			}
		});
		
		socket.on('LaunchPackagedApp',function(params) {
			if (params.relpath) {
				deskShell.launchApp(require("path").normalize(deskShell.appDir + params.relpath));
			}
			if (params.abspath) {
				deskShell.launchApp(require("path").normalize(params.abspath));
			}
		});
		socket.on('PackageApp',function(params) {
			console.log("packageApp",params);
			if (params.relpath) {
				//deskShell.launchApp(require("path").normalize(deskShell.appDir + params.relpath));
				appFolder = path.dirname(require("path").normalize(deskShell.appDir + params.relpath));
				appFolder = path.resolve(appFolder);
				appPackage = path.resolve(deskShell.appDir + params.relpath);
			
			}
			if (params.abspath) {
				//deskShell.launchApp(require("path").normalize(params.abspath));
				appFolder = path.dirname(require("path").normalize(params.abspath));
				appFolder = path.resolve(appFolder);
				appPackage = path.resolve(params.abspath);
			
			}
			console.log(appFolder);
			console.log(appPackage);
			
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
						,'.git':'.git'
					}
					walk(appFolder,function(err,files) {
						if (err) {
							process.stdout.write('Error:' + err);
						} else {
							//we should now have a complete list of files to add to package...
							//delete existing and create new package file...
							var packagef = '/'+config.deployFolder+'/app.appfs';
							fs.unlink(appFolder+packagef,function() {
							appfs.Mount(appFolder+packagef,function(vfs) {
								var filepos=files.length;
								var addAnotherFile = function() {
									filepos--;
									if (filepos>-1) {
										//console.log(files[filepos].name);
										var reader = fs.createReadStream(files[filepos].path);
										var packageFile = path.relative(appFolder,files[filepos].path);
										var writepackageFile = packageFile.split("\\").join("/");
										var writer = vfs.createWriteStream(writepackageFile);
										writer.on('close',function() {
											socket.emit("packageProgress",{text:"added "+writepackageFile});
											addAnotherFile();
										});
										reader.pipe(writer);
									} else {
										//check there is an app.desk
										console.log("app.desk check",vfs.dirs['app.desk']);
										if (!vfs.dirs['app.desk']) {
											//take desk file and add it as app.desk
											var reader = fs.createReadStream(appPackage);
											var writer = vfs.createWriteStream("app.desk");
											writer.on('close',function() {
												socket.emit("packageProgress",{text:"added app.desk"});
												vfs._writeFooter(function() {
													console.log("wrote footer");
													socket.emit("packageProgress",{text:"package created: "+packagef});	
												});
												
											});
											reader.pipe(writer);
										} else {
											vfs._writeFooter(function() {
												console.log("wrote footer");
												socket.emit("packageProgress",{text:"package created: "+packagef});
												
											});
										}
									}
								}
								addAnotherFile();
							});
							});
						}
					},exclude,appFolder,true);
				});
					
				
			});
			
			
			
			
		});
		socket.on('PackageAppExe',function(params) {
			var path = require("path");
			if (params.relpath) {
				//deskShell.launchApp(require("path").normalize(deskShell.appDir + params.relpath));
				appFolder = path.dirname(require("path").normalize(deskShell.appDir + params.relpath));
				appFolder = path.resolve(appFolder);
				appPackage = path.resolve(deskShell.appDir + params.relpath);
			
			}
			if (params.abspath) {
				//deskShell.launchApp(require("path").normalize(params.abspath));
				appFolder = path.dirname(require("path").normalize(params.abspath));
				appFolder = path.resolve(appFolder);
				appPackage = path.resolve(params.abspath);
			
			}
			console.log(appFolder);
			console.log(appPackage);
			var path=require("path")
			appfs = require("sihorton-vfs")
			fs = require("fs")
			Q = require("q");
			;
			var exec = require('child_process').exec,
			child;

			var nsis = "D:\\portable\\PortableApps\\NSISPortable\\App\\NSIS\\makensis.exe";
			var nsisFile = appFolder+"\\app.nsi";
			
			var appfsFile = appFolder+"\\deploy\\app.appfs";
			var outf = appFolder+"\\deploy\\app.appfs.temp.appfs";

			var exeFile = appFolder+"\\deploy\\app.exe";
			var exeFile2 = appFolder+"\\deploy\\app.exe";
			console.log("creating exe");
			socket.emit("packageProgress",{text:"compiling: "+nsisFile});
										
			child = exec('"'+nsis+'" "'+nsisFile+'"',function(error,stdout,sterr) {
				if (error) {
					console.log(error);
				} else {
					console.log(stdout);
					console.log(sterr);

						
						
					var stats = fs.statSync(exeFile);
					socket.emit("packageProgress",{text:"copying package"});
					var out = fs.createWriteStream(outf);
					fs.createReadStream(appfsFile).pipe(out);
					out.on('close',function() {
						appfs.Mount(outf,function(vfs) {			
							console.log("opening appfs");
							//console.log(vfs.dirs);
							socket.emit("packageProgress",{text:"adjusting file offsets"});
			
							vfs.moveOffset(stats.size,function() {
								//we now have a completed package...
								//create exe.
								console.log("creating exe package");
								socket.emit("packageProgress",{text:"merging package into exe"});
			
								console.log('copy /b "'+exeFile+'"+"'+outf+'" "'+exeFile2+'"');
								child = exec('copy /b "'+exeFile+'"+"'+outf+'" "'+exeFile2+'"',function(error,stdout,sterr) {
									if (error) {
										console.log(error);
									} else {
										console.log(stdout);
										console.log(sterr);
										//clean up
										fs.unlink(outf);
										console.log("exe created" + exeFile);
										socket.emit("packageProgress",{text:"exe created: "+exeFile});
											
									}
								});
							});
						})
					});
				}
			});
		});
	});
	
});


//Support function to scan dir recursively
var walk = function(dir, done, exclude, basePath, silent) {
console.log("basePath",basePath);

  var results = [];
  if (!basePath) basePath = dir.length+1;
  fs.readdir(dir, function(err, list) {
    if (err) return done(err);
    var pending = list.length;
    if (!pending) return done(null, results);
    list.forEach(function(file) {
      file = dir + '/' + file;
	  	  fs.stat(file, function(err, stat) {
			//console.log("exclude?",file.substring(basePath.length+1));
			if (exclude[file.substring(basePath.length+1)]) {
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