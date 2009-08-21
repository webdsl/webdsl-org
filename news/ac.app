module news/ac

  access control rules
  
    rule page createNews(){ 
      loggedIn() && principal.isAdmin
    }
    
    rule page editNews(*){ 
      loggedIn() && principal.isAdmin
    }
    
    rule page deleteNews(*){ 
      loggedIn() && principal.isAdmin
    }