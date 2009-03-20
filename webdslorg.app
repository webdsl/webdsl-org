application webdslorg

imports template/main
imports user/main
imports style/main
imports message/main
imports page/main
imports content/main
imports news/main

imports manage
imports ac
imports login
imports global-settings

  define page home() 
  {
    main()
    define localBody() {
      showNews()
      /*
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
      */
    }
  }
  /*
  define page search(){
    main()
    define localBody() {
      var pages : List<Page> :=
        select p from Page as p 
        where (p._);

    }
  }*/