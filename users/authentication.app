module users/authentication

section authentication

  access control rules {
    principal is User with credentials username, password
  }

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
  
  