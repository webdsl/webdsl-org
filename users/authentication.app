module users/authentication

section authentication

  access control rules {
    principal is User with credentials username, password
  }

  define currentUser() {
    signinMenu()
    signoffMenu()
  }
  
  define page login() {
    main()
    define body() {
      signin()
      signoff()
    }
  }

  define signinMenu() {
    navigate(login()){"Sign in"}
  }
  
  define signin() 
  {
    var usr : User := User{};
    form { 
      table {
        row{ "username: " input(usr.username) }
        row{ "password: " input(usr.password) }
      }
      actionLink("Sign in", signin())
      action signin() {
        var users : List<User> :=
          select u from User as u 
          where (u._username = ~usr.username);

        for (us : User in users ) {
          if (us.password.check(usr.password)) {
            securityContext.principal := us;
            securityContext.loggedIn := true;
            return user(securityContext.principal);
          }
        }
       securityContext.loggedIn := false;
        return home();
      }
      par{ navigate(register()){"Register new user"} }
    }
  }

  define signoff() 
  {
    "Signed in as " output(securityContext.principal)
    signoffAction()
  }
  
  define signoffAction() {
    form {
      actionLink("sign off", signoff())
      action signoff() {
        securityContext.loggedIn := false;
        securityContext.principal := null;
        // ensure that principal is null when signing off
        return home();
      }
    }
  }
    
  define signoffMenu() 
  {
    "Signed in as " output(securityContext.principal)
    list{ listitem{ signoffAction() } }
  }
  
  