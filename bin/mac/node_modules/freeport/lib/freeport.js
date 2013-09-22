var net = require('net')

module.exports = function(cb) {
  var server = net.createServer()
    , port = 0
  server.on('listening', function() {
    port = server.address().port
    server.close()
  })
  server.on('close', function() {
    cb(null, port)
  })
  server.listen(0)
}
