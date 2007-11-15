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
      }
    }
    define body() {
      section {
        header{output(p.name)}
	par { output(p.content) }
	section { header{"Authors"} output(p.authors) }
      }
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
    main()
    title{"Edit page " output(p.name)}
    define body() {
      section {
        form { 
          header{input(p.name)}
	  par { input(p.content) }
	  par { actionLink("Save changes", savePage()) }
          action savePage() {
            p.authors.add(securityContext.principal);
            securityContext.principal.authored.add(p);
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
        newPage.persist();
        return editPage(newPage);
      }
    }
  }
