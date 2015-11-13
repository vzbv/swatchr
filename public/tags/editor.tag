<editor>
  <textarea name="editor">#0ff</textarea>
  <script>

  var cssTarget = $('#dynamic-style-target');
  var inputDelayTime = false;

  var processors = {
    'less': {
      mode: 'text/x-less',
      processImport: function(fw){

      },
      render: function(inp, cb){
        cb = cb || function(cssOut){ console.log(cssOut); };
        fw = me.currentFW;
        less.render(inp, {filename: '/content/frameworks/'+fw.location+'/'+fw.main})
        .then(function(output){
          cb(output.css);
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

  editor.on('change', function(){
    me.reRenderCss(true);
  });

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



  this.FW = {
    getVariables: function(fw, cb){
      cb = cb || function(){};
      var varLoc = '/content/frameworks/'+fw.location+'/'+fw.vars;
      if(appState.cache.vars[varLoc]){
        // return it from the cache
        cb(null, appState.cache.vars[varLoc]);
      }
      else{
        $.get(varLoc, function(data){
          var vars = data;
          appState.cache.vars[varLoc] = vars;
          cb(null, vars);
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

  this.previewWrap = function(inp){
    var bodyTagRegex = /(body|html) /gi; //([^,{;]*[,{])
      // debugger;
    return (inp); // .replace(bodyTagRegex, '.preview-contents '); //FIXME: also add preview to all other less lines…
  }
  this.getCss = function(preview, cb){
    cb = cb || function(){}
    this.currentCombined(function(e, css){
      // if (preview) {
      //   css = "preview { " + css + " }";
      // }
      cb(null, css);
    });
  }

  this.reRenderCss = function(delay){
    var processor = this.currentFW.processor,
      me = this;
    function process(preview){
      me.getCss(preview, function(e, combined){
        processors[processor].render(combined, function(css){
          // if(preview){
          //   css = me.previewWrap(css);
          // }
          // debugger;
          // cssTarget.text(css);
          // debugger;
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

  this.on('mount', function(){
    this.reRenderCss(false);
  })
  </script>
</editor>
