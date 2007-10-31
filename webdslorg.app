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

imports issues/data
imports issues/pages

section home

  define page home() 
  {
    title{"WebDSL"}
    main()
    define body() {
    }
  }

  

