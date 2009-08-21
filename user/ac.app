module user/ac

  principal is User with credentials email, password
  
  access control rules
  
    rule page editUser(u:User){ 
      loggedIn() || principal == u
    }

    predicate allowCreateUser(){
      (loggedIn() && principal.isAdmin) || !globalSettings.firstUserCreated
    }
    rule page createUser(){ 
      allowCreateUser()
    }
    
    rule page listUsers(){ 
      loggedIn() && principal.isAdmin
    }
    
    rule page user(u:User){ 
      loggedIn() || principal == u
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
    rule template editAdminStatus(u:User){
      loggedIn() && principal.isAdmin
    }
    rule template showAdminStatus(u:User){
      loggedIn() && principal.isAdmin
    }