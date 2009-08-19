application webdslorg

imports template/main
imports user/main
//imports style/main
imports message/main
imports page/main
imports content/main
imports news/main
imports menu/main

imports manage
imports ac
imports login
imports global-settings

  define page home() 
  {
    main()
    define localBody() {
      showNews()
    }
    define sidebarPlaceholder(){
      sidebar{
        "News"
      }
    }
  }
  
  
  
  define page root(){
    init{
      return home();
    }
  }

  access control rules 
    rule page root(){true}