application org.webdsl.wwww

description {
  This application is the website for webdsl.org
}

imports templates/main

imports wiki/data
imports wiki/page
imports wiki/init
imports wiki/access-control

imports users/data
imports users/profiles
imports users/authentication
imports users/access-control

imports issues/data
imports issues/pages
imports issues/access-control
imports issues/init

section home

  define page home() 
  {
    title{"WebDSL"}
    main()
    define body() {
      section { 
        header{"Projects"}
        list { for(p : Project) { 
          listitem { output(p) }
        } }
      }
      section { 
        header{"Users"}
        list { for(u : User) { 
          listitem { output(u) }
        } }
      }
      section { 
        header{"Pages"}
        list { for(p : Page) { 
          listitem { output(p) }
        } }
      }
    }
  }

  

