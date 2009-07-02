module page/fullpage
  
  define showFullPage(p:Page,list:List<Page>){
    if(!(p in list)){
      var newlist : List<Page>;
      init{ newlist.addAll(list).add(p); }
      navigate(singlepage(p)) {
        header{
          output(p.title)
        } 
      }
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
  
  define page page(p:Page){
    main()
    define localBody(){
      showFullPage(p, List<Page>())
    }
    define sidebarPlaceholder(){
      pageSidebar(p)
    }
  }

  define pageSidebar(p:Page){
    sidebar{
      if((p.contentlist.contents.get(1) as IndexContent).index.length > 0){
        showIndexPage(p,List<Page>(),0,false)
      }
      else{
        output(p.title)
      }
    }
  }