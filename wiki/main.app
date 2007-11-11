module wiki/main

imports wiki/data
imports wiki/page
imports wiki/init
imports wiki/access-control

section main page for wiki

  define page wiki()
  {
    main()
    define body() {
      section { 
        header{"Pages"}
        list { for(p : Page) { 
          listitem { output(p) }
        } }
      }
    }
  }