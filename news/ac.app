module news/ac

  access control rules
  
    rule page createNews(){ 
      loggedIn()
    }
    
    rule page editNews(*){ 
      loggedIn()
    }