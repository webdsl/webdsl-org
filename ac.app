module ac

  define override page accessDenied(){
    main()
    define localBody(){
      header{"Access Denied"}
      navigate(home()){"return to home page"}
    }
  }

  access control rules
    
    rule page home(){true}
    rule page login(){ true }
    rule page logout1(){ true }
    rule page manage(){ loggedIn() && principal.isAdmin }
    rule template *(*){true}
