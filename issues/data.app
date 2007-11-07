module issues/data

section projects

  entity Project {
    projectname :: String (name)
    key         :: String (id)
    description :: WikiText
    
    lead        -> User
    members     -> Set<User>
    
    issues      -> Set<Issue>   (inverse=Issue.project)
  //themes      -> Set<Theme>   (inverse=Theme.project)
  //releases    -> Set<Release> (inverse=Release.project)
    
    nextkey     :: Int
  }

section issues
  
  entity Issue {
    key         :: String (id, unique, name) 
    type        -> IssueType
    priority    -> IssuePriority
    status      -> IssueStatus
    
    title       :: String 
    description :: WikiText
    project     -> Project (inverse=Project.issues)
    
    reporter    -> User
    assignee    -> User
    
    submitted   :: Date
    updated     :: Date
    
  //requires    -> Set<Issue> (inverse=Issue.requiredby)
  //requiredby  -> Set<Issue> (inverse=Issue.requires)
    
  //themes      -> Set<Theme> (inverse=Theme.issues)
  //release     -> Release (inverse=Release.issues)
  }
  
  // issue keys should be automatically generated as project.key + "-" + n
  // where n is the next issue number in the project
  
sections issue properties

  entity IssueType {
    type :: String (name)
  }
  
  entity IssuePriority {
    priority :: String (name)
  }
  
  entity IssueStatus {
    status :: String (name)
  }
  
  globals {
  
    var open   : IssueStatus := IssueStatus { status := "Open" };
    var closed : IssueStatus := IssueStatus { status := "Closed" };
    
    var bug     : IssueType := IssueType { type := "Bug" };
    var feature : IssueType := IssueType { type := "Feature" };
    
    var critical : IssuePriority := IssuePriority { priority := "Critical" };
    var major    : IssuePriority := IssuePriority { priority := "Major" };
    var minor    : IssuePriority := IssuePriority { priority := "Minor" };
    
  }
  
section themes

  entity Theme {
    codename    :: String (name)
    title       :: String
    description :: WikiText
    //issues      -> Set<Issue> (inverse=Issue.themes)
    //project     -> Project (inverse=Project.themes)
  }
 
section releases

  entity Release {
    codename    :: String (name)
    title       :: String
    description :: WikiText
    released    :: Date
    //issues      -> Set<Issue> (inverse=Issue.release)
    //project     -> Project (inverse=Project.releases)
  }
  
  
  
  