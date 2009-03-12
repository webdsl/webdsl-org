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
      navigate(editPage(p)){"edit"}
      break
      if(p.next != null){
        "View next version: "
        output(p.next)
      }
      if(p.previous != null){
        "View previous version: "
        output(p.previous)
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
  define page editPage(p:Page){
    /**
     *  need to create a temp object right away in order to keep track of the latest version number
     *  that way changes to the object while editing can be observed
     */     
    init{
      var temp : Page := Page { 
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
      return previewPage(p,temp);
    }
    /*
    main()
    define localBody(){
      header{ 
        output(p.title)
      } 
      output(p.content)    
 
      table{
        form {
          label("Content: "){input(temp.content)}
          action("preview",preview())
        }
      }
      action preview(){
        validate(p.next == null,"Cannot edit old versions"); 
        //above validate only protects when the page was old when this page was navigated to, due to use of nice names in urls
        //if the latest page was viewed here and that was edited in the mean time
        return previewPage(p,temp);
      }
       
    }
    */
  }
  
  define page previewPage(old:Page,p:Page){
    main()
    define localBody(){
      init{
              
      }
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
          navigate(page(old)){"cancel"} //temp page entities still need to be removed somewhere
        }
      }
      action refresh(){
        if(p.warnedAboutVersion < old.version){
          p.warnedAboutVersion := old.version;
          message("Warning: original page has been modified");
        }
        p.save();
      }
      action finalize(){
        if(p.warnedAboutVersion < old.version){
          p.warnedAboutVersion := old.version;
          p.save();
          message("Warning: original page has been modified");
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
          
          return page(old);
        }   
      }
    }
  }
