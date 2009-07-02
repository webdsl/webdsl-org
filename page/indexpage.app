module page/indexpage
  
  define showIndexPage(p:Page,list:List<Page>,indent:Int, hideCurrentTitle:Bool){
    block[style := "margin-left: "+indent*5 +"pt"]{
      if(!(p in list)){
        var newlist : List<Page>;
        init{ newlist.addAll(list).add(p); }
        var subpages := (p.contentlist.contents.get(1) as IndexContent).index
        if(!hideCurrentTitle){
          navigate(page(p)) {
            output(p.title)
          }
          break
        }
        for(p1:Page in subpages){
          showIndexPage(p1,newlist,indent+1,false)
        }
      }
      else{
        "error: infinite recursion"
      }
    }
  }
  
  define page indexpage(p:Page){
    main()
    define localBody(){
      <h1>output(p.title)</h1>
      showIndexPage(p,List<Page>(),0, true)
    }
    define sidebarPlaceholder(){
      pageSidebar(p)
    }
  }
