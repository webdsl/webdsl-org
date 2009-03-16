module content/data

  entity Content {
    previousVersion :: Int
  }

  entity ContentList {
    contents -> List<Content>
    
    previousVersion :: Int
    
    function clone() : ContentList{
      var cl := ContentList{  previousVersion := this.version  };
      for(c : Content in contents){
        if(c isa WikiContent){
          cl.contents.add((c as WikiContent).clone() as Content); //ugly
        }
      }
      cl.save();
      //message("cl copied "+cl.contents.length);
      return cl;
    }
  }
  