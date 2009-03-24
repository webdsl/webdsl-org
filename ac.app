module ac

  define page accessDenied(){
    main()
    define localBody(){
      header{"Access Denied"}
      navigate(home()){"return to home page"}
    }
  }

  access control rules
    
    rule page home(){true}
    rule page login(){ !loggedIn() }
    rule page logout(){ loggedIn() }
    rule page manage(){ loggedIn() }
    //rule page search(){ true }
    rule template *(*){true}
