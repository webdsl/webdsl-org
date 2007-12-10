module issues/access-control

section issues

  access control rules {
    
    rules page issues() { true }
    
    rules page project(*) { true }
  
    rules page issue(*) { true }
    
  
    rules page editProject(p : Project) {
      securityContext.loggedIn
    }
    
    rules page newProject() {
      securityContext.loggedIn
    }
    
    rules page newIssue(p : Project) {
      securityContext.loggedIn
    }
    
    rules page editIssue(*) { 
      securityContext.loggedIn
    }
    
    rules template newProjectLink() {
      securityContext.loggedIn
    }
    
    rules template editProjectLink(p : Project) {
      securityContext.loggedIn
    }

    rules template newIssueLink(p : Project) {
      securityContext.loggedIn
    }
    
    rules template newSubIssue(i : Issue) {
      securityContext.loggedIn
    }
  
    rules template editIssueLink(i : Issue) {
      securityContext.loggedIn
    }
    
    rules template assignToMe(i : Issue) {
      i.assignee != securityContext.principal
    }

  }
  
