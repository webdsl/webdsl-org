module issues/data

section projects

  entity Project {
    title       :: String (name)
    key         :: String (unique)
    description :: Text
    
    lead        -> User
    members     -> Set<User>
    
    issues      -> Set<Issue>
    themes      -> Set<Theme>
    releases    -> Set<Release>
  }

section issues
  
  entity Issue {
    key         :: String (unique, name)
    type        -> IssueType
    priority    -> IssuePriority
    status      -> IssueStatus
    
    title       :: String 
    description :: Text
    project     -> Project
    
    reporter    -> User
    assignee    -> User
    
    created     :: Date
    updated     :: Date
    
    dependson   -> Set<Issue> (inverse=Issue.requiredby)
    requiredby  -> Set<Issue> (inverse=Issue.dependson)
    
    themes      -> Set<Themes> (inverse=Theme.issues)
    release     -> Release (inverse=Release.issues)
  }
  
  entity IssueType {
    type :: String (name)
  }
  
  entity IssuePriority {
    priority :: String (name)
  }
  
  entity IssueStatus {
    status :: String (name)
  }
 
section themes

  entity Theme {
    codename    :: String (name)
    title       :: String
    description :: Text
    issues      -> Set<Issue> (inverse=Issue.themes)
  }
 
section releases

  entity Release {
    codename    :: String (name)
    title       :: String
    description :: Text
    released    :: Date
    issues      -> Set<Issue> (inverse=Issue.release)
  }
  
sections constants

  globals {
  
    var open   : IssueStatus := IssueStatus { status := "Open" };
    var closed : IssueStatus := IssueStatus { status := "Closed" };
    
    var bug     : IssueType := IssueType { type := "Bug" };
    var feature : IssueType := IssueType { type := "Feature" };
    
    var critical : IssuePriority := IssuePriority { priority := "critical" };
    var major    : IssuePriority := IssuePriority { priority := "major" };
    var minor    : IssuePriority := IssuePriority { priority := "minor" };
    
  }
  
  
  