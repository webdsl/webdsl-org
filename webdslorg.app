application webdslorg

imports template/main
imports page/main
imports user/main
imports style/main
imports message/main

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
      
        for(p:Page where p.isLatestVersion()){
          output(p)" "
          navigate(editPage(p)){"edit"}
          "    "
        }
      }
    }
  }

  

