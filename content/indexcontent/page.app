module content/indexcontent/page
  
  define output(c: IndexContent){ 
    block[style := "margin-left: "+20+"px"]{
      navigate(section(c)){output(c.title)}
      output(c.index)
      for(ci : IndexContent in c.subsections){
        output(ci)
      }
    }
  }
  
  define page section(c: IndexContent){
    main()
    define localBody(){
      showSection(c)
    }  
  }
  
  define showSection(c : IndexContent){ 
    section{header{ output(c.title) }}
    section{
      for(p:Page in c.index){
        showPage(p)
      }
      for(ci : IndexContent in c.subsections){
        showSection(ci)
      }
    }
  }
  
  define editContent(c: IndexContent){ 
    block[style := "margin-left: "+20+"px"]{
      input(c.title)
      break
      //TODO default list input: input(c.index)
      //TODO for with index Int in templates
      //for(i:Int in 0 to c.index.length-1){
      
      for(p:Page in c.index where p.isLatestVersion()){
        
        //output(c.index.get(i))
        output(p)
        action("up",up(p))
        action("down",down(p))
        action("remove",remove(p))
        action up(p:Page){
          var temp := c.index.indexOf(p);
          if(temp != null){
            c.index.set(temp,c.index.get(temp-1));
            c.index.set(temp-1,p);
            c.save();
          }
        }
        action down(p:Page){
          var temp := c.index.indexOf(p);
          if(temp != null){
            c.index.set(temp,c.index.get(temp+1));
            c.index.set(temp+1,p);
            c.save();
          }
        }
        action remove(p:Page){
          //TODO actual removeAtIndex
          c.index.remove(p);
          c.save();
        }
        
        break
      }
      for(p: Page where p.isLatestVersion()){
        output(p)
        action("add",add(p))
        action add(p:Page){
          c.index.add(p);
          c.save();
        }    
        
        break  
      }
      
      if(c.subsections.length > 0) { editSubsections(c) }
      addSubsections(c)
    }
  }
  
  define editSubsections(c: IndexContent){ 
    for(ic : IndexContent in c.subsections){
      editContent(ic)
      action("up",up(ic))
      action("down",down(ic))
      action("remove",remove(ic))
      action up(ic:IndexContent){
        var temp := c.subsections.indexOf(ic);
        if(temp != null){
          c.subsections.set(temp,c.subsections.get(temp-1));
          c.subsections.set(temp-1,ic);
          c.save();
        }
      }
      action down(ic:IndexContent){
        var temp := c.subsections.indexOf(ic);
        if(temp != null){
          c.subsections.set(temp,c.subsections.get(temp+1));
          c.subsections.set(temp+1,ic);
          c.save();
        }
      }
      action remove(ic:IndexContent){
        c.subsections.remove(ic);
        c.save();
      }
      break
    }
  }

  define addSubsections(c: IndexContent){ 
    action("add section",add())
    action add(){
      c.subsections.add(IndexContent{});
      c.save();
    }  
    break  
  }
  