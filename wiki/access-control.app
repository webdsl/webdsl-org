module wiki/access-control

section wiki

  access control rules 
  {
    rules page home() {
      true
    }
  
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
        
    rules page newPage() {
      securityContext.loggedIn
    }

    rules template newPageLink() {
      securityContext.loggedIn
    }

    rules template pageOperations(p : Page) {
      securityContext.loggedIn
    } 
    
    rules template pageOperationsMenuItemsP(p : Page) {
      securityContext.loggedIn
    }

  }
