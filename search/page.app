module search/page
  
  define searchform(){
    searchform("")
  }
  
  define searchform(query:String){
    var q := query;
    <div class="search-form-top">
      form{
        input(q)[class="searchinput"]
        submit action{ return search(q); } [class="searchbutton"] {"Search"}
      }
    </div>
  }
  
  define page search(query : String) {
    var result :List<Page> := List<Page>();
    var limit := 10;
    
    init{
      addPagesBasedOnTitle(result,searchPage(query));
      addPagesBasedOnWikiContent(result,searchWikiContent(query));
    }
    
    main()
    define localBody(){
      title { "Search" }
      
      includeJS("http://ajax.googleapis.com/ajax/libs/jquery/1.2.6/jquery.min.js")
      includeJS("searchpage.js")
      JSScriptVar(query)

      if(result.length == 0){
        header{ "No Pages Found" }
        "Your search query returned no results, try the wildcard character * for a less restrictive search."
      }
      else{
        header{ "Found Pages" }
      }
      for(p:Page in result limit limit){
        <div class="search-result-row">
        
          showNavigateFromSearch(p)

          <div class="small-preview-text">
            output(p.contentlist.contents[0])      
          </div>
        </div>
      }
    }
    
    // redefinition so the search term stays visible in the search box
    define searchform(){
      searchform(query)
    }
  }
  
  define JSScriptVar(query:String){
    var searchTermsInJS :String;
    
    init{
      //since we're using script insertion which doesn't prevent injection attacks like normal outputs, use a whitelist here
      //webdsl regex ignores regular whitespace, the \s matches whitespace
      var searchlist := /[^a-zA-Z0-9\s]/.replaceAll("", query).split(" ");
      if(searchlist.length>0){
        searchTermsInJS := "\'";
        var first := true;
        for(s:String in searchlist){
          if(first){ first := false; }else{ searchTermsInJS := searchTermsInJS + "|"; }
          searchTermsInJS := searchTermsInJS + s;
        }
        searchTermsInJS := searchTermsInJS +"\'";
      }
    }
    
    <script>
      var searchterms = ~searchTermsInJS;
    </script>
  }
  
  define showNavigateFromSearch(p:Page){
    if(p.isManualSection()){
      navigate selectpage(page_manual,p)[class="search-result-nav"]{output(p.title)}
    }
    else{
      showNavigateToSubPage(p)  
    }
  }

  define showNavigateToSubPage(p:Page){  
    var sec := p.getManualSection()
    if(sec!=null) {//it is a subsection in the manual
      navWithAnchor(navigate(selectpage(page_manual,sec)),p.url)[class="search-result-nav"]{ output(p.title) }
    }
    else{ //just show the page without manual context
      navigate singlepage(p)[class="search-result-nav"]{output(p.title)}
    }        
  }
  
  function addPagesBasedOnWikiContent(shownPages : List<Page>, results : List<WikiContent>){
    for(wc : WikiContent in results where wc.contentList.page.isLatestVersion() && !wc.contentList.page.hidden){
      if(!(wc.contentList.page in shownPages)){
        shownPages.add(wc.contentList.page);
      }
    }
  }
  
  function addPagesBasedOnTitle(shownPages : List<Page>, results : List<Page>){
    for(p : Page in results where p.isLatestVersion() && !p.hidden){
      if(!(p in shownPages)){
        shownPages.add(p);
      }
    }
  }
  
  
