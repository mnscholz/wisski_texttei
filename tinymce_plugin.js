/**
* Wisski TEI Convert
* @author Martin Scholz 
*/
(function() {

 
  tinymce.create('tinymce.plugins.wisskiTextTEI',{

    getInfo : function() {
        return {
        longname : 'Wisski TEI Support',
        author : 'Martin Scholz'
        };
    },


    init : function(ed, url) {
      var t = this;
    
      t.editor = ed;
      t.callbackURL = ed.getParam('wisski_texttei_url');
      t.state = 'dirty'; 
            
      ed.onBeforeSetContent.add(function(ed, content) {
        if (t.state != 'dirty') return;

        var editor = ed;
        console.debug(content, 'content');
        var data = { text: content.content, to : 'html' };
        editor.setProgressState(1);
        t.state = 'progress';

        t.core = ed.plugins.wisskicore;

        // ajax call
        var xhr = $.ajax({
          url : t.callbackURL,
          contentType : "application/json",
          type : "POST",
          data : 'convert=' + tinymce.util.JSON.serialize(data),
          async : false,  // this is be depricated but the only way to do the trick (http://stackoverflow.com/questions/951021/what-do-i-do-if-i-want-a-javascript-version-of-sleep)
          success : function(data, req, o) {
            console.debug(data);
            editor.setProgressState(0);
            data = tinymce.util.JSON.parse(data);
           // editor.setContent(data.text);
            content.content = data.text;
            t.state = 'clean';
          },
          error : function( type, req, o ) {
            if (req.status != 200) {
              editor.setProgressState(0);
              t.core.db.warn("Ajax call not successful.");
              t.core.db.log("Type: ",type);
              t.core.db.log("Status: " + req.status + ' ' + req.statusText);
            }
            t.state = 'clean';
          },
        });
        
      });

      ed.onPostProcess.add(function(ed, content) {
//        if (t.state != 'dirty') return;

        var editor = ed;
        console.debug('gcontent',content);
        var data = { text: content.content };
        if (content.set) data.to = 'html';
        else if (content.get) data.to = 'tei';
        else return;
        editor.setProgressState(1);
        t.state = 'progress';

        if (!content.content) return;
        t.core = ed.plugins.wisskicore;

        // ajax call
        var xhr = $.ajax({
          url : t.callbackURL,
          contentType : "application/json",
          type : "POST",
          data : {convert : tinymce.util.JSON.serialize(data)},
          async : false,  // this is be depricated but the only way to do the trick (http://stackoverflow.com/questions/951021/what-do-i-do-if-i-want-a-javascript-version-of-sleep)
          success : function(data, req, o) {
            console.debug(data);
            editor.setProgressState(0);
            data = tinymce.util.JSON.parse(data);
           // editor.setContent(data.text);
            content.content = data.text;
            t.state = 'clean';
          },
          error : function( type, req, o ) {
            if (req.status != 200) {
              editor.setProgressState(0);
              t.core.db.warn("Ajax call not successful.");
              t.core.db.log("Type: ",type);
              t.core.db.log("Status: " + req.status + ' ' + req.statusText);
            }
            t.state = 'clean';
          },
        });
        
      });

      


    }

  });

  tinymce.PluginManager.add('wisskiTextTEI', tinymce.plugins.wisskiTextTEI);



  tinymce.create('tinymce.plugins.wisskiTextTEIButtons',{

    getInfo : function() {
        return {
        longname : 'Wisski TEI Buttons',
        author : 'Martin Scholz'
        };
    },

    init : function(ed, url) {
      
      ed.addCommand('wisskiTextTEIButtonFootnote', function() {
        var ed = tinymce.activeEditor;
        var n = ed.selection.getNode();
        if (ed.dom.hasClass(n, 'tei_footnote')) {
          ed.dom.removeClass(n, 'tei_footnote');
        } else {
          var p = ed.dom.getParent(p, function(n) { ed.dom.hasClass(n, 'tei_footnote'); });
          if (p) {
            ed.dom.removeClass(p, 'tei_footnote');
          } else {
            ed.dom.addClass(n, 'tei_footnote');
          }
        }
      });

      ed.addButton('wisskiTextTEIButtonFootnote', {
        title : 'Footnote',
        label : 'FN',
        cmd : 'wisskiTextTEIButtonFootnote',
      });

      // Add a node change handler, selects the button in the UI when a image is selected
      ed.onNodeChange.add(function(ed, cm, n) {
        cm.setActive('wisskiTextTEIButtonFootnote', ed.dom.hasClass(n, 'tei_footnote'));
      });

    }

  });

  tinymce.PluginManager.add('wisskiTextTEIButtons', tinymce.plugins.wisskiTextTEIButtons);


})();
