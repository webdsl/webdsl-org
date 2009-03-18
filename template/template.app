module template/template

  define main() 
  {
    title{"WebDSL.org"}
    top()
    sitemenu()
    body()
    footer()
  }
  
  define body(){
    messages() // built-in
    //sidebar()
    localBody()
  }
  
  define sitemenu(){
    navigate(home()){"Home"}
    "  |  "
    navigate(page(page_manual)){"Manual"}
    "  |  "
    navigate(page(page_publications)){"Publications"}
    if(allowCreateUser()){
      "  |  "
      navigate(createUser()){"Add User"}
    } 
    if(loggedIn()){
      "  |  "
      navigate(listUsers()){"List Users"}
    }  
  }
  /*
  define sidebar(){
    navigate(home()){"Home"}
  }
  */
  define localBody(){
    "default localBody"
  }
  
  define top() {
    navigate(home()){
      image("/images/logosmall.png")
    }
    topRight()
  }
  
  define topRight(){
    /*navigate(home()){"Search"}
    "  |  "*/
    navigate(login()){"Login"}
    navigate(logout()){"Logout"}
    "  |  "
    navigate(page(page_about)){"About"}
  }
  
  define footer() {
    leftFooter()
    rightFooter()
  }

  define leftFooter(){
    //navigate(home()) { "About WebDSL" }
  }
  
  define rightFooter(){
    "powered by "
    navigate(url("http://www.webdsl.org")){"WebDSL"}
    " and "
    navigate(url("http://www.strategoxt.org")){"Stratego/XT"}
  }