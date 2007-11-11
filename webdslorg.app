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

  globals {
    var homePage : Page := Page{
      name    := "WebDSL"
      content := "WebDSL\n-------\n[[page(WebDSL)]] is a [[page(DSL)][domain-specific language.]] for webapplications with a rich data model."
      authors := {eelco}
    };
  }

  define page home() 
  {
    var hp : Page := homePage;
    title{output(homePage.name)}
    main()
    define body() {
      output(hp.content)
    }
  }


  

