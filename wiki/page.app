module wiki/page

section pages
  
  define page page(p : Page)
  {
    init {
      if(p.authors.length = 0) {
        // This is a new page
        goto editPage(p);
      }
    }
    main()
    title{output(p.name)}
    define applicationSidebar() {
      list {
        listitem { newPage() } // triggers bug in renaming ??
      	listitem { editLink(p) }
      	listitem { previousLink(p) }
      }
    }
    define body() {
      section {
        header{output(p.name)}
        listitem{ "foo" }
	par { output(p.content) }
	par{"Authors" output(p.authors) }
      }
    }
  }
  
  define previousLink(p : Page)
  {
    if (p.previous != null) {
      navigate(diff(p.previous)){"Previous"}
    }
  }
	
  define page diff(diff : PageDiff)
  {
    main()
    title{output(diff.page.name) "/ version " output(diff.version)}
    define applicationSidebar() {
      list {
        listitem { newPage() } // triggers bug in renaming ??
      	listitem {  nextPreviousLink(diff) }
      }
    }
    define body() {
      section{
        header{output(diff.page) "/ version " output(diff.version)}
        output(diff.content)
        par{ "Last changes by " output(diff.author) }
        //section{
        //  header{"Patch"}
        //  output(diff.patch)
        //}
      }
    }
  }
  
  define nextPreviousLink(diff : PageDiff)
  {
     if (diff.previous != null ) {
          navigate(diff(diff.previous)){"<-"}
     }
     if (diff.next != null ) {
       navigate(diff(diff.next)){"->"} " "
     }
     if (diff.next = null ) {
       navigate(page(diff.page)){"->"} " "
     }
  }
        
  define editLink(p : Page)
  {
    navigate(editPage(p)) { "Edit" }
    
    if (p in config.startpages) {
      form {
        actionLink("Remove from startpages", unmakeStartpage())
        action unmakeStartpage() {
          config.startpages.remove(p);
          config.persist();
        }
      }
    }
      
    if (!(p in config.startpages)) {
      form{
        actionLink("Make startpage", makeStartpage())
        action makeStartpage() {
          config.startpages.add(p);
          config.persist();
        }
      }
    }
  }

  define page editPage(p : Page) 
  {
    var content : WikiText := p.content;
    //init{
    //  content := p.content;
    //}
    main()
    title{"Edit page " output(p.name)}
    define body() {
      section {
        form { 
          header{input(p.name)}
	  par { input(content) }
	  par { actionLink("Save changes", savePage()) }
          action savePage() {
            p.makeChange(content, securityContext.principal);
            p.persist();
	    return page(p);
          }
	}
      }
    }
  }
  
  define newPage() 
  {
    var newPage : Page := Page { };
    form { 
      actionLink("New page", createPage())
      input(newPage.name)
      action createPage() {
        // check that name is not empty ; as part of validation?
        newPage.authors.add(securityContext.principal);
        newPage.author := securityContext.principal;
        newPage.persist();
        return editPage(newPage);
      }
    }
  }
