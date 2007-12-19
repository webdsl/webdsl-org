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
    menu{ 
      menuheader{ navigate(login()){"Sign in"} }
    }
  }
    
  define signin() 
  {
    var username : String;
    var password : Secret;
    form { 
      table {
        row{ "Username: " input(username) }
        row{ "Password: " input(password) }
        row{ action("Sign in", signin()) "" }
      }
      action signin() {
        var users : List<User> :=
          select u from User as u 
          where (u._username = ~username);

        for (us : User in users ) {
          if (us.password.check(password)) {
            securityContext.principal := us;
            securityContext.loggedIn := true;
            return user(securityContext.principal);
          }
        }
       securityContext.loggedIn := false;
        return home();
      }
    }
    par{ navigate(register()){"Register new user"} }
  }

  define signoff()
  {
    "Signed in as " output(securityContext.principal)
    signoffAction()
  }
  
  define signoffAction() {
    form {
      actionLink("Sign Off", signoff())
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
    menu{
      menuheader{ "You" }
      menuitem{ output(securityContext.principal) }
      menuitem{ signoffAction() }
      menuitem{ navigate(changePassword()){"Change Password"} }
      menuitem{ navigate(editUser(securityContext.principal)){"Edit Profile"} }
    }
  }
  
  