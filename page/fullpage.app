module page/fullpage
  
  //something for standard library, together with an easy way to add an anchor to navigate
  define anchor(s:String){
    <a name=s />  
  } 
  define navWithAnchor(n:String,a:String){
    <a all attributes href=n+"#"+a>
      elements
    </a>
  }
  
  define showFullPage(p:Page,list:List<Page>){
    var newlist : List<Page>;
    init{ newlist.addAll(list).add(p); }
    if(!(p in list)){
      anchor(p.url)
      navigate(singlepage(p)) {
        header{
          output(p.title)
        } 
      }
      pageDetails(p, false)
      output(p.contentlist.contents.get(0) as WikiContent)
      break
      for(p:Page in (p.contentlist.contents.get(1) as IndexContent).index){
        showFullPage(p,newlist)
      }
    }
    else{
      "error: infinite recursion"
    }
  }
  
  define page selectpage(top: Page, p:Page){
    main()
    define localBody(){
      //if it's the top page (e.g. Manual,Downloads) show single page with indexes
      if(top == p){
        showPage(p)
      }
      else{
        showFullPage(p, List<Page>())
      }
    }
    define sidebarPlaceholder(){
      pageSidebar(top, p)
    }
  }
  
  define page page(p:Page){
    main()
    define localBody(){
      showFullPage(p, List<Page>())
    }
    define sidebarPlaceholder(){
      pageSidebar(p)
    }
  }

  define pageSidebar(top:Page, p:Page){
    sidebar{
      showIndexPage(top,List<Page>(),0,false, p, top, 1)
    }
  }
  define pageSidebar(p:Page){
    sidebar{
      outputIndexContentLinksInContext(p,false)
    }
  }
  define outputIndexContentLinksInContext(p:Page,hideCurrentPageTitle :Bool){
      if((p.contentlist.contents.get(1) as IndexContent).index.length > 0){
        showIndexPage(p,List<Page>(),0,hideCurrentPageTitle)
      }
      else{
        output(p.title)
      }
  }
  