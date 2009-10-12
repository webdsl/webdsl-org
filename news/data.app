module news/data

  entity News{
    content :: WikiText
    creator -> User
    time :: DateTime
    title :: String (name)
  }