module news/data

section news items

  entity News {
    title   :: String (name)
    content :: WikiText
    date    :: Date
    author  -> User
  }