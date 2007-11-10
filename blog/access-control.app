module blog/access-control

section blog 

  access control rules {
    
    rules page blog(*) {
      true
    }
    
    rules template blogEntryIntro(entry : BlogEntry, b : Blog) {
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
    
    rules page newBlogEntry(*) {
      securityContext.loggedIn
    }
    
    rules template editBlogEntryLinks(entry : BlogEntry) {
      securityContext.loggedIn
    }
    
  }