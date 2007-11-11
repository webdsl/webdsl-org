module users/main

imports users/data
imports users/profiles
imports users/authentication
imports users/access-control

section main page for user admin

  define page users()
  {
    main()
    define body() {
      section { 
        header{"Users"}
        list { for(u : User) { 
          listitem { output(u) }
        } }
      }
    }
  }