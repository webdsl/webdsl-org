module page/fullpage

  //something for standard library, together with an easy way to add an anchor to navigate
  template anchor(s:String){
    <a id=s name=s></a>
  }
  template navWithAnchor(n:String,a:String){
    <a all attributes href=n+"#"+a>
      elements
    </a>
  }

  define lastEditedBy(p:Page){
    /*<div class="created-by">
      output("last edited by " + p.creator.name + " at "  + p.time.format("d MMM yyyy HH:mm"))
    </div>*/
  }

  template showFullPage(page:Page,list:List<Page>){
    var newlist : List<Page>
    init{ newlist.addAll(list).add(page); }
    if(!(page in list)){
      header[id=page.url]{
        output(page.title)
      }
      lastEditedBy(page)
      pageDetails(page, false)
      output(page.contentlist.contents.get(0) as WikiContent)
      break
      for(p:Page in (page.contentlist.contents.get(1) as IndexContent).index){
        showFullPage(p,newlist)
      }
    }
    else{
      "error: infinite recursion"
    }
  }

  page selectpage(top: Page, p:Page){
    main()
    template localBody(){
      standardLayout{
        //if it's the top page (e.g. Manual,Downloads) show single page with indexes
        if(top == p){
          showPage(p)
        }
        else{
          showFullPage(p, List<Page>())
        }
      }
    }
    template sidebarPlaceholder(){
      pageSidebar(top, p)
    }
  }

  page page(p:Page){
    main()
    template localBody(){
      if(p.name == "Manual"){
        container{
          gridrow{
            docIndex(p)
            gridcol(9){
              showFullPage(p, List<Page>())
            }
          }
        }

      }
      else{
        standardLayout{
          showFullPage(p, List<Page>())
        }
      }
    }
  }

  template docIndex(p:Page){
    var subpages := (p.contentlist.contents.get(1) as IndexContent).index
    addBodyAttribute("data-offset", "50")
    addBodyAttribute("data-target", "#navbar-doc")
    addBodyAttribute("data-spy", "scroll")
    addBodyAttribute("style", "position:relative;")

    <div class="col-md-3" role="complementary">
      <nav id="navbar-doc" class="bs-docs-sidebar hidden-print hidden-xs hidden-sm affix">
        <ul class="nav bs-docs-sidenav">
          for(sub in subpages){
            <li>
              <a href="#"+sub.url class="doc-index-link" > output(sub.name) </a>
            </li>
          }
        </ul>
        <hr>
        <a class="back-to-top doc-index-link" href="#top">
          "Back to top"
        </a>
      </nav>
    </div>
  }

  template pageSidebar(top:Page, p:Page){
    sidebar{
      showIndexPage(top,List<Page>(),0,false, p, top, 1)
    }
  }
  template pageSidebar(p:Page){
    sidebar{
      outputIndexContentLinksInContext(p,false)
    }
  }
  template outputIndexContentLinksInContext(p:Page,hideCurrentPageTitle :Bool){
    if((p.contentlist.contents.get(1) as IndexContent).index.length > 0){
      showIndexPage(p,List<Page>(),0,hideCurrentPageTitle)
    }
    else{
      output(p.title)
    }
  }
