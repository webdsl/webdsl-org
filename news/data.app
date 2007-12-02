module news/data

section news items

  entity NewsEntry {
    title   :: String (name)
    content :: WikiText
    date    :: Date
    author  -> User
  }
  
