console.log("hello world application running.");
//hack for moment, hardcoded path to nodejs modules directory.
var platformModulesDir = "../../../bin/win/node_modules/";
var rDebug = require(platformModulesDir + '/chrome-rdebug/index.js').rDebug;
var request = require(platformModulesDir + "request/index.js");

request("http://localhost:9222/json", function(error, response, body) {
	var chromeDebugOptions = JSON.parse(body);
	var chromeDebugUrl = chromeDebugOptions[0].webSocketDebuggerUrl;
	
	//bugfix for wierd portable chrome on windows.
	if (chromeDebugUrl.indexOf('ws:///') > -1) {
		chromeDebugUrl = chromeDebugUrl.replace('ws:///','ws://localhost:9222/');
	}
	console.log("websocket url",chromeDebugUrl);
	
	var rDebugApi = rDebug.openSocket(chromeDebugUrl);

	rDebugApi.ws.on('close',function() {
		console.log('disconnected');
	});
	var printErr = function(err) {
		console.log("error:"+err.error.code+" "+err.error.message);
	};
	rDebugApi.on('*',function(event) {
		console.log("Event:",event);
	});
	rDebugApi.ws.on('open',function() {
		console.log('debug api connected');
		
		rDebugApi.domGetDocument().then(function(doc) {
			rDebugApi.domGetOuterHTML(doc.root.nodeId)
			.then(function(res) {
				//console.log("page html:",res.outerHTML);
				rDebugApi.pageNavigate("http://appjs.com").then(function() {
					setTimeout(function(){
						rDebugApi.pageNavigate("about:blank")
					},5000);
				}).fail(function(err) {
				console.log("error:"+err.error.code+" "+err.error.message);
				});
			}).fail(function(err) {
				console.log("error:"+err.error.code+" "+err.error.message);
			});
		}).fail(printErr);
	});
});
console.log("loaded");