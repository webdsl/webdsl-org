module blog/access-control

section blog 

  access control rules {
  
    predicate mayEditBlog(b : Blog) {
      return securityContext.loggedIn;
    }
    
    rules page blog(b : Blog) {
      true
    }
    
    rules template editBlogLink(b : Blog) {
      mayEditBlog(b)
    }
    
    rules template blogEntryIntro(entry : BlogEntry, b : Blog) {
      true
    }
    
    rules page blogEntry(entry : BlogEntry) {
      true
    }
    
    rules page editBlog(b : Blog) {
      securityContext.loggedIn
    }
    
    rules page editBlogEntry(entry : BlogEntry) {
      securityContext.loggedIn
    }
    
    rules page newBlogEntry(b : Blog) {
      securityContext.loggedIn
    }
    
    rules template newBlogEntryLink(b : Blog) {
      securityContext.loggedIn
    }
    
    rules template editBlogEntryLinks(entry : BlogEntry) {
      securityContext.loggedIn
    }
    
  }