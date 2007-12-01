application org.webdsl.www

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

section application configuration

  entity Configuration {
    blogs      -> Set<Blog>
    forums     -> Set<Forum>
    homepage   -> Page
    sidebar    -> Page
    users      -> Set<User>
    startpages -> Set<Page>
    projects   -> Set<Project>
  }
  
  access control rules {
    rules page configuration(*) {
      securityContext.loggedIn
    }
    rules page editConfiguration(*) {
      securityContext.loggedIn
    }
  }

section initialization of application configuration

  globals {
  
    var appSidebar : Page := Page{
      name    := "Sidebar"
      content := ""
    };
    
    var homePage : Page := Page{
      name    := "WebDSL"
      content := "WebDSL\n-------\n[[page(WebDSL)]] is a [[page(DSL)]] for webapplications with a rich data model."
      authors := {eelco}
      author  := eelco
    };
    
    var config : Configuration := Configuration {
      homepage := homePage
      sidebar  := appSidebar
      blogs    := {eelcosBlog}
    }; 
    
  }


  

