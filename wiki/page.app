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
	par{"Authors" output(p.authors) }
	par{navigate(diff(p.previous)){"Previous"}}
      }
    }
  }
  
  define page diff(diff : PageDiff)
  {
    main()
    define body() {
      section{
        header{output(diff.page)}
        if (diff.next != null ) {
          navigate(diff(diff.next)){"Next"} " "
        }
        if (diff.next = null ) {
          navigate(page(diff.page)){"Next"} " "
        }
        if (diff.previous != null ) {
          navigate(diff(diff.previous)){"Previous"}
        }
        section{
          header{"Content"}
          output(diff.content)
          par{ "Changes by " output(diff.author) }
        }
        //section{
        //  header{"Patch"}
        //  output(diff.patch)
        //}
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
