module user/ac

  principal is User with credentials email, password
  
  access control rules
  
    rule page editUser(u:User){ 
      loggedIn()
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
    
    rule page passwordReset(pr:PasswordReset){
      true
    }
    
    rule template editUserDetails(u:User){
      principal == u
    }
    rule template editUserPassword(u:User){
      principal == u
    }