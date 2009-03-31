module page/page
  
  define showPage(p:Page){
    header{ 
      output(p.title)
    }
    output(p.contentlist)
    break
  }
  
  define page editPage(p:Page){
    /**
     *  need to create a temp object right away in order to keep track of the latest version number
     *  that way changes to the object while editing can be observed
     */     
    init{
      var temp : Page; // TODO fix bug: this is seen as page var, vardeclinit init was happening twice
      
      temp := p.clone();
      
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
      var time := old.time;
      var hidden := old.hidden;
        
      //old becomes the new, to keep clean url on latest version
      old.previous := p;
      old.creator := p.creator;
      old.contentlist := p.contentlist;
      old.title := p.title;
      old.time := p.time; 
      old.url := p.tempurl;
      old.hidden := p.hidden;
      old.save();
      
      p.hidden := hidden;
      p.time := time;
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
      //if(p.isBasedOnDifferentVersion(old)){
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
      //}
      group("Preview"){
        output(p.contentlist)
      }
      form{
        formgroup("Edit")[labelWidth := "75"]{
          label("Identifier"){input(p.tempurl){validate(isUniquePageId(p.tempurl,p.previousPage),"Identifier is taken")}}
          label("Title"){input(p.title)}
          label("Content"){editContents(p.contentlist)}
          label("Hidden"){input(p.hidden)}
          formgroupDoubleColumn{"Hidden pages will still be accessible, but not shown in the index selections."}
        }
        action("Preview",refresh() ) 
        action("Finalize",finalize())
        navigate(page(old)){"cancel"} //temp page entities still need to be removed somewhere
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
          label("Identifier"){input(p.url)}
          formgroupDoubleColumn{"The identifier will be used in the URL for this page."}
          label("Title"){input(p.title)}
          break
          action("save",save())
          action save(){
            p.initContentList();
            p.creator := securityContext.principal;
            p.tempurl := p.url;
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
      group("Pages"){
        table{
          for(p:Page where p.isLatestVersion() && !p.hidden){
            output(p)
          }
        }
      }
      group("Hidden Pages"){
        table{
          for(p:Page where p.isLatestVersion() && p.hidden){
            output(p)
          }
        }
      }
    }
  }
  /*
  define page deletePage(p:Page){
    main()
    define localBody(){
      showPage(p)
      break
      "This page and all its older revisions will be deleted: "
      form{
        validate(checkDeleteEdit(p),"This page is being edited and cannot be deleted.")
        validate(checkDeleteRef(p),"This page is referenced by another page and cannot be deleted.")
        break
        action("confirm",delete())
      }
      navigate("cancel",singlepage(p))
      action delete(){
        p.delete();
        return listPages();
      }
    }
  }
  
  function checkDeleteEdit(p:Page):Bool{
    return (select u from Page as u where ((u._previousPage = ~p)
                                             and (u._temp = 1))).length == 0;
  }
  function checkDeleteRef(p:Page):Bool{
    var tmp : List<IndexContent> := select u from IndexContent as u; 
    for(ic:IndexContent in tmp){
      if(!(p in ic.index)){
        tmp.remove(ic);
      }
    }
    return tmp.length == 0;     
  }
  */