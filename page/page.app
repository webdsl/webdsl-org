module page/page
  
 define page page(p:Page){
    main()
    define localBody(){
      header{ 
        output(p.title)
      } 
      break
      output(p.content)
      break
      output(p.contentlist)
      break
      navigate(editPage(p)){"edit"}
      break
      if(p.next != null){
        "View next version: "
        output(p.next as Page)
      }
      if(p.previous != null){
        "View previous version: "
        output(p.previous as Page)
      }
      break
      "version: "
      if(p.isLatestVersion()){
        output(p.version)
      }
      else{
        output(p.previousVersionNumber)    
      }
    }
  }
  
  //TODO ac rule to prevent editing of older versions
  define page editPage(p:Page){
    /**
     *  need to create a temp object right away in order to keep track of the latest version number
     *  that way changes to the object while editing can be observed
     */     
    init{
      var temp : Page; // TODO fix bug: this is seen as page var, init was happening twice
      
      temp := p.clone();
      
      temp.url := temp.id.toString(); //needed because url property is used in url, caused by id annotation
      temp.creator := test_user; //current user
      temp.storeVersionDerivedFrom(p);
      
      temp.save();
      
      //message("preview object created");
      return previewPage(temp);
    }
  }
  
  function previewPageWarning(p: Page): Bool{
    var old : Page := p.previousPage;
    var oldPageCurrentHash :String := old.versionHash();
    if(p.warnedAboutVersion != oldPageCurrentHash){   // < operator on strings should not be allowed
      p.warnedAboutVersion := oldPageCurrentHash;
      message("Warning: original page has been modified");
      return true;
    }
    return false;
  }
  
  function finalizePageEdit(p: Page): Bool{
    var old : Page := p.previousPage;
    if(previewPageWarning(p)){
      p.save();
      return false;
    }
    else{
      var content := old.content;
      var creator := old.creator;
      var previous := old.previous;
      var contentlist := old.contentlist;
        
      //old becomes the new, to keep clean url on latest version
      old.content := p.content;
      old.previous := p;
      old.creator := p.creator;
      old.contentlist := p.contentlist; 
      old.save();
         
      p.contentlist := contentlist;
      p.previous := previous;
      p.content := content;
      p.creator := creator;
      p.previousVersionNumber := old.version;
      p.temp := false;
      //p.next := old; not necessary due to inverse relation
      p.save();
      return true;
    }    
  }
  
  define page previewPage(p: Page){
    var old : Page := p.previousPage
    main()
    define localBody(){
      header{ 
        output(p.title)
      } 
      if(p.isBasedOnDifferentVersion(old)){
        /*group("Original page"){
          output(old.content)
        }*/
        group("Original page"){
          output(old.contentlist)     
          //editContents(old.contentlist) // no form so cant be used to edit, not sure about this, need to check implementation
          //input(old.content) //abuse of input here, since there is no form aroud it, it wont be submitted
        }
        /*group("Differences"){
          output(old.content.diff(p.content))
        }*/
      }
      group("Preview"){
        output(p.contentlist)
      }
      group("Edit"){
        form{
          input(p.content)
          break
          editContents(p.contentlist)
          break
          action("refresh",refresh() ) 
          action("finalize",finalize())
          navigate(page(old)){"cancel"} //temp page entities still need to be removed somewhere
        }
      }
      action refresh(){
        previewPageWarning(p);
        p.save();
      }
      action finalize(){
        if(finalizePageEdit(p)){           
          return page(old);
        }
      }
    }
  }
