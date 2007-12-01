module templates/main

section main template

  define main() {
    block("outersidebar") {
      logo()
      sidebar()
    }
    block("outerbody") {
      block("menubar") {
        menu()
      }
      body()
      footer()
    }
  }

section basic page elements

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
  
section menus

  define wikiMenuItems() { }
  
  define menu() {
  
    list { 
      listitem{ 
        navigate(wiki()){"Wiki"}
        list {
          listitem { newPageLink() }
          wikiMenuItems()
          listitem { "Startpages" output(config.startpages) }
        }
      }
    }
    
    list { 
      listitem{ navigate(blogs()){"Blogs"} 
        output(config.blogs) }
    }
    
    list { 
      listitem{ 
        navigate(forums()){"Forums"} 
        output(config.forums) 
      }
    }
    
    list { 
      listitem{ 
        navigate(issues()){"Issues"}
        output(config.projects) 
      }
    }
    
    list { 
      listitem{ 
        navigate(users()){"Users"}
        output(config.users)
      }
    }
    
    list { listitem{ currentUser()} }
    
    adminMenu()
  }
  
  define adminMenu() 
  {
    list { 
      listitem{ "Admin" 
        list{ 
          listitem{ navigate(configuration(config)){"Configuration"} }
          listitem{ navigate(editConfiguration(config)){"Edit Configuration"} }
          listitem{ navigate(pendingRegistrations()){"Pending Registrations"} }
        }
      }
    }
  }
  
  access control rules {
    rules template adminMenu() {
      securityContext.loggedIn
      // todo: check that principal has admin rights
    }
  }