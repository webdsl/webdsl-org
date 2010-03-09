module content/indexcontent/page
  
  define output(c: IndexContent){ 
    //block[style := "margin-left: "+20+"px"]{
    output(c.index)
    //for(p:Page in c.index){
    //  navigate(page(p)){output(p.title)}
    //}
    //  for(ci : IndexContent in c.subsections){
    //    output(ci)
    //  }
    //}
  }
 /* 
  define page section(c: IndexContent){
    main()
    define localBody(){
      showSection(c)
    }  
  }
  */
  /*
  define showSection(c : IndexContent){ 
    //section{header{ output(c.title) }}
    //section{
      for(p:Page in c.index){
        showPage(p)
      }
    //  for(ci : IndexContent in c.subsections){
    //    showSection(ci)
    //  }
    //}
  }
  */
  define editContent(c: IndexContent){ 
    //TODO this should be definable in a query more easily
     var addCol := from Page as u;
     init{
       for(p:Page in addCol){
         if(!p.isLatestVersion()
            || p.hidden 
            || p in c.index
            || (p == c.contentList.page)   //c.contentlist.page is a ref to the latest version of the page
            ){
           addCol.remove(p);
         }
       }
     }
     var toAdd : Page
     
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
     action add(){
       if(toAdd != null){
         c.index.add(toAdd);
         c.save();
       }
     } 
          
//output(c.name)
//output(c.contentList)
//output(c.contentList.page)

    //block[style := "margin-left: "+20+"px"]{
      //input(c.title)
      //break
      //TODO default list input: input(c.index)
      //TODO for with index Int in templates
      //for(i:Int in 0 to c.index.length-1){
      table{
        for(p:Page in c.index){
          //output(p == c.contentList.page)  
          //output(c.index.get(i))
          row{
            output(p)
            action("up",up(p))
            action("down",down(p))
            action("remove",remove(p))
          }
        }
      }
      select(toAdd from addCol)
      action("add",add())

      //if(c.subsections.length > 0) { editSubsections(c) }
      //addSubsections(c)
    //}
  }
  /*
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
*/
/*
  define addSubsections(c: IndexContent){ 
    action("add section",add())
    action add(){
      c.subsections.add(IndexContent{});
      c.save();
    }  
    break  
  }
  */