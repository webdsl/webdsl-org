module users/data

section definition

  entity User {
    username :: String (id,name)
    password :: Secret
  }
