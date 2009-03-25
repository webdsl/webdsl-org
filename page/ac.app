module page/ac
 
  access control rules  
  
    //ac rule to prevent editing of older versions
    rule page editPage(p:Page){
      loggedIn() &&
      p.isLatestVersion()
    }
   
    rule page previewPage(p: Page){
      loggedIn()
    }
    
    rule page listPages(){
      loggedIn()
    }
      
    rule page createPage(){
      loggedIn()
    }
      
    pointcut pageView(p:Page){
      page page(p),
      page indexpage(p),
      page singlepage(p)
    }
    
    rule pointcut pageView(p:Page){
      true
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