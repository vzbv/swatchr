<preview>

  <div class="preview-contents">

  </div>


  <script>
    this.setPreviewContent = function(content){
      console.log('body', content, this.root, $(this.root));
      $(this.root).find('.preview-contents').html(content);
    }
    this.on('mount', function() {
      this.setPreview({
        "name": "Hipsum Basic",
        "file": "lipsum.html",
        "desc": "5 paragraphs of dummy text, very basic.",
        "default": true
      });
    })
    this.setPreview = function(previewObj){
      var me = this;
      // select the correct thing on the list
      // get the html contents of the file from the backend
      $.get('/preview/'+previewObj.file, function(body){
        me.setPreviewContent(body);
      });
    }

  </script>
</preview>