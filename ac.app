module login

  define page login() 
  {
    main()
    define localBody() {
      var e:Email;
      var p:Secret;
      form{
        formgroup("Login"){
          label("Email"){input(e)}
          label("Password"){input(p)}
          action("login",login())
        }
      }
      action login(){
        var users : List<User> :=
          select u from User as u 
          where (u._email = ~e);
        if (users.length == 1 && users.get(0).password.check(p)) {
          securityContext.principal := users.get(0); 
          message("logged in");
          return home();
        }
      }
    }
  }

  define page logout() 
  {
    init{
      securityContext.principal := null;
      return home();
    } 
  }
  
  access control rules
    
    rule page home(){true}
    rule page login(){ !loggedIn() }
    rule page logout(){ loggedIn() }
    //rule page search(){ true }
    rule template *(*){true}
