application org.webdsl.www

description {
  This application is the website for webdsl.org
}

imports templates/main

imports wiki/data
imports wiki/page
imports wiki/init
imports wiki/access-control

imports users/profiles
imports users/authentication

section home

  define page home() 
  {
    title{"WebDSL"}
    main()
    define body() {
      section{
        section {
          header{"Topic Index"}
          list { for(p : Page) { 
            listitem{ navigate(viewPage(p)) { output(p.name) } } } 
          }
        }
        section {
          header{"User Index"}
          list { for(p : User) { 
            listitem{ navigate(viewUser(p)) { output(p.name) } } }
          }
        }
      }
    }
  }

  

