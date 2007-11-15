application org.webdsl.wwww

description {
  This application is the website for webdsl.org
}

imports templates/main
imports wiki/main
imports users/main
imports issues/main
imports blog/main
imports forum/main
imports contexts/main


section application configuration

  entity Configuration {
    blogs      -> Set<Blog>
    forums     -> Set<Forum>
    homepage   -> Page
    sidebar    -> Page
    users      -> Page
    startpages -> Set<Page>
    projects   -> Set<Project>
  }
  
  access control rules {
    
    rules page configuration(*) {
      true
    }
    
    rules page editConfiguration(*) {
      securityContext.loggedIn
    }
    
  }
   
section initialization of application configuration

  globals {
  
    var appSidebar : Page := Page{
      name := "Sidebar"
      content := ""
    };
    
    var usersMenu : Page := Page{
      name := "UsersMenu"
      content := "- [[user(EelcoVisser)]]\n- [[user(ZefHemel)]]"
    };
  
    var homePage : Page := Page{
      name    := "WebDSL"
      content := "WebDSL\n-------\n[[page(WebDSL)]] is a [[page(DSL)]] for webapplications with a rich data model."
      authors := {eelco}
    };
    
    var webdslForum : Forum := Forum{
      title := "The WebDSL Forum"
    };
    
    var config : Configuration := Configuration {
      homepage := homePage
      sidebar  := appSidebar
      users    := usersMenu
      blogs    := {eelcosBlog}
    }; 
    
  }
  
section home page

  define page home() 
  {
    title{output(config.homepage.name)}
    main()
    define sidebar() {
      output(config.sidebar.content)
    }
    define body() {
      output(config.homepage.content)
    }
  }


  

