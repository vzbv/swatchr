var connect = require('connect'),
    query = require('connect-query'),
    dispatch = require('dispatch'),
    resbrev = require('resbrev'),
    http = require('http'),
    request = require('request'),
    config = require('./config'),
    serveStatic = require('serve-static'),
    frameworks = require(__dirname + '/public/content/frameworks/active')
fs = require('fs');

var app = connect();
app.use(resbrev);
app.use(query());
app.use(serveStatic(__dirname + '/public'));
app.use('/previews', serveStatic(__dirname + '/content/previews'));
app.use('/frameworks', serveStatic(__dirname + '/content/frameworks'));

app.use('/proxy', function(req, res, next) {
    var href = req.query.href,
        fwName = req.query.framework,
        fw = frameworks.filter(function(x) {
            return x.location == fwName
        });

    if (fw.length) {
        console.log('requesting', href);

        request(href, function(err, rres, body) {
            var rxp = new RegExp("<style[^>]*>\\s*@import url\\(\"" + href + (fw[0].mainCompiled.replace(/([(){}[].?\/])/gi, "\\\1")) + "\\?[a-z0-9A-Z]+\"\\);\\s*</style>", "gi");
            var endbody = /<\/body>/;
            body = body.replace(rxp, "<style id=dynamic-style-target></style>").replace(endbody, "<script src='https://cdnjs.cloudflare.com/ajax/libs/iframe-resizer/3.5.1/iframeResizer.contentWindow.js'></script><script>(function() { var $ = jQuery; function handle(e){switch(e.type){case'preview':console.log('[preview:content] updated'),$('body').html(e.data);break;case'styles':console.log('[preview:styles] updated'),$('#dynamic-style-target').text(e.data);break;default:console.error('[preview:msg:error] unknown type received')}}window.iFrameResizer={messageCallback:handle}; })();</script></body>");
            console.log(rxp);
            res.end(body);
        });
    } else {
        console.log("No framework named:", fwName, "only: ", frameworks);
        next(new Error("no framework named: " + fwName));
    }
});

var server = http.createServer(app).listen(config.server.port);
