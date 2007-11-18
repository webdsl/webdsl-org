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
    
    rules page wiki() {
      true
    }

    rules page pageDiff(*) {
      securityContext.loggedIn
    }
    
    rules page diff(*) {
      securityContext.loggedIn
    }
    
    rules page editPageDiff(*) {
      securityContext.loggedIn
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
