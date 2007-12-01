module issues/issues

section submitting issues

  define newIssueLink(p : Project)
  {
    navigate(newIssue(p)){"Submit issue"}
  }
  
  define page newIssue(p : Project)
  {
    main()
    define body() {
      var newIssue : Issue := 
        Issue { 
          type     := bug
          status   := open
          priority := major
        };
    
      section{
        header{"Submit Issue for Project " output(p)}
        
        form {
          input(newIssue.title)
          input(newIssue.type)
          input(newIssue.priority)
          action("Submit", submit())
        }

        action submit() {
          p.submitIssue(newIssue);
          newIssue.reporter := securityContext.principal;
          newIssue.persist();
          return editIssue(newIssue);
        }
      }
    }
  }
  
  define newSubIssue(i : Issue)
  {
    form{
      actionLink("Add Issue", addSubIssue())
      action addSubIssue() {
        var newIssue : Issue := 
          Issue{
            type     := bug
            status   := open
            priority := major
            requiredby := i
          };
        i.project.submitIssue(newIssue);
        newIssue.reporter := securityContext.principal;
        return editIssue(newIssue);
      }
    }
  }

section viewing issues

  define page issue(i : Issue)
  {
    // make sure this is a proper issue
    // otherwise go to error page
    init {
      if(i.project = null) {
        // This is a new issue
        goto issues();
      }
    }
    main()
    title{output(i.key) ": " output(i.title)}
    
    define applicationSidebar()
    {
      issueProperties(i)
      issueOperations(i)
    }
    
    define body() 
    {
      output(i.project)
      section{
        header{output(i.type.name) ": " output(i.title)}
        par{ 
          output(i.description)
        }
        section{
          header{"Requires"}
          issueList(i.requiresList)
        }
        section{
          header{"Required by"}
          issueList(i.requiredbyList)
        }
      }
    }
  }
  
  define issueList(is : List<Issue>)
  {
    list { for (i : Issue in is order by i.type ) {
      listitem{ output(i) ": " output(i.title) }
    } }
  }
  
  define issueListFuture(is : List<Issue>)
  {
    section{
      header{"Themes"}
      list { for (i : Issue in is) {
        if (i.type = theme) {
          listitem{ output(i) ": " output(i.title) }
      } } }
    }
    section{
      header{"Features"}
      list { for (i : Issue in is) {
        if (i.type = feature) {
        listitem{ output(i) ": " output(i.title) }
      } } }
    }
    section{
      header{"Bugs"}
      list { for (i : Issue in is) {
        if(i.type = bug) {
          listitem{ output(i) ": " output(i.title) }
      } } }
    }
  }
  
  define issueProperties(i : Issue)
  {
    table{
      row{"Project:"  output(i.project)}
      row{"Issue:"    output(i)}
      row{"Type:"     output(i.type)}
      row{"Status:"   output(i.status)}
      row{"Priority:" output(i.priority)}
      row{"Assignee:" output(i.assignee)}
      row{"Reporter:" output(i.reporter)}
    }
  }
  
section issue operations

  define editIssueLink(i : Issue)
  {
    navigate(editIssue(i)){"Edit"} " this issue"
  }
  
  define assignToMe(i : Issue)
  {
    form{ actionLink("Assign to me", assignToMe()) }
    action assignToMe() {
      i.assignee := securityContext.principal;
      return issue(i);
    }
  }

  define issueOperations(i : Issue)
  {
    list{ 
      listitem{ editIssueLink(i) }
      listitem{ assignToMe(i) }
    }
  }