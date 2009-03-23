module page/ac
 
  access control rules  
  
    rule page page(p:Page){
      true
    }
    
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
      
    rule page singlepage(p:Page){
      true
    }
    rule page indexpage(p:Page){
      true
    }