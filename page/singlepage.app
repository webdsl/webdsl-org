module page/singlepage
 
  define page singlepage(p:Page){
    main()
    define localBody(){
      showPage(p)
      navigate(page(p)){"Full page"}
    }
    define sidebarPlaceholder(){
      pageSidebar(p)
    }
  }
 
  define pageDetails(p:Page, showAlways:Bool){
      "Version: "
      if(p.isLatestVersion()){
        output(p.version)
      }
      else{
        output(p.previousVersionNumber)    
      }
      " "
      "Last Edit: "
      output(p.creator.name)
      " "
      output(p.time)
      " "
      "Hidden: "
      output(p.hidden)
      break
      if(p.previous != null){
        navigate(singlepage(p.previous)){"Previous version"}
        break
      }
      if(p.next != null){
        navigate(singlepage(p.next)){"Next version"}
        break
      }
      if(loggedIn() && p.isLatestVersion()){
        navigate(editPage(p)){"Edit this page"}
        break
        /*
        if(!p.hidden){
          break
          form{action("Hide this page",action{p.hidden := true; p.save();})}
        }
        if(p.hidden){
          break
          form{action("Show this page",action{p.hidden := false; p.save();})}
        }
        */
        //break
        //navigate(deletePage(p)){"Delete this page"}
      }
      break
  }
  
  access control rules
    rule template pageDetails(p:Page, showAlways :Bool){
      loggedIn() || showAlways
    }