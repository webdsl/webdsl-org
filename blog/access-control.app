module blog/access-control

section blog 

  access control rules {
    
    rules page blog(*) {
      true
    }
    
    rules page blogEntry(*) {
      true
    }
    
    rules page editBlog(*) {
      securityContext.loggedIn
    }
    
    rules page editBlogEntry(*) {
      securityContext.loggedIn
    }
    
  }