module issues/data

section projects

  entity Project {
    projectname :: String (name)
    key         :: String (id)
    pitch       :: WikiText
    description :: WikiText
    
    lead        -> User
    members     -> Set<User>

    issues      -> Set<Issue>  
    //themes      -> Set<Issue> := [i for(i : Issue in this.issues where i.type = theme)]
    //releases    -> Set<Issue> := [i for(i : Issue in this.issues where i.type = release)]

    nextkey     :: Int
  }

section issues
  
  entity Issue {
    key         :: String (id, unique, name)
    type        -> IssueType
    priority    -> IssuePriority
    status      -> IssueStatus
    
    codename    :: String
    title       :: String 
    description :: WikiText
    project     -> Project (inverse=Project.issues)
    
    reporter    -> User
    assignee    -> User
    
    submitted   :: Date
    updated     :: Date
    due         :: Date
    
    requires    -> Set<Issue> (inverse=Issue.requiredby)
    requiredby  -> Set<Issue> 
  }
  
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
    var open      : IssueStatus := IssueStatus { status := "Open" };
    var closed    : IssueStatus := IssueStatus { status := "Closed" };
    var released  : IssueStatus := IssueStatus { status := "Released" };
    var wontfix   : IssueStatus := IssueStatus { status := "Won't fix" };
    var duplicate : IssueStatus := IssueStatus { status := "Duplicate" };

    var bug         : IssueType := IssueType { type := "Bug" };
    var feature     : IssueType := IssueType { type := "Feature" };
    var task        : IssueType := IssueType { type := "Task" };
    var improvement : IssueType := IssueType { type := "Improvement" };
    var release     : IssueType := IssueType { type := "Release" };
    var theme       : IssueType := IssueType { type := "Theme" };    
    
    var blocker  : IssuePriority := IssuePriority { priority := "Blocker" };
    var critical : IssuePriority := IssuePriority { priority := "Critical" };
    var major    : IssuePriority := IssuePriority { priority := "Major" };
    var minor    : IssuePriority := IssuePriority { priority := "Minor" };
    var trivial  : IssuePriority := IssuePriority { priority := "Trivial" };
  }
  
section submitting issues

  extend entity Project {
  
    function submitIssue(newIssue : Issue) : Project {
      newIssue.key     := this.key + "-" + this.nextkey.toString();
      this.nextkey     := this.nextkey + 1;
      newIssue.project := this;
      return this;
    }
    
  }
    