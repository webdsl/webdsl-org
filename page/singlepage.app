module page/singlepage
 
  define page singlepage(p:Page){
    main()
    define localBody(){
      showPage(p)
      navigate(page(p)){"Full page"}
      if(p.next != null){
        break
        navigate(singlepage(p.next)){"Next version"}
      }
      if(p.previous != null){
        break
        navigate(singlepage(p.previous)){"Previous version"}
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
      break
      "Hidden: "
      output(p.hidden)
      if(loggedIn() && p.isLatestVersion()){
        break
        navigate(editPage(p)){"Edit this page"}
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
    }
  }
 