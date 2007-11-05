module issues/access-control

section foo

  access control rules {
  
    rules page project(*) { true }
  
    rules page issue(*) { true }
    
    rules page newIssue(*) { true rules action submit() { true } }
    
    rules page editIssue(*) { true }
  
  }