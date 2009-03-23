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
      break
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
  }
