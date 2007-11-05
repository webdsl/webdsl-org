module issues/pages

section projects

  define page project(p : Project) 
  {
    main()
    title{"Project - " output(p.name)}
    define body() 
    {
      section{
        header{output(p.name)}
          
        par{ output(p.description) }
        
        par{ newIssue(p) }
        
        section{
          header{"Open Issues"}
          //output([i in for(i in p.issues where i.status = open)])
        }
      }
    }
  }
  
section creating themes

  define newTheme(p : Project)
  {
    var newTheme : Theme := Theme{};  
  }
  
section creating issues
  
  define newIssue(p : Project)
  { 
    var newIssue : Issue := Issue { };
    //var theme : Theme := null;
    
    form {
      input(newIssue.title)
      input(newIssue.type)
      input(newIssue.priority)
      //input(theme)
      actionLink("Submit", submit())
    }
    
    action submit() {
      newIssue.key      := p.key + "-" + p.nextkey.toString();
      newIssue.project  := p;
      p.nextkey         := p.nextkey + 1;
      newIssue.status   := open;
      newIssue.reporter := securityContext.principal;
      //newIssue.themes   := {theme};
      newIssue.persist();
      return editIssue(newIssue);
    }
  }
 
section viewing issues

  define page issue(i : Issue)
  {
    main()
    title{output(i.key) ": " output(i.title)}
    
    define sidebar()
    {
      issueProperties(i)
      issueOperations(i)
    }
    
    define body() 
    {
      output(i.project)
    
      section{
        header{output(i.title)}
        
        section{
          header{"Dependencies"}
          "Requires"    output(i.requires)
          "Required by" output(i.requiredby)
        }
    
        section{
          header{"Description"}
          output(i.description)
        }
      }
    }
  }
  
  define issueProperties(i : Issue)
  {
    table{
      row{"Key:"      output(i)}
      row{"Type:"     output(i.type)}
      row{"Status:"   output(i.status)}
      row{"Priority:" output(i.priority)}
      row{"Assignee:" output(i.assignee)}
      row{"Reporter:" output(i.reporter)}
    }
  }
  
section issue operations

  define issueOperations(i : Issue)
  {
    list{
      listitem{ navigate(editIssue(i)){"Edit"} " this issue" }
    }
  }
  