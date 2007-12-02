module wiki/page

section main page for wiki

  define page wiki()
  {
    main()
    define applicationSidebar() {
      list{ newPageLink() }
    }
    define body() {
      section { 
        header{"Pages"}
        list { for(p : Page) { 
          listitem { output(p) }
        } }
      }
    }
  }
  
section wiki page
  
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
      list{ pageOperations(p) }
    }
    define body() {
      section {
        header{ output(p.title) }
	par{ output(p.content) }
	par{"Contributions by " 
	  for(author : User in p.authorsList) {
	    output(author)
	  }
	}
      	par{ previousLink(p) }
      }
    }
  }
  
section page operations
  
  define pageOperations(p : Page)
  {
    listitem { newPageLink() }
    listitem{ navigate(editPage(p)) { "Edit" } }
    listitem{ 
      if (p in config.startpages) {
        form {
          actionLink("Startpage", unmakeStartpage())
          action unmakeStartpage() {
            config.startpages.remove(p);
            config.persist();
          }
        }
      }
      if (!(p in config.startpages)) {
        form{
          actionLink("Not a startpage", makeStartpage())
          action makeStartpage() {
            config.startpages.add(p);
            config.persist();
          }
        }
      }
    }
  }
  
  define newPageLink() {
    navigate(newPage()){ "New Page" }
  }
  
section wiki page history
  
  define previousLink(p : Page)
  {
    if (p.previous != null) {
      navigate(diff(p.previous)){"Previous"}
    }
  }
	
  define page diff(diff : PageDiff)
  {
    main()
    title{output(diff.page.name) " / version " output(diff.version)}
    define body() {
      section{
        header{output(diff.page) " / version " output(diff.version)}
        output(diff.content)
        par{ "Last changes by " output(diff.author) }
        par{ nextPreviousLink(diff) }
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
          navigate(diff(diff.previous)){"Previous"} " "
     }
     if (diff.previous = null ) {
          "Previous" " "
     }
     if (diff.next != null ) {
       navigate(diff(diff.next)){"Next"}
     }
     if (diff.next = null ) {
       navigate(page(diff.page)){"Next"}
     }
  }
  
section wiki page editing

  define page editPage(p : Page)
  {
    var newTitle   : String   := p.title;
    var newContent : WikiText := p.content;
    main() 
    title{"Edit Page: " output(p.name)}
    define body() {
      section {
        header{"Edit Page: " output(p.name)}
        form { 
          par{ input(newTitle) }
	  par{ input(newContent) }
	  par{ action("Save changes", savePage()) }
          action savePage() {
            p.makeChange(newTitle, newContent, securityContext.principal);
            p.persist();
	    return page(p);
          }
	}
      }
    }
  }
  
  define page newPage()
  {
    var newName    : String;
    var newTitle   : String;
    var newContent : WikiText;
    main() 
    title{"Create New Wiki Page"}
    define body() {
      section {
        header{"Create New Wiki Page"}
        form { 
          par{ "Name: " input(newName) }
          par{ "The name of a page is the key that is used to refer to it "
               "and cannot be changed after creation." }
          par{ "Title: " input(newTitle) }
	  par{ input(newContent) }
	  par{ action("Save changes", savePage()) }
          action savePage() {
            var p : Page := Page{ name := newName };
            p.makeChange(newTitle, newContent, securityContext.principal);
            p.persist();
	    return page(p);
          }
	}
      }
    }
  }
