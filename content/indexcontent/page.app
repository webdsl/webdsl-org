module content/indexcontent/page
  
  define output(c: IndexContent){ 
    output(c.index)
  }
  
  define editContent(c: IndexContent){ 
    //TODO default list input: input(c.index)
    //TODO for with index Int in templates
    //for(i:Int in 0 to c.index.length-1){
    
    for(p:Page in c.index){
      
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
    for(p: Page where !p.temp){
      output(p)
      action("add",add(p))
      action add(p:Page){
        c.index.add(p);
        c.save();
      }    
      
      break  
    }
  }