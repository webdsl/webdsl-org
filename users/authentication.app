module wiki-authorization

section authorization

  define currentUser() {
    signin() 
    signoff()
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
          where (u._username = ~usr.username) and (u._password = ~usr.password);
            	
        for (us : User in users) {
          securityContext.principal := us;
          securityContext.loggedIn  := true;
          return viewUser(securityContext.principal);
          // here you want to return to the page where the user was when signing in
        }
        securityContext.loggedIn := false;
        return home();
        // here we want to give an error message 'incorrect user or password'
      }
      par{ navigate(register()){"Register new user"} }
    }
  }

  define signoff() 
  {
    "Signed in as " output(securityContext.principal)
    form {
      actionLink("sign off", signoff())
      action signoff() {
        securityContext.loggedIn := false;
        securityContext.principal := null;
        return home();
      }
    }
  }
  
  // ensure that principal is null when signing off