module page/data

  entity Page {
    url      :: String (id)
    title    :: String (name)
    content  :: WikiText
    previous -> Page
    next     -> Page (inverse=Page.previous)
    creator  -> User (inverse=User.pages)
    previousVersion :: Int
    warnedAboutVersion :: Int
    temp :: Bool
    
    function isLatestVersion():Bool{
      return next == null && !temp;
    }
  }
  