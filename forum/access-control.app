module forum/access-control

section AC

  access control rules {
  
    rules page forums() {
      true
    }
    
    rules page forum(*) {
      true
    }
    
    rules template newDiscussion(*) {
      securityContext.loggedIn
    }      
    
    rules page discussion(*) {
      true
    }
    
    rules page editDiscussion(*) {
      securityContext.loggedIn
    }
    
    rules template editReplyLinks(*) {
      securityContext.loggedIn
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