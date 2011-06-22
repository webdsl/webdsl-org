module template/template

  /* 
  to align the sidebar left of the body, it is part of a bigger block main(), maincenter() is a smaller block inside main()
  both are centered using margin-left:auto;margin-right:auto;
  */
  define main() 
  {
    includeJS("http://ajax.googleapis.com/ajax/libs/jquery/1.5.0/jquery.min.js")
    includeJS("codeblockhover.js")
    <div class="page-wrap">
      <div class="main">
        <div class="sidebarPlaceholder">
          <div class="sidebar">
            sidebarPlaceholder()
          </div> 
        </div>
        <div class="maincenter"> 
          maincenter()
        </div>
      </div>
      <div class="clear"></div> 
      <div class="push"></div> 
    </div>  
    <div class="footer">
      footer()
    </div>
    
    //google analytics
    <script type="text/javascript">
      var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
      document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
    </script>
    <script type="text/javascript">
      try {
      var pageTracker = _gat._getTracker("UA-10588367-1");
      pageTracker._trackPageview();
      } catch(err) {}
    </script>
  }
  
  define maincenter(){
    title{"WebDSL.org"}
    <div class="top"> top() </div>
    <div class="sitemenu"> sitemenu() </div>
    <div class="body"> body() </div>
  }
  
  
  define body(){
    messages() // built-in
    localBody()
  }
  
  define sitemenu(){
    <div class="menucontent">
      navigate(home()){"Home"}
      output(topmenu)
      if(loggedIn()){
        "  |  "
        navigate(createPage()){"Add Page"}
        "  |  "
        navigate(listPages()){"List Pages"}
        if(loggedIn() && securityContext.principal.isAdmin){
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
      if(allowCreateUser()){
        "  |  "
        navigate(createUser()){"Add User"}
      } 

      searchform()
    </div>
  }
  
  
  define sidebarPlaceholder(){
  } 
  
  define sidebar(){
    <div class="sidebarcontent">
      elements
    </div>
  }
  
  define localBody(){
    "default localBody"
  }
  
  define top() {
    <div class="topRight"> 
      topRight() 
    </div>
    navigate(home()){
      image("/images/logosmall.png")
    }
  }
  
  define topRight(){
    /*navigate(home()){"Search"}
    "  |  "*/
    navigate(login()){"Login"}
    navigate(logout1()){"Logout"}
    "  |  "
    navigate(page(page_about)){"About"}
    "  |  "
    navigate(listPages()){"Page Index"}
  }
  
  define footer() {
    <div class="footerinner">
      <div class="leftFooter">
        leftFooter()
      </div>
      <div class="rightFooter">
        rightFooter()
      </div>
    </div>
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