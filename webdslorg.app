application org.webdsl.wwww

description {
  This application is the website for webdsl.org
}

imports templates/main
imports wiki/main
imports users/main
imports issues/main
imports blog/main
imports contexts/main

section application configuration

  entity Configuration {
    blogs      -> Set<Blog>
    homepage   -> Page
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
  
    var homePage : Page := Page{
      name    := "WebDSL"
      content := "WebDSL\n-------\n[[page(WebDSL)]] is a [[page(DSL)]] for webapplications with a rich data model."
      authors := {eelco}
    };
    
    var theApp : Configuration := Configuration {
      homepage := homePage
    }; 
    
  }
  
section home page

  define page home() 
  {
    var config : Configuration := theApp;
    title{output(homePage.name)}
    main()
    define body() {
      output(config.homepage.content)
    }
  }


  

