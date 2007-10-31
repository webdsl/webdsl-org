module issues/pages

imports issues/data

section 

  define page viewProject(p : Project)
  {
    main()
    title{"Project - " output(p.name)}
    define body() 
    {
      section{
        header{output(p.name)}
      }
    }
  }
  
  define page viewIssue(i : Issue)
  {
  
  }
  