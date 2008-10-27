module issues/pages

section menu and navigation

  define issuesMenu()
  {
    menu { 
      menuheader{ navigate(issues()){"Issues"} }
      projectOperationsMenu()
      menuitem{ navigate(newProject()){"New Project"} }
      menuspacer{}
      for(b : Project in config.projectsList) {
          menuitem{ output(b) }
      }
    }
  }
      
  define projectOperationsMenu() { }
  
  define projectOperationsMenuItems(p : Project)
  {
    menuitem{ navigate(newIssue(p)){"New Issue"} }
    menuitem{ navigate(editProject(p)){"Configure Project"} }
    menuspacer{}
  }
  
section issue tracker main page

  define page issues()
  { 
    main()
    title{"Projects"}
    define applicationSidebar() {
    }
    define body()
    {
      section{
        header{"Projects"}
        for(p : Project) {
          section{ 
            header{output(p)}
            output(p.pitch)
          }
        }
      }
    }
  }

section projects

  define page newProject()
  {
    main()
    title{"Create New Project"}
    define body() {
      var newProject : Project := 
        Project{ 
          lead := securityContext.principal
        };
      section{
        header{"Create New Project"}
        form{
          table{
            row{ "Projectname: "   input(newProject.projectname) }
            row{ "Key: "           input(newProject.key) }
            row{ "Pitch: "         input(newProject.pitch) }
            row{ "Description: "   input(newProject.description) }
            row{ "Project lead: "  input(newProject.lead) }
          }
          action("Create the project", createProject())
          action createProject() {
            newProject.persist();
            return project(newProject);
          }
          par { 
            "Note: pitch is short description for use in overviews."
            "Description is text for main page of the project." 
          }
        }
      }
    }
  }
  
  define page project(p : Project)
  {
    main()
    title{"Project - " output(p.name)}
    define projectOperationsMenu() { 
      projectOperationsMenuItems(p)
    }
    define body() 
    {
      section{
        header{"Project: " output(p.name)}
        par{ output(p.pitch) }
        par{ output(p.description) }
        section{
          header{"Issues"}
          issueList(p.issuesList)
        }
        section{
          header{"Members"}
          list{ for(u : User in p.membersList) {
            listitem{ 
              output(u)
              if(u == p.lead) {
                " (lead)"
              }
            }
          } }
        }
      }
    }
  }
