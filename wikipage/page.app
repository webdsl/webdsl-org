module wikipage/page
  
  define page wikiPage(p:WikiPage){
    main()
    define localBody(){
      header{ 
        output(p.title)
      } 
      break
      output(p.content)
      break
      navigate(editWikiPage(p)){"edit"}
      break
      if(p.next != null){
        "View next version: "
        output(p.next as WikiPage)
      }
      if(p.previous != null){
        "View previous version: "
        output(p.previous as WikiPage)
      }
      break
      "version: "
      if(p.isLatestVersion()){
        output(p.version)
      }
      else{
        output(p.previousVersion)    
      }
    }
  }
  
  //TODO ac rule to prevent editing of older versions
  define page editWikiPage(p:WikiPage){
    /**
     *  need to create a temp object right away in order to keep track of the latest version number
     *  that way changes to the object while editing can be observed
     */     
    init{
      var temp : WikiPage := WikiPage { 
        title := p.title 
        content := p.content 
        previousVersion := p.version //used to detect changes
        warnedAboutVersion := p.version
        temp := true
      
      };
      temp.url := temp.id.toString(); //needed because url property is used in url, caused by id annotation
      temp.creator := test_user; //current user
      temp.save();
      
      message("preview object created");
      return previewWikiPage(p,temp);
    }
  }
  
  function previewPageWarning(old:WikiPage,p:WikiPage): Bool{
    if(p.warnedAboutVersion < old.version){
      p.warnedAboutVersion := old.version;
      message("Warning: original page has been modified");
      return true;
    }
    return false;
  }
  
  function finalizePageEdit(old:WikiPage,p:WikiPage): Bool{
    if(previewPageWarning(old,p)){
      p.save();
      return false;
    }
    else{
      var content := old.content;
      var creator := old.creator;
      var previous := old.previous;
        
      //old becomes the new, to keep clean url on latest version
      old.content := p.content;
      old.previous := p;
      old.creator := p.creator;
       
      old.save();
         
      p.previous := previous;
      p.content := content;
      p.creator := creator;
      p.previousVersion := old.version;
      p.temp := false;
      //p.next := old; not necessary due to inverse relation
      p.save();
      return true;
    }    
  }
  
  define page previewWikiPage(old: WikiPage,p:WikiPage){
    main()
    define localBody(){
      header{ 
        output(p.title)
      } 
      if(old.version != p.previousVersion){
        group("Original page"){
          output(old.content)
        }
        group("Original page source"){
          output(old.content.toString())
        }
        group("Differences"){
          output(old.content.diff(p.content))
        }
      }
      group("Preview"){
        output(p.content)
      }
      group("Edit"){
        form{
          input(p.content)
          break
          action("refresh",refresh() ) 
          action("finalize",finalize())
          navigate(wikiPage(old)){"cancel"} //temp page entities still need to be removed somewhere
        }
      }
      action refresh(){
        previewPageWarning(old,p);
        p.save();
      }
      action finalize(){
        if(finalizePageEdit(old,p)){           
          return wikiPage(old);
        }
      }
    }
  }
