module templates/main

section main template

  define mainOld() {
    block("outersidebar") {
      logo()
      sidebar()
    }
    block("outerbody") {
      block("menubar") {
        menu()
      }
      body()
      block("footer"){footer()}
    }
  }

  define main() 
  {
    block("pageBody") {
      applicationMenubar()
      table{ row {
      block("pageSidebar") {
        sidebar()
      }
      block("pageBody") {
        body()
        block("footer"){footer()}
      }
    } } }
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
    "generated from "
    navigate("WebDSL", url("http://www.webdsl.org"))
    " with "
    navigate("Stratego/XT", url("http://www.strategoxt.org"))
  }
  
  define contextSidebar() { }
  
section menus

  define wikiMenuItems() { }
  
  define applicationMenubar()
  {
    menubar {
      menu { 
        menuheader{ navigate(news()){"News"} }
        newsMenu()
      }
      menu { 
        menuheader{ navigate(wiki()){"Wiki"} }
        pageOperationsMenuItems()
        for(p : Page in config.startpagesList) {
          menuitem{ output(p) }
        }
      }
      menu { 
        menuheader{ navigate(blogs()){"Blogs"} }
        for(b : Blog in config.blogsList) {
          menuitem{ output(b) }
        }
      }
      menu { 
        menuheader{ navigate(forums()){"Forums"} }
        for(b : Forum in config.forumsList) {
          menuitem{ output(b) }
        }
      }
      menu { 
        menuheader{ navigate(issues()){"Issues"} }
        for(b : Project in config.projectsList) {
          menuitem{ output(b) }
        }
      }
      menu { 
        menuheader{ navigate(users()){"Users"} }
        for(b : User in config.usersList) {
          menuitem{ output(b) }
        }
      }
      currentUser()
      adminMenu()
    }
  }
  
  define adminMenu() 
  {
    menu { 
      menuheader{ "Admin" }
      menuitem{ navigate(configuration(config)){"Configuration"} }
      menuitem{ navigate(editConfiguration(config)){"Edit Configuration"} }
      menuitem{ navigate(pendingRegistrations()){"Pending Registrations"} }
    }
  }
  
  access control rules {
    rules template adminMenu() {
      securityContext.loggedIn
      // todo: check that principal has admin rights
    }
  }