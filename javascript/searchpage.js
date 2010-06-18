$(function(){
  $('.search-result-nav, .outputWikiContent').each(function(){
    for(i=0;i<searchterms.length;i++){
      $(this).html($(this).html().replace(new RegExp("("+searchterms[i]+")","i"), "<span class='highlight-search-text'>$1</span>"));
    }
  });
});