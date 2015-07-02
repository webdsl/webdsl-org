module page/indexpage

  template showIndexPage(p:Page,list:List<Page>,indent:Int, hideCurrentTitle:Bool){
    showIndexPage(p,list,indent,hideCurrentTitle,p,p,99)
  }

  template showIndexPage(p:Page,list:List<Page>,indent:Int, hideCurrentTitle:Bool, selected:Page, top:Page, depth:Int){
    var newlist : List<Page>
    init{ newlist.addAll(list).add(p); }
    var subpages := (p.contentlist.contents.get(1) as IndexContent).index

    block[style := "margin-left: "+indent*5 +"pt"]{
      if(!(p in list)){
        if(!hideCurrentTitle){
          if(p == selected){
            <span class="selectedpagelink">
              navigate(selectpage(top,p)) {
                output(p.title)
              }
            </span>
          }
          else{
            navigate(selectpage(top,p)) {
              output(p.title)
            }
          }
          break
        }
        if(depth > 0){
          for(p1:Page in subpages){
            showIndexPage(p1,newlist,indent+1,false,selected, top, depth-1)
          }
        }
      }
      else{
        "error: infinite recursion"
      }
    }
  }

  page indexpage(p:Page){
    main()
    template localBody(){
      standardLayout{
        <h1>output(p.title)</h1>
        pageDetails(p, false)
        showIndexPage(p,List<Page>(),0, true)
      }
    }
    template sidebarPlaceholder(){
      pageSidebar(p, p)
    }
  }
