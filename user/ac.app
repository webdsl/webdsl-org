module user/ac

  principal is User with credentials email, password
  
  access control rules
  
    rule page editUser(u:User){ 
      principal == u
    }

    predicate allowCreateUser(){
      loggedIn() || !globalSettings.firstUserCreated
    }
    rule page createUser(){ 
      allowCreateUser()
    }
    
    rule page listUsers(){ 
      loggedIn()
    }
    
    rule page user(u:User){ 
      loggedIn()
    }
    
    