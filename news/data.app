module news/data

  entity News{
    content :: WikiText (searchable)
    creator -> User
    time :: DateTime
    title :: String (name, searchable)
  }