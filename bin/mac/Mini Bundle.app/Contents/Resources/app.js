var running = deskShell.startApp({
	htdocs:__dirname+'/htdocs/'
	,openSocket:true
	,launchChromium:true
	,exitOnAppWinClose:true
	,chromiumFlags:['--kiosk']
});