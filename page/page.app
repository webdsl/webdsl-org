module page/page
  
  define showPage(p:Page){
    header{ 
      output(p.title)
    } 
    break
    output(p.contentlist)
    break
  }
  
  define showFullPage(p:Page){
    header{ 
      output(p.title)
    } 
    break
    output(p.contentlist.contents.get(0) as WikiContent)
    if(loggedIn()){
      break
      navigate(singlepage(p)){"view single page"}
    }
    break
    for(p:Page in (p.contentlist.contents.get(1) as IndexContent).index){
      showFullPage(p)
    }
  }
  
  define page page(p:Page){
    main()
    define localBody(){
      showFullPage(p)
    }
  }
 
  define page singlepage(p:Page){
    main()
    define localBody(){
      showPage(p)
      navigate(page(p)){"full page"}
      break
      navigate(editPage(p)){"edit"}
      break
      if(p.next != null){
        "View next version: "
        navigate(singlepage(p.next)){output(p.next.title)}
      }
      if(p.previous != null){
        break
        "View previous version: "
        navigate(singlepage(p.previous)){output(p.previous.title)}
      }
      break
      "Version: "
      if(p.isLatestVersion()){
        output(p.version)
      }
      else{
        output(p.previousVersionNumber)    
      }
      break
      "Last Edit: "
      output(p.creator.name)
      " "
      output(p.time)
    }
  }
  
  define page editPage(p:Page){
    /**
     *  need to create a temp object right away in order to keep track of the latest version number
     *  that way changes to the object while editing can be observed
     */     
    init{
      var temp : Page; // TODO fix bug: this is seen as page var, vardeclinit init was happening twice
      
      temp := p.clone();
      
      temp.url := temp.id.toString(); //needed because url property is used in url, caused by id annotation
      temp.creator := securityContext.principal; //current user
      temp.storeVersionDerivedFrom(p);
      
      temp.save();
      
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
      var creator := old.creator;
      var previous := old.previous;
      var contentlist := old.contentlist;
      var title := old.title;  
        
      //old becomes the new, to keep clean url on latest version
      old.previous := p;
      old.creator := p.creator;
      old.contentlist := p.contentlist;
      old.title := p.title; 
      old.save();
      
      p.title := title;   
      p.contentlist := contentlist;
      p.previous := previous;
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
          table{
            label("Title"){input(p.title)}
            break
            label("Content"){editContents(p.contentlist)}
            break
            row{column{column{ 
              action("refresh",refresh() ) 
              action("finalize",finalize())
              navigate(page(old)){"cancel"} //temp page entities still need to be removed somewhere
            }}}
          }
        }
      }
      action refresh(){
        previewPageWarning(p);
        p.save();
      }
      action finalize(){
        if(finalizePageEdit(p)){           
          return singlepage(old);
        }
      }
    }
  }

  define page createPage(){ 
    main()
    define localBody(){
      var p := Page{}; 
      form{
        formgroup("Create Page"){
          label("URL"){input(p.url)}
          label("Title"){input(p.title)}
          break
          action("save",save())
          action save(){
            p.initContentList();
            p.creator := securityContext.principal;
            p.save();
            message("New page created.");
            return singlepage(p);
          }
        }
      }
    }
  }

  define page listPages(){ 
    main()
    define localBody(){
      formgroup("Pages"){
        for(p:Page){
          output(p)
        }
      }
    }
  }