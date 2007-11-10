module issues/pages

section issue tracker main page

  define page issues()
  { 
    main()
    title{"Issue Tracker"}
    define body()
    {
      section{
        header{"Projects"}
        list { for(p : Project) {
          listitem { output(p) }
        } }
      }
    }
  }

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
          header{"Issues"}
          //output([i in for(i in p.issues where i.status = open)])
          list{ for(i : Issue in p.issuesList) {
            listitem { 
              output(i) ": " output(i.title)
            }
          } }
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
    
    form {
      input(newIssue.title)
      input(newIssue.type)
      input(newIssue.priority)
      actionLink("Submit", submit())
    }
    
    action submit() {
      newIssue.key      := p.key + "-" + p.nextkey.toString();
      newIssue.project  := p;
      p.issues.add(newIssue);
      p.nextkey         := p.nextkey + 1;
      newIssue.status   := open;
      newIssue.reporter := securityContext.principal;
      p.persist();
      newIssue.persist();
      return editIssue(newIssue);
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
        header{output(i.title)}
        section{ 
          header{"Description"}
          output(i.description)
        }
        //section{
        //  header{"Dependencies"}
        //  "Requires"    output(i.requires)
        //  "Required by" output(i.requiredby)
        //}
      }
    }
  }
  
  define issueProperties(i : Issue)
  {
    table{
      row{"Project:"  output(i.project)}
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
  