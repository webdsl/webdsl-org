$(function(){
  $('.search-result-nav, .outputWikiContent').each(function(){
    $(this).html($(this).html().replace(new RegExp("("+searchterms+")","ig"), "<span class='highlight-search-text'>$1</span>"));
  });
});