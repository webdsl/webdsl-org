$(function(){
  $("pre").each(function(){
    var contentwidth = $(this).contents().width();
    var blockwidth = 645;		
    if(contentwidth > blockwidth) {
      $(this).hover(
        function() {
          $(this).animate({ width: contentwidth }, 250);
        }, 
        function() {
          $(this).animate({ width: blockwidth }, 250);
        }
      );
    }
  });
});