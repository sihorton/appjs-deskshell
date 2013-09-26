var running = deskShell.startApp({
	htdocs:__dirname+'/htdocs/'
	,openSocket:true
	,launchChromium:true
	,exitOnChromiumClose:true
	,chromiumFlags:['--kiosk']
});