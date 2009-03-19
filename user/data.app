module user/data

  entity User {
    displayname :: String (name)
    email    :: Email (id, validate(isUniqueUser(this),"Email is taken"))
    password :: Secret (validate(password.length() >= 8, "Password needs to be at least 8 characters"))
    homepage :: URL
    pages -> Set<Page> //pages being edited by this user
  }