module template/template

  define main() 
  {
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
    //navigate(index(manual)){"Manual"}
    "  |  "
    navigate(home()){"Publications"}
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
    navigate(home()){"Search"}
    "  |  "
    navigate(home()){"Login"}
    "  |  "
    navigate(home()){"About"}
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