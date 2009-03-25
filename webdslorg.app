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
    }
  }
