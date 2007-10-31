module app/templates

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

  define homesidebar() {
    list { 
      listitem{ navigate("Home", home()) } 
      listitem { currentUser() }
      listitem { newPage() }
    }
  }
  
  define sidebar() {
    list { 
      listitem { navigate(home()) { "Home" } }
      listitem { currentUser() }
      listitem { newPage() }
    }
  }
  
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

