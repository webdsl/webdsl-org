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
        
        newcontents <> List<Content>
    function isLatestVersion():Bool{
      return next == null && !temp;
    }
  }
  
