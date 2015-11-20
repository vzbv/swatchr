<editor>
  <textarea name="editor">#0ff</textarea>
  <script>

  var cssTarget = $('#dynamic-style-target');
  var inputDelayTime = false;
  var originalVars;

  var processors = {
    'less': {
      mode: 'text/x-less',
      processImport: function(fw){

      },
      render: function(inp, cb){
        cb = cb || function(cssOut){ console.log(cssOut); };
        fw = me.currentFW;
        less.render(inp, {filename: '/content/frameworks/'+fw.location+'/'+fw.main}, function(err, output) {
          if (!err) {
            appState.trigger('compilation:success');
            cb(output.css);
          }
          else {
            appState.trigger('compilation:failed', err);
          }
        });
      }
    },
    'sass': {
      mode: 'text/x-scss',
      processImport: function(fw){

      },
      render: function(inp, cb){
        cb = cb || function(cssOut){ console.log(cssOut); };

        less.render(inp)
        .then(function(output){
          cb(output.css);
        }).catch(function(err) {
          console.log("[sass:render] failed", err);
          });
      }
    }
  };

  // codemirror
  var editor = CodeMirror.fromTextArea(this.editor, {
    theme: 'material',
    lineNumbers: false, // there is a display bug
    mode: 'text/x-less'
  });

  var me = this;


  appState.on('framework-changed', function(){
    // set new framework name and vars
    me.currentFW = appState.currentFramework;

    // get new vars and put them in editor
    me.FW.getVariables(me.currentFW, function(err, vars){
      editor.getDoc().setValue(vars);
    });

    me.FW.getLib(me.currentFW, function(err, lib){
      console.log(lib);
    });

    // get the lib and cache it for later

    // then re-render
    me.reRenderCss(true);
  });

  appState.on('clear-vars-cache', function() {
    var fw = me.currentFW;
    var varLoc = '/content/frameworks/'+fw.location+'/'+fw.vars;
    localforage.removeItem(fw.location, function(err) {
      if (!err) {
        console.log("[editor:vars:cache] cleared");
        appState.cache.vars[varLoc] = null;

        appState.trigger('framework-changed');
      }
      else {
        console.log("[editor:vars:cache] failed", err);
      }
      });
    });


  this.FW = {
    getVariables: function(fw, cb){
      cb = cb || function(){};
      var varLoc = '/content/frameworks/'+fw.location+'/'+fw.vars;

      if(appState.cache.vars[varLoc]){
        // return it from the cache
        cb(null, appState.cache.vars[varLoc]);
      }
      else{
        var stored;
        localforage.getItem(fw.location, function(err, val) {
          if (err) {
            console.error("[framework:cache:load]", err);
          }
          else {
            if (val) {
              stored = val;
            }
          }

          if (stored) {
            appState.cache.vars[varLoc] = stored;
            cb(null, stored);
          }
          else {
            $.get(varLoc, function(data){
              var vars = data;
              appState.cache.vars[varLoc] = vars;
              cb(null, vars);
            });
          }
        });
      }

    },
    getLib: function(fw, cb){
      cb = cb || function(){};
      var libLoc = '/content/frameworks/'+fw.location+'/'+fw.main;
      if(appState.cache.libs[libLoc]){
        cb(null, appState.cache.libs[libLoc]);
      }
      else{
        $.get(libLoc, function(data){
          var lib = data;
          appState.cache.libs[libLoc] = lib;
          cb(null, lib);
        });
      }
    }
  };

  this.currentFW = appState.currentFramework;

  this.FW.getVariables(this.currentFW, function(err, vars){
    originalVars = vars;
    editor.getDoc().setValue(vars);
  });

  this.currentVars = function(){
    return editor.getDoc().getValue();
  }
  this.currentCombined = function(cb){
    cb = cb || function(){};
    me.FW.getLib(me.currentFW, function(err, lib){
      var replaceTarget = me.currentFW.varsReplaceTarget;
      var combined = lib.replace(replaceTarget, me.currentVars());
      cb(null, combined);
    });
  }

  this.getCss = function(preview, cb){
    cb = cb || function(){}
    this.currentCombined(function(e, css){
      cb(null, css);
    });
  }

  this.cacheVariables = function() {
    var loc = me.currentFW.location;
    localforage.setItem(loc, me.currentVars(), function(err, val) {
      if (err) {
        console.error("failed saving", loc, err);
      }
      else {
        console.log('saved', loc);
      }
      appState.trigger('vars-stored', me.currentFW.fw);
    });
  }

  this.reRenderCss = function(delay){
    var processor = this.currentFW.processor,
      me = this;
    function process(preview){
      me.getCss(preview, function(e, combined){
        processors[processor].render(combined, function(css){
          me.cacheVariables();
          appState.trigger('css-rendered', css);
        });
      });
    }
    if(!delay){
      process();
    }
    clearTimeout(inputDelayTime);
    inputDelayTime = setTimeout(function(){ process(true); }, 150);
  }

  appState.on('preview:init', function(){
    console.log('[editor:refresh]');
    me.reRenderCss(false);
  })

  editor.on('change', function(){
    me.reRenderCss(true);
  });
  </script>
</editor>
