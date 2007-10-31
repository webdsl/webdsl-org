module wiki-page

section pages
  
  define page viewPage(p : Page)
  {
    main()
    title{output(p.name)}
    define sidebar() {
      list { 
	listitem { navigate(home()) { "Home" } }
        listitem { currentUser() }
        // listitem { newPage() } // triggers bug in renaming ??
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
	    return viewPage(p);
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
