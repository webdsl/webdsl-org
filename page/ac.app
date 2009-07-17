module page/ac
 
  access control rules  
  
    //ac rule to prevent editing of older versions
    rule page editPage(p:Page){
      loggedIn() &&
      p.isLatestVersion()
    }
      
    pointcut loggedInPages(){
      page previewPage(*),
      page createPage()
    }
    rule pointcut loggedInPages(){
      loggedIn()
    }
    
    pointcut openPages(){
      page listPages(), 
      page listAllPages(), 
      page listSpecificPages(*) 
    }
    rules pointcut openPages(){
      true
    }
    
    pointcut pageView(p:Page){
      page page(p),
      page indexpage(p),
      page singlepage(p)
    }
    rule page selectpage(top:Page, p:Page){
      (!p.hidden && !top.hidden) || loggedIn()
    }  
    rule pointcut pageView(p:Page){
      !p.hidden || loggedIn()
    }
 /*
    rule page editPageURL(p:Page){
      loggedIn() &&
      p.isLatestVersion()
    }
   */ 
  /* 
   rule page deletePage(p:Page){
     loggedIn()
   }*/