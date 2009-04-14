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
    output(topmenu)
    if(allowCreateUser()){
      "  |  "
      navigate(createUser()){"Add User"}
    } 
    if(loggedIn()){
      "  |  "
      navigate(listUsers()){"List Users"}
      "  |  "
      navigate(createPage()){"Add Page"}
      "  |  "
      navigate(listPages()){"List Pages"}
      "  |  "
      navigate(createNews()){"Add News"}
      "  |  "
      navigate(editMenu()){"Edit Menu"}
      "  |  "
      navigate(manage()){"Cleaning"}
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
    "  |  "
    navigate(listPages()){"Page Index"}
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
    //" and "
    //navigate(url("http://www.strategoxt.org")){"Stratego/XT"}
  }