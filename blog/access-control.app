module blog/access-control

section blog stuff

  access control rules {
  
    predicate mayEditBlog(b : Blog) {
      securityContext.principal in b.authors
    }
    
    rules page blogs() {
      true
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
    
    rules page newBlog() {
      securityContext.loggedIn
    }
    
    rules template newBlogLink() {
      securityContext.loggedIn
    }
    
    rules page editBlog(b : Blog) {
      mayEditBlog(b)
    }
    
    rules page editBlogEntry(entry : BlogEntry) {
      mayEditBlog(entry.blog)
    }
    
    rules page newBlogEntry(b : Blog) {
      mayEditBlog(b)
    }
    
    rules template newBlogEntryLink(b : Blog) {
      mayEditBlog(b)
    }
    
    rules template editBlogEntryLinks(entry : BlogEntry) {
      mayEditBlog(entry.blog)
    }
    
  }