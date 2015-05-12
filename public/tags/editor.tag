<editor>
  <p>This is where the editor will go, Codemirror based</p>
  <label> Color
    <input type="text" name="tmpColor" onkeyup="{ reRenderCss }" value="#f00" />
  </label>
  <script>

  var cssTarget = $('#dynamic-style-target');
  var inputDelayTime = false;

  var processors = {
    'less': {
      processImport: function(fw){

      },
      render: function(lessInput, cb){
        cb = cb || function(cssOut){ console.log(cssOut); };

        less.render(lessInput)
        .then(function(output){
          cb(output.css);
        });
      }
    }
  };

  appState.on('framework-changed', function(){
    // this is where a re-render will fire off
  });

  this.currentFW = {
    name: null,
    processor: 'less'
  };
  this.currentLib = function(){
    return 'p{ color: '+this.tmpColor.value+';  }';
  }

  this.previewWrap = function(inp){
    return 'preview{ '+inp+' }';
  }
  this.getCss = function(preview){
    var css = this.currentLib();
    if(preview){
      css = this.previewWrap(css);
    }
    return css;
  }

  this.reRenderCss = function(delay){
    var processor = this.currentFW.processor;
    if(!delay){
      processors[processor].render(this.getCss(true), function(css){
        cssTarget.text(css);
      });
    }
    clearTimeout(inputDelayTime);
    var me = this;
    inputDelayTime = setTimeout(function(){
      processors[processor].render(me.getCss(true), function(css){
        cssTarget.text(css);
      });

    }, 150);

  }

  this.on('mount', function(){
    this.reRenderCss(false);
  })

  </script>
</editor>
