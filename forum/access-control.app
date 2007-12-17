module forum/access-control

section AC

  access control rules {
  
    rules page forums() {
      true
    }
    
    rules page newForum() {
      securityContext.loggedIn
    }
    
    rules page editForum(*) {
      securityContext.loggedIn
    }
    
    rules page forum(*) {
      true
    }
    
    rules page newDiscussion(*) {
      securityContext.loggedIn
    }      
    
    rules page discussion(*) {
      true
    }
    
    rules page editDiscussion(*) {
      securityContext.loggedIn
    }
    
    rules template showReply(*) {
      true
      rules action delete(*) {
        securityContext.loggedIn
      }
    }
    
    rules page reply(*) {
      securityContext.loggedIn
    }
    
    rules page reply(*) {
      true
    }
    
    rules page editReply(*) {
      securityContext.loggedIn
    }
    
    rules template addReply(*) {
      securityContext.loggedIn
    }
  
    
  }