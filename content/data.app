module content/data

  entity Content {
    //previousVersion :: Int
    //warnedAboutVersion :: Int
    //isClone :: Bool
    //function isBasedOnDifferentVersion(c:Content): Bool{ return false; }
    contentList -> ContentList (inverse=ContentList.contents)
    function versionHash() :String{
      return "Content" + id + version;
    }
    function clone():Content{return null;}
    
  }

  entity ContentList {
    page -> Page    // cannot be inverse because inverse needs to point to latest version //(inverse = Page.contentlist)
    contents <> List<Content>
    
    previousVersion :: Int
    //warnedAboutVersion :: Int
    
    function clone() : ContentList{
      var cl := ContentList{  
        page := page
      };
      for(c : Content in contents){
        cl.contents.add(c.clone());
      }
      cl.save();
      //message("cl copied "+cl.contents.length);
      return cl;
    }
    
    function versionHash() :String{
      var hash := "";
      for (c:Content in contents){
        hash := hash + c.versionHash();
      }
      return "ContentList" + id + version + hash;
    }
    
    
    
    /*
    function differentContents(cl:ContentList):Bool{
      if(cl.contents.length != contents.length){return true;}
      for(i : Int from 0 to contents.length-1){
        if(!contents.get(i).isClone //might be completely new object
           || contents.get(i).isBasedOnDifferentVersion(cl.contents.get(i))) {
          return true;
        }
      }
      return false;
    }
    
    function isBasedOnDifferentVersion(cl:ContentList): Bool{
      return this.previousVersion != cl.version || differentContents(cl);
    }
    */
  }
  