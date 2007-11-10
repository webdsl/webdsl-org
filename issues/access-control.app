module issues/access-control

section foo

  access control rules {
  
    rules page issues() { true }
  
    rules page project(*) { true }
  
    rules page issue(*) { true }
    
    rules template newIssue(*) { true }
    
    rules page editIssue(*) { true }
  
  }
  
