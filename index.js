var connect = require('connect'),
  dispatch  = require('dispatch'),
  resbrev   = require('resbrev'),
  http      = require('http'),
  config    = require('./config'),
  serveStatic = require('serve-static'),
  fs        = require('fs');

var app = connect();
  app.use(resbrev);
  app.use(serveStatic(__dirname+'/public'));
  app.use('/previews', serveStatic(__dirname+'/content/previews'));
  app.use('/frameworks', serveStatic(__dirname+'/content/frameworks'));


app.use('/content/frameworks/', function(req, res, next) {
  if(req.method == 'POST') {
    req.end('works')
  }
  else {
    next(new Error('Only POST requests allowed'));
  }
});

var server = http.createServer(app).listen(config.server.port);
