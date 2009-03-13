application webdslorg

imports template/main
imports user/main
imports style/main
imports message/main
imports page/main
imports content/main

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

  

  access control rules
    
    rule page home(){true}
    
    rule template *(*){true}