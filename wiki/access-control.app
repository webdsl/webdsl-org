module wiki/access-control

section principal

  access control rules 
  {
    rules page home() {
      true
    }
  }
  
section page
  
  access control rules {
  
    rules page viewPage(*) {
      true
    }

    rules page editPage(*) {
      securityContext.loggedIn
    }
    
    rules template newPage() {
      securityContext.loggedIn
    }

    rules template editLink(*) {
      securityContext.loggedIn
    }
  }

section users

  access control rules {
    rules page viewUser(*) {
      true
    }
    
    rules page editUser(u : User) {
      securityContext.principal = u
    }
    
    rules page register() {
      true
    }
  }
  
section authentication actions

  access control rules {
    rules template signin() {
      !securityContext.loggedIn
    }
    rules template signoff() {
      securityContext.loggedIn
    }
  }
