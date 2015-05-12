var connect = require('connect'),
  dispatch = require('dispatch'),
  resbev = require('./index'),
  http = require('http');

var app = connect();

app.use(resbev)

app.use(dispatch({
  '/': function(req,res,next){
    res.ok('Hello World');
  }
}))

var server = app.listen(3535);
