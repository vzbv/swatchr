module.exports = function(req,res,next){

  if(arguments.length == 1){
    res = req;
    req = null;
  }

  var __headers__ = {},
    __status__ = 200;

  function addStatus(code){
    return function (data) {
      return data ? res.s(code).send(data) : res.s(code);
    };
  }

  function addType(type){
    return function (data) {
      res.h({'Content-Type': type});
      return data ? res.send(data): res;
    }
  }

  function redirMessageTpl(code, message, loc){
    return '<!doctype html><html><head><title>'+code+' '+message+'</title></head><body><p>'+message+'<br/><a href="'+loc+'">'+loc+'</a></p></body></html>';
  }

  function redirect(code, message){
    return function(loc){
      __headers__.Location = loc;
      return res.status(code).send(redirMessageTpl(code, message, loc));
    }
  }

  Object.defineProperties(res, {
    // helpers
    's':{
      enumerable: false,
      writable: false,
      value: function(code){
        __status__ = code;
        return this;
      }
    },
    'h':{
      enumerable: false,
      writable: false,
      value: function(headers){
        for(var header in headers){
          __headers__[header] = headers[header];
        }
        return this;
      }
    },
    't':{
      enumerable: false,
      writable: false,
      value: function(mimeType){
        this.h({'Content-Type': mimeType});
        return this;
      }
    },
    // success
    'ok':{
      enumerable: false,
      writable: false,
      value: addStatus(200)
    },
    'created':{
      enumerable: false,
      writable: false,
      value: addStatus(201)
    },
    'accepted':{
      enumerable: false,
      writable: false,
      value: addStatus(202)
    },
    // redirect
    'moved':{
      enumerable: false,
      writable: false,
      value: redirect(301, 'Moved Permanently')
    },
    'redirect':{
      enumerable: false,
      writable: false,
      value: redirect(302, 'Found')
    },
    'found':{
      enumerable: false,
      writable: false,
      value: this.redirect
    },
    'notModified':{
      enumerable: false,
      writable: false,
      value: function(){
        res.s(304).send();
      }
    },
    // client error
    'badRequest':{
      enumerable: false,
      writable: false,
      value: addStatus(400)
    },
    'unauthorized':{
      enumerable: false,
      writable: false,
      value: addStatus(401)
    },
    'payMe':{
      enumerable: false,
      writable: false,
      value: addStatus(402)
    },
    'forbidden':{
      enumerable: false,
      writable: false,
      value: addStatus(403)
    },
    'notFound':{
      enumerable: false,
      writable: false,
      value: addStatus(404)
    },
    'notAllowed':{
      enumerable: false,
      writable: false,
      value: addStatus(405)
    },
    'notAcceptable':{
      enumerable: false,
      writable: false,
      value: addStatus(406)
    },
    'proxyAuthRequired':{
      enumerable: false,
      writable: false,
      value: addStatus(407)
    },
    'requestTimeout':{
      enumerable: false,
      writable: false,
      value: addStatus(408)
    },
    'conflict':{
      enumerable: false,
      writable: false,
      value: addStatus(409)
    },
    'gone':{
      enumerable: false,
      writable: false,
      value: addStatus(410)
    },
    'lengthRequired':{
      enumerable: false,
      writable: false,
      value: addStatus(411)
    },
    'preconditionFailed':{
      enumerable: false,
      writable: false,
      value: addStatus(412)
    },
    'requestEntityTooLarge':{
      enumerable: false,
      writable: false,
      value: addStatus(413)
    },
    'requestUriTooLong':{
      enumerable: false,
      writable: false,
      value: addStatus(414)
    },
    'unsupportedMediaType':{
      enumerable: false,
      writable: false,
      value: addStatus(415)
    },
    'requestRangeNotSatisfiable':{
      enumerable: false,
      writable: false,
      value: addStatus(416)
    },
    'expectationFailed':{
      enumerable: false,
      writable: false,
      value: addStatus(417)
    },
    //server errors
    'error':{
      enumerable: false,
      writable: false,
      value: addStatus(500)
    },
    'notImplemented':{
      enumerable: false,
      writable: false,
      value: addStatus(501)
    },
    'badGateway':{
      enumerable: false,
      writable: false,
      value: addStatus(502)
    },
    'serviceUnavailable':{
      enumerable: false,
      writable: false,
      value: addStatus(503)
    },
    'gatewayTimeout':{
      enumerable: false,
      writable: false,
      value: addStatus(504)
    },
    'httpVersionNotSupported':{
      enumerable: false,
      writable: false,
      value: addStatus(505)
    },
    // mime types
    'text':{
      enumerable: false,
      writable: false,
      value: addType('text/plain')
    },
    'plain':{
      enumerable: false,
      writable: false,
      value: this.text
    },
    'html':{
      enumerable: false,
      writable: false,
      value: addType('text/html')
    },
    'xhtml':{
      enumerable: false,
      writable: false,
      value: addType('application/xhtml+xml')
    },
    'css':{
      enumerable: false,
      writable: false,
      value: addType('text/css')
    },
    'xml':{
      enumerable: false,
      writable: false,
      value: addType('text/xml')
    },
    'atom':{
      enumerable: false,
      writable: false,
      value: addType('application/atom+xml')
    },
    'rss':{
      enumerable: false,
      writable: false,
      value: addType('application/rss+xml')
    },
    'js':{
      enumerable: false,
      writable: false,
      value: addType('application/javascript')
    },
    'json':{
      enumerable: false,
      writable: false,
      value: addType('application/json')
    },
    'jsonp':{
      enumerable: false,
      writable: false,
      value: function(callback, data){
        if(typeof data == 'object'){
          data = JSON.stringify(data);
        }
        data = callback + '(' + data + ');';
        return res.ok().js(data);
      }
    },
    // fun
    'iAmATeapot':{
      enumerable: false,
      writable: false,
      value: addStatus(418)
    },
    'enhanceYourCalm':{
      enumerable: false,
      writable: false,
      value: addStatus(420)
    }
  });

  var __write__ = res.write;
  res.write = function(){
    res.statusCode = __status__;
    for(var header in __headers__){
      res.setHeader(header, __headers__[header]);
    }
    res.write = __write__;
    return __write__.apply(this, arguments);
  };

  res.send = function(data){
    if(data){
      if(Buffer.isBuffer(data)){
        res.h({'Content-Length': data.length});
      }
      else{
        if(typeof data === 'object'){
          // assume data is JSON
          if (!__headers__['Content-Type']) {
            res.h({'Content-Type': 'application/json'});
          }
          data = JSON.stringify(data);
        }
        res.h({'Content-Length': Buffer.byteLength(data)});
      }
      if(!__headers__['Content-Type']){
        // assume HTML
        res.h({'Content-Type': 'text/html'});
      }
      if(data){
        res.write(data);
      }
      res.end();
      return null;
    }
  }

  if(next){
    next(null, res);
  }
  else{
    return res;
  }
}