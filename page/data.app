module page/data
  
  entity Page {
    url      :: String (id)
    title    :: String (name)
    previous -> Page
    next     -> Page (inverse=Page.previous)
    creator  -> User (inverse=User.pages)
    previousVersion :: Int
    previousPage -> Page
    warnedAboutVersion :: Int
    temp :: Bool
    content  :: WikiText
        
    contentlist <> ContentList
    function isLatestVersion():Bool{
      return next == null && !temp;
    }
    
    extend function Page(){
      contentlist := ContentList{};
    }
      
    function clone() : Page{
      var p := Page { 
        title := title 
        content := content
        temp := true
        //contentlist := this.contentlist.clone();  TODO this line doesnt work, added below objectcreation for now
        //warnedAboutVersion := this.version;  //TODO "this" shouldnt be necessary
      };
      p.contentlist := this.contentlist.clone();
      //message("p"+p.contentlist.contents.length);
      p.save();
      return p;
    }
    
    function storeVersionDerivedFrom(p:Page){
      previousPage := p;
      previousVersion := p.version;
      warnedAboutVersion := p.version; 
    }
    
    function isBasedOnDifferentVersion(p:Page): Bool{
      
      return this.previousVersion != p.version;
    }
    /*
    function isSameVersion(p:Page):Bool{
      return !isDifferentVersion(p);
    }
    */
  }
  
