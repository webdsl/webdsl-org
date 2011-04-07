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
    rule page login(){ !loggedIn() }
    rule page logout1(){ loggedIn() }
    rule page manage(){ loggedIn() && principal.isAdmin }
    //rule page search(){ true }
    rule template *(*){true}
