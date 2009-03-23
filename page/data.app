module page/data
  
  entity Page {
    url      :: String  (id, validate(isUniquePage(this),"URL is taken"))
    title    :: String (name, validate(title.length() >= 1, "Title is required"))
    previous -> Page
    next     -> Page (inverse=Page.previous)
    creator  -> User (inverse=User.pages)
    time     :: DateTime
    previousVersion :: Text // hash: entity name + id + version of object based on, text because these can get pretty long
    warnedAboutVersion :: Text 
    previousVersionNumber :: Int // for displaying increasing version numbers
    previousPage -> Page
    
    temp :: Bool
        
    contentlist <> ContentList
    
    function isLatestVersion():Bool{
      return next == null && !temp;
    }
    
    function initContentList(){
      var wc := WikiContent{};
      wc.save();
      var ic := IndexContent{};
      ic.save();
      contentlist := ContentList{};
      contentlist.page := this;
      contentlist.save();
      contentlist.contents := [wc as Content, ic];
    }
    
    /*
    extend function Page(){
      var wc := WikiContent{};
      wc.save();
      var ic := IndexContent{};
      ic.save();
      contentlist := ContentList{};
      contentlist.save();
      contentlist.contents := [wc as Content, ic];
    }*/
      
    function clone() : Page{
      var p := Page { 
        title := title 
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
      previousVersionNumber := p.version;
      previousVersion := p.versionHash();
      warnedAboutVersion := previousVersion; 
    }
    
    function versionHash() :String{
      return "Page" + id + version + contentlist.versionHash();
    }
    
    function isBasedOnDifferentVersion(p:Page): Bool{
      return this.previousVersion != p.versionHash(); 
      //this.previousVersion != p.version || previousContentlist.isBasedOnDifferentVersion(p.contentlist);
    }
    /*
    function isSameVersion(p:Page):Bool{
      return !isDifferentVersion(p);
    }
    */
  }
  
