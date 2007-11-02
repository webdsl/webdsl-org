module issues/pages

section projects

  define page viewProject(p : Project) 
  {
    main()
    title{"Project - " output(p.name)}
    define body() 
    {
      section{
        header{output(p.name)}
        
        output(p.issues)
      }
    }
  }
  
  define page viewIssue(i : Issue)
  {
    main()
    title{output(i.key) ": " output(i.title)}
    
    define sidebar()
    {
      issueProperties(i)
    }
    
    define body() 
    {
      output(i.project)
    
      section{
        header{output(i.title)}
        
        Section{
          header{"Dependencies"}
          "Requires"    output(i.requires)
          "Required by" output(i.requiredby)
        }
    
        Section{
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
  
  define newIssue(p : Project)
  { 
    var newIssue : Issue := Issue { };
    var theme : Theme := null;
    
    input(newIssue.title)
    input(newIssue.type)
    input(newIssue.priority)
    input(theme)
    
    actionLink("Submit", submit())
    
    action submit() {
      newIssue.key := p.key + "-" + p.nextkey;
      p.nextkey := p.nextkey + 1;
      newIssue.status := open;
      newIssue.reporter := securityContext.principal;
      newIssue.themes := {theme};
      //newIssue.submitted := today();
      //newIssue.updated := today();
      newIssue.persist();
      return editIssue(newIssue);
    }
  
  }