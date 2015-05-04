var connect = require('connect'),
  dispatch  = require('dispatch'),
  quip      = require('quip'),
  http      = require('http'),
  config    = require('./config'),
  serveStatic = require('serve-static');

var app = connect()
  //app.use(quip);
  app.use(serveStatic(__dirname+'/public'))
  app.use('/preview', serveStatic(__dirname+'/content/previews'))
  app.use(dispatch({
    
  }));


var server = http.createServer(app).listen(config.server.port);