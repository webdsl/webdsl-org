module users/access-control

section users

  access control rules {
    rules page user(*) {
      true
    }
    
    rules page users() {
      true
    }
    
    rules page editUser(u : User) {
      securityContext.principal = u
    }
    
    rules page register() {
      true
    }
    
    rules page pendingRegistrations() {
      securityContext.loggedIn
    }
    
    rules page login() {
      true
    }
  }
  
section authentication actions

  access control rules {
  
    rules template signin() {
      !securityContext.loggedIn
    }
    
    rules template signinMenu() {
      !securityContext.loggedIn
    }
    
    rules template signoff() {
      securityContext.loggedIn
    }
    
    rules template signoffMenu() {
      securityContext.loggedIn
    }
    
    rules template signoffAction() {
      securityContext.loggedIn
    }
    
  }
