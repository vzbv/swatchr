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
  <script>
    this.updateFramework = function(evt){
      appState.setFrameworkByIndex(evt.srcElement.value);
    }
    this.updatePreview = function(evt){
      appState.setPreviewByIndex(evt.srcElement.value);
    }
    this.resetToDefault = function(evt) {
      appState.trigger('clear-vars-cache');
    }
  </script>
</settings>