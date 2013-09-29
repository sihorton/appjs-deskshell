var http = require('http');
var server = http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello World\n');
}).listen(0,function() {
	address = server.address();
	var port = address.port;
	console.log('Hello World Server running at http://localhost:'+port+'/');
});
