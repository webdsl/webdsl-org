module page/ac
 
  access control rules  
  
    rule page page(p:Page){
      true
    }
    
    //ac rule to prevent editing of older versions
    rule page editPage(p:Page){
      p.isLatestVersion()
    }
   
    rule page previewPage(p: Page){
      true
    }
      