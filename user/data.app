module user/data

  entity User {
    displayname :: String (name)
    email    :: Email (id, validate(isUniqueUser(this),"Email is taken"))
    password :: Secret (validate(password.length() >= 6, "Password needs to be at least 6 characters"))
    homepage :: URL
    pages -> Set<Page> //pages being edited by this user
    isAdmin :: Bool
  }