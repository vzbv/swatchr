<preview>

  <div class="preview-contents">

  </div>
  <script>
  var me = this;
  this.setPreviewContent = function(content){
    //console.log('body', content, this.root, $(this.root));
    $(this.root).find('.preview-contents').html(content);
  }
  appState.on('preview-changed', function(){
    me.setPreview(appState.currentPreview);
  })
  this.on('mount', function(){
    if(appState.currentPreview){
      me.setPreview(appState.currentPreview);
    }
  })
  this.setPreview = function(previewObj){
    // select the correct thing on the list
    // get the html contents of the file from the backend
    $.get('/content/previews/'+previewObj.file, function(body){
      me.setPreviewContent(body);
    });
  }

  </script>
</preview>
