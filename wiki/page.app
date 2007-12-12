module wiki/page

section main page for wiki

  define page wiki()
  {
    main()
    title{output(config.wikistartpage.title)}
    define body() {
      output(config.wikistartpage.content)
    }
  }

  define page wikiIndex()
  {
    main()
    title{"Wiki Page Index"}
    define body() {
      section { 
        header{"Wiki Page Index"}
        list { for(p : Page) { 
          listitem { output(p) }
          // todo: sort by title
          // todo: use title and key
          // todo: make accessible via wiki markup?
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
    title{output(p.title)}
    define wikiOperationsMenuItems() {
      pageOperationsMenuItems(p)
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

  define wikiMenu()
  {
    menu{
      menuheader{ navigate(wiki()){"Wiki"} }
      wikiOperationsMenuItems()
      menuitem{ navigate(wikiIndex()){"Page Index"} }
      menuitem{ navigate(newPage()){"New Page"} }
      menuspacer{}
      for(p : Page in config.startpagesList) {
        menuitem{ output(p) }
      }
    }
  }
  
  define wikiOperationsMenuItems() {
  }
    
  define pageOperationsMenuItems(p : Page)
  {
    menuitem{ navigate(editPage(p)) { "Edit This Page" } }
    menuitem{ 
      if (p in config.startpages) {
        form {
          actionLink("Remove as Startpage", unmakeStartpage())
          action unmakeStartpage() {
            config.startpages.remove(p);
            config.persist();
          }
        }
      }
      if (!(p in config.startpages)) {
        form{
          actionLink("Add to Startpages", makeStartpage())
          action makeStartpage() {
            config.startpages.add(p);
            config.persist();
          }
        }
      }
    }
    menuspacer{}
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
        // todo: show the difference
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
          par{ "Name" input(newName) }
          par{ "Title: " input(newTitle) }
	  par{ input(newContent) }
	  par{ action("Save changes", savePage()) }
	  par{}
          par{ 
            "*) The name of a page is the key that is used to refer to it "
            "and cannot be changed after creation. " 
          }
               
          action savePage() {
            var p : Page := Page{ name := newName };
            if (newTitle = "") { newTitle := newName; }
            p.makeChange(newTitle, newContent, securityContext.principal);
            p.persist();
	    return page(p);
          }
	}
      }
    }
  }
