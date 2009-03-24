module page/data
  
  entity Page {
    url      :: String  (id, validate(isUniquePage(this),"URL is taken")
                           , validate(url.length() >= 1, "URL is required")
                           , validate(url.isCleanUrl(), "URL is invalid. may contain only letters, digits, and dashes"))
    title    :: String (name, validate(title.length() >= 1, "Title is required"))
    previous <> Page
    next     -> Page (inverse=Page.previous)
    creator  -> User (inverse=User.pages)
    time     :: DateTime
    previousVersion :: Text // hash: entity name + id + version of object based on, text because these can get pretty long
    warnedAboutVersion :: Text 
    previousVersionNumber :: Int // for displaying increasing version numbers
    previousPage -> Page
    
    temp :: Bool
    tempurl      :: String (  validate(tempurl.length() >= 1, "URL is required")  //need a property to specify a new url in the temp object, but cannot change actual url property
                            , validate(tempurl.isCleanUrl(), "URL is invalid. may contain only letters, digits, and dashes"))
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
      log(tempurl);
      p.contentlist := this.contentlist.clone();
      
      p.url := p.id.toString(); //needed because url property is used in url, caused by id annotation
      p.creator := securityContext.principal; //current user
      p.storeVersionDerivedFrom(this);
      
      //message("p"+p.contentlist.contents.length);
      p.save();
      return p;
    }
    
    function storeVersionDerivedFrom(p:Page){
      previousPage := p;
      previousVersionNumber := p.version;
      previousVersion := p.versionHash();
      warnedAboutVersion := previousVersion;
      tempurl := p.url;
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
  
