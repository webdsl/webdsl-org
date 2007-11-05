module users/access-control

section users

  access control rules {
    rules page user(*) {
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
      true
      // !securityContext.loggedIn
    }
    rules template signoff() {
      securityContext.loggedIn
    }
  }
