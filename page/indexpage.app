module page/indexpage
  
  define showIndexPage(p:Page,list:List<Page>){
    if(!(p in list)){
      var newlist : List<Page>;
      init{ newlist.addAll(list).add(p); }
      var subpages := (p.contentlist.contents.get(1) as IndexContent).index
      navigate(page(p)) {
        output(p.title)
      }
      break
      for(p1:Page in subpages){
        showIndexPage(p1,newlist)
      }
    }
    else{
      "error: infinite recursion"
    }
  }
  
  define page indexpage(p:Page){
    main()
    define localBody(){
      showIndexPage(p,List<Page>())
    }
  }
