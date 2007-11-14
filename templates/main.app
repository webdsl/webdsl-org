module templates

section main template.

  define main() {
    div("outersidebar") {
      logo()
      sidebar()
    }
    div("outerbody") {
      div("menubar") {
        menu()
      }
      body()
      footer()
    }
  }

section basic page elements.

  define logo() {
    section{header{navigate(home()){"WebDSL"}}}
  }

  define homeSidebar() {
    list { 
      listitem{ navigate(home()){"Home"} } 
      //listitem { currentUser() }
    }
  }
  
  define sidebar() {
    homeSidebar()
    contextSidebar()
    applicationSidebar()
  }
  
  define applicationSidebar() { }
  
  define footer() {
    "generated with "
    navigate("Stratego/XT", url("http://www.strategoxt.org"))
  }
  
  define contextSidebar() { }
  
section menus.
  
  define menu() {
    var config : Configuration := theApp;
    list { 
      listitem{ navigate(wiki()){"Wiki"} 
        output(config.startpages)}
    }
    
    list { 
      listitem{ navigate(blogs()){"Blogs"} 
        output(config.blogs) } 
    }
    
    list { listitem{ navigate(issues()){"Issues"} 
      output(config.projects) }
    }
    
    list { listitem{ navigate(users()){"Users"} } }
    
    list { listitem{ currentUser() } }
    
    list { 
      listitem{ "Admin" 
        list{ 
          listitem{ navigate(configuration(config)){"Configuration"} }
          listitem{ navigate(editConfiguration(config)){"Edit Configuration"} }
        }
      }
    }
  }
  
section entity management.

  define manageMenu() {}
  
  define page manage() {
    main()
    define sidebar() {}
    define body() {
      createMenu()
      allMenu()
    }
  }
