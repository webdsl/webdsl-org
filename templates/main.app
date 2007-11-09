module templates

section main template.

  define main() {
    div("outersidebar") {
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

  define homeSidebar() {
    list { 
      listitem{ navigate("Home", home()) } 
      listitem { currentUser() }
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
  
section menus.
  
  define menu() {
    //list { listitem{  } }
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

