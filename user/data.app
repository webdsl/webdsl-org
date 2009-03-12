module user/data

  entity User {
    displayname :: String (name)
    email    :: Email (id)
    password :: Secret
    homepage :: URL
    pages -> Set<IndexElement> //pages being edited by this user
  }