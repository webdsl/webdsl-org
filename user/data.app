module user/data

  entity User {
    displayname :: String (name)
    email    :: Email (id)
    password :: Secret
    homepage :: URL
    pages -> Set<Page> //pages being edited by this user
  }