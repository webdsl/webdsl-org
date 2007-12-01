module issues/init

section initial project
  
  globals {
    var webdslproject : Project :=
      Project {
        projectname := "WebDSL"
        key         := "WEBDSL"
        description := "A domain-specific language for web applications"
      };
  }