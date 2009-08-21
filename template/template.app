module template/template

  /* 
  to align the sidebar left of the body, it is part of a bigger block main(), maincenter() is a smaller block inside main()
  both are centered using margin-left:auto;margin-right:auto;
  */
  define no-span main() 
  {
    <div class="page-wrap">
      <span class="main">
      sidebarPlaceholder() 
        maincenter()
      </span>
      <div class="clear"></div> 
      <div class="push"></div> 
    </div>  
    footer()
  }
  
  define maincenter(){
    title{"WebDSL.org"}
    top()
    sitemenu()
    body()
  }
  
  
  define body(){
    messages() // built-in
    localBody()
  }
  
  define sitemenu(){
    <span class="menucontent">
      navigate(home()){"Home"}
      output(topmenu)
      if(loggedIn()){
        "  |  "
        navigate(createPage()){"Add Page"}
        "  |  "
        navigate(listPages()){"List Pages"}
        if(loggedIn() && securityContext.principal.isAdmin){
          if(allowCreateUser()){
            "  |  "
            navigate(createUser()){"Add User"}
          } 
          "  |  "
          navigate(listUsers()){"List Users"}
          "  |  "
          navigate(createNews()){"Add News"}
          "  |  "
          navigate(editMenu()){"Edit Menu"}
          "  |  "
          navigate(manage()){"Cleaning"}
        }
        "  |  "
        navigate(user(securityContext.principal)){"Account"}
      } 
    </span>
  }
  
  
  define sidebarPlaceholder(){
  } 
  
  define sidebar(){
    <span class="sidebarcontent">
      elements
    </span>
  }
  
  define localBody(){
    "default localBody"
  }
  
  define top() {
    topRight()
    navigate(home()){
      image("/images/logosmall.png")
    }
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