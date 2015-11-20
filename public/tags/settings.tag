<settings>
  <label>
    Framework
    <select name="currentFW" onchange="{ updateFramework }">
      <option each="{ fw, i in appState.frameworks}"  selected="{{appState.currentFramework.name == fw.name}}" value="{{i}}">{ fw.name }</option>
    </select>
  </label>

  <label>
    Preview
    <select name="currentFW" onchange="{ updatePreview }">
      <option each="{ pv, i in appState.previews}" selected="{{appState.currentPreview.name == pv.name}}" value="{{i}}">{ pv.name }</option>
    </select>
  </label>


  <button name="resetToDefault" onclick="{ resetToDefault }">Reset to Default</button>
  <error>
  <script>
    var me = this;
    
    me.errorTags = [];
    
    this.updateFramework = function(evt){
      appState.setFrameworkByIndex(evt.srcElement.value);
    }
    this.updatePreview = function(evt){
      appState.setPreviewByIndex(evt.srcElement.value);
    }
    this.resetToDefault = function(evt) {
      appState.trigger('clear-vars-cache');
    }
    
    appState.on('compilation:success', function() {
       console.log('compilation succeeded');
       me.errorTags.forEach(function(e) {
           e.unmount(true);
       })

    });
    
    appState.on('compilation:failed', function(err) {
       console.error('compilation failed', err);
       me.errorTags = riot.mount('error', {err: err}); 
    });

  </script>
</settings>