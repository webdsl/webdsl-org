module news/data

  entity News{
    content :: Text
    creator -> User
    time :: DateTime
  }