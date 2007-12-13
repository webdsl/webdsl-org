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

  define mainOld2() 
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
  
  define main() 
  {
    block("top") {
      top()
    }

    block("body") {
      block("left_innerbody") {
        sidebar()
      }
      block("main_innerbody") {
        body()
      }
    }

    block("footer") {
      footer()
    }
  }
  
  define top() {
    block("header") {}
    block("menubar") { 
      applicationMenubar()
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
    block("footer") {
      block("left_footer") {
        navigate(home()) { "About WebDSL" }
      }
      block("right_footer") {
        "generated from "
        navigate("WebDSL", url("http://www.webdsl.org"))
        " with "
        navigate("Stratego/XT", url("http://www.strategoxt.org"))
      }
    }
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
      wikiMenu()
      blogMenu()
      forumMenu()
      issuesMenu()
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