# resbrev
Response Brevity

This is a small utlity library for assisting in setting up response object in Connect 3.x.  It is based on Quip and contains the same chainable API.

# install
npm install --save resbrev

# use
- Wrap a single response object

var http = require('http'),
resbrev = require('resbrev');
http.createServer(function (req, res) {
  resbrev(res);
  res.ok('Hello World\n')
  }).listen(1337, '127.0.0.1');
  console.log('Server running at http://127.0.0.1:1337/');

  - Connect / Express middleware
  var conenct = require('connect'),
  resbrev = require('resbrev');
  var app = connect(resbrev)
  .use('/api', function(req,res,next){
    res.json({foo: 'bar'});
    });

# methods
Response objects will be extended with the following **non-enumerable, non-writable** methods.  For the success, redirect, client error, server error, mime tpye, and fun methods, sending data will end the request.  Data is almost always optional (jsonp being the exception).

## helpers
- **s(statusCode)** - set the status code of the response
- **h(headers)** - set headers on the response, as an object containing key-value pairs of headers and values ({'Content-Type': 'application/json', 'x-hello': 'Hi there'})
- **t(mimeType)** - specifically set the 'Content-Type' header to the value of "mimeType"

## success
- **ok(data)** - sends status code 200 and data if present
- **created(data)** - sends 201
- **accepted(data)** - sends 202

## redirects
- **moved(location)** - sends 301 (moved permanently) and sets "location" header to "location" (required)
- **redirect(location)** - sends 302, use like "moved()"
- **found(location)** - identical to "redirect()"
- **notModified()** - sends 304

## client errors
- **badRequest(data)** - sends 400
- **unauthorized(data)** - sends 401
- **payMe(data)** - sends 402
- **forbidden(data)** - sends 403
- **notFound(data)** - sends 404
- **notAllowed(data)** - sends 405
- **notAcceptable(data)** - sends 406
- **proxyAuthRequired(data)** - sends 407
- **requestTimeout(data)** - sends 408
- **conflict(data)** - sends 409
- **gone(data)** - sends 410
- **lengthRequired(data)** - sends 411
- **preconditionFailed(data)** - sends 412
- **requestEntityTooLarge(data)** - sends 413
- **requestUriTooLong(data)** - sends 414
- **unsupportedMediaType(data)** - sends 415
- **requestRangeNotSatisfiable(data)** - sends 416
- **expectationFailed(data)** - sends 417

## server errors
- **error(data)** - sends 500
- **notImplemented(data)** - sends 501
- **badGateway(data)** - sends 502
- **serviceUnavailable(data)** - sends 503
- **gatewayTimeout(data)** - sends 504
- **httpVersionNotSupported(data)** - sends 505

## mime types
- **text(data)** - sets content-type to "text/plain"
- **plain(data)** - sets content-type to "text/plain"
- **html(data)** - sets content-type to "text/html"
- **xhtml(data)** - sets content-type to "application/xhtml+xml"
- **css(data)** - sets content-type to "text/css"
- **xml(data)** - sets content-type to "text/xml"
- **atom(data)** - sets content-type to "tapplication/atom+xml"
- **rss(data)** - sets content-type to "application/rss+xml"
- **js(data)** - sets content-type to "application/javascript"
- **json(data)** - sets content-type to "application/json"
- **jsonp(callback, data)** - sets content-type to "application/json" and adjusts response body for jsonp, "callback = (data);"

## for fun
- **iAmATeapot(data)** - sends 418
- **enhanceYourCalm(data)** - sends 420