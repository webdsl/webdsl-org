module blog/main

imports blog/data
imports blog/pages
imports blog/access-control
imports blog/init

section blog start page

  define page blogs()
  {
    main()
    define body() {
      section { 
        header{"Blogs"}
        list { for(b : Blog) { 
          listitem { output(b) }
        } }
      }
    }
  }