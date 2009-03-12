application webdslorg

imports template/main
imports wikipage/main
imports user/main
imports style/main
imports message/main
imports index/main

  define page home() 
  {
    title{"WebDSL.org"}
    main()
    define localBody() {
      "body"
      section{
        for(u:User){
          output(u)" "
          navigate(editUser(u)){"edit"}
          "    "
        }
      
        for(p:WikiPage where p.isLatestVersion()){
          output(p)" "
          navigate(editWikiPage(p)){"edit"}
          "    "
        }
      }
    }
  }

  

