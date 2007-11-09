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
      section { 
        header{"Blogs"}
        list { for(b : Blog) { 
          listitem { output(b) }
        } }
      }
    }
  }

  

