module issues/issues

section submitting issues

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
          table {
            row {
              "Title:"
              input(newIssue.title)
            }
            row {
              "Type:"
              input(newIssue.type)
            }
            row {
              "Priority:"
              input(newIssue.priority)
            }
           }
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
    
    define projectOperationsMenu() {
      issueOperationsMenuItems(i)
    }
    
    define body() 
    {
      block("issueProperties"){ issueProperties(i) }
      section{
        header{output(i.type.name) ": " output(i.title)}
        par{
          output(i.description)
        }
        if (i.requires.length > 0) {
          section{
            header{"Requires"}
            issueList(i.requiresList)
          }
        }
        if (i.requiredby.length > 0) {
          section{
            header{"Required by"}
            issueList(i.requiredbyList)
          }
        }
        if (i.comments.length > 0) {
          section{
            header{"Comments"}
            issueCommentList(i.comments)
          }
        }
        addIssueComment(i)
      }
    }
  }
  
  define issueListOld(is : List<Issue>)
  {
    list { for (i : Issue in is order by i.type ) {
      listitem{ output(i) }
    } }
  }
  
  // only show if not empty
  // make virtual properties?
  // make generic? -> use ordered by to order by type, then print all issues for one type
  // under header of that type's name
  // define ordering on types
  
  // why does this not typecheck?
  //define issueListFuture(is : List<Issue>)
  //{
  //  for(t : IssueType) {
  //    var is : List<Issue> := [i for(i : Issue in is where i.type = t)];
  //    if(is.size() > 0) {
  //      section {
  //        header{output(t.name)}
  //        output(is)
  //      }
  //    }
  //  }
  //}
  
  define issueListOld(is : List<Issue>)
  {
    table {
      row{ "Key" "Type" "Priority" "Title" }
      for(t : IssueType) {
        for(i : Issue in is where i.type = t) {
          row{
            navigate(issue(i)){output(i.key)}
            output(t.name)
            output(i.priority)
            output(i.title)
          }
        }
      }
    }
  }
  
  define issueList(is : List<Issue>)
  {
    table {
      row{ "Key" "Type" "Priority" "Title" }
      for(i : Issue in is order by i.type) {
        row{
          navigate(issue(i)){output(i.key)}
          output(i.type.name)
          output(i.priority.name)
          output(i.title)
        }
      }
    }
  }
  
  define issueProperties(i : Issue)
  {
    table{
      row{"Project:"    output(i.project)}
      row{"Issue:"      output(i.key)}
      row{"Type:"       output(i.type.name)}
      row{"Status:"     output(i.status.name)}
      row{"Priority:"   output(i.priority.name)}
      row{"Assignee:"   output(i.assignee)}
      row{"Reporter:"   output(i.reporter)}
      row{"Submitted:"  output(i.submitted)}
      row{"Updated:"    output(i.updated)}
      row{"Due: "       output(i.due)}
    }
  }
  
  define issueCommentList(cs : List<IssueComment>)
  {
    for(c : IssueComment in cs order by c.posted)
    {
      block("issueCommentByLine") {
        output(c.author) " - " output(c.posted)
      }
      block("issueComment") {
        output(c.content)
      }
    }
  }
  
  define addIssueComment(i : Issue)
  {
    var newComment : WikiText;
    block("newIssueComment") {
      form{
        input(newComment)
        action("Post Comment", postComment())
      }
    }
    action postComment() {
      var c : IssueComment :=
        IssueComment {
          content := newComment
          author  := securityContext.principal
          issue   := i
        };
      newComment := "";
      c.persist();      
    }
  }
  
section issue operations

  define issueOperationsMenuItems(i : Issue)
  {
    menuitem{ navigate(editIssue(i)){"Edit This Issue"} }
    menuitem{ assignToMe(i) }
    menuitem{ newSubIssue(i) }
    menuspacer{}
    projectOperationsMenuItems(i.project)
  }
  
  define assignToMe(i : Issue)
  {
    form{ actionLink("Assign to Me", assignToMe()) }
    action assignToMe() {
      i.assignee := securityContext.principal;
      return issue(i);
    }
  }

  define newSubIssue(i : Issue)
  {
    form{
      actionLink("Submit Subissue", addSubIssue())
      action addSubIssue() {
        var newIssue : Issue := 
          Issue{
            type     := bug
            status   := open
            priority := major
          };
        i.project.submitIssue(newIssue);
        i.requires.add(newIssue);
        newIssue.reporter := securityContext.principal;
        newIssue.persist();
        return editIssue(newIssue);
      }
    }
  }
