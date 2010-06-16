module search/page
  
  define searchform(){
    searchform("")
  }
  
  define searchform(query:String){
    var q := query;
    <div class="search-form-top">
      form{
        input(q)
        submit action{ return search(q); } {"Search"}
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
  
  define showNavigateFromSearch(p:Page){
    if(p.isManualSection()){
      navigate selectpage(page_manual,p){output(p.title)}
    }
    else{
      showNavigateToSubPage(p)  
    }
  }

  define showNavigateToSubPage(p:Page){  
    var sec := p.getManualSection()
    if(sec!=null) {//it is a subsection in the manual
      navWithAnchor(navigate(selectpage(page_manual,sec)),p.url){ output(p.title) }
    }
    else{ //just show the page without manual context
      navigate singlepage(p){output(p.title)}
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
  
  
