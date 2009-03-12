module index/data
/*
  entity Index {

  }
  
  entity Section : IndexElement {
 
  }
  */
  entity IndexElement {
    url      :: String (id)
    title    :: String (name)
    previous -> IndexElement
    next     -> IndexElement (inverse=IndexElement.previous)
    creator  -> User (inverse=User.pages)
    previousVersion :: Int
    warnedAboutVersion :: Int
    temp :: Bool
    
    function isLatestVersion():Bool{
      return next == null && !temp;
    }
  }
  
  define page indexElement(i:IndexElement){
    "indexelement"
  }