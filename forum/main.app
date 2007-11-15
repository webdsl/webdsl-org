module forum/main

imports forum/data
imports forum/pages
imports forum/access-control

section forum index

  define page forums()
  {
    main()
    
    define body() {
      section{
        header{"Forums"}
        list { for(f : Forum) {
          listitem{ output(f) }
        } }
      }
    }
  }
  
