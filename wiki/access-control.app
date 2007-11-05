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
  
    rules page page(*) {
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
