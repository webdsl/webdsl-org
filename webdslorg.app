application webdslorg

imports template/main
imports user/main
imports search/main
imports message/main
imports page/main
imports content/main
imports news/main
imports menu/main

imports manage
imports ac
imports login
imports global-settings


  // old main page, redirect to keep old links working
  page home(){
    init{
      return root();
    }
  }

  template formgroup(s:String){
    <fieldset>
      <legend>
        output(s)
      </legend>
      elements()
    </fieldset>
  }

  page root(){
    main()
    template localBody() {
      showNews()
    }
    template sidebarPlaceholder(){
      sidebar{
        "News"
      }
    }
  }

  access control rules
    rule page root(){ true }
