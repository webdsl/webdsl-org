module wiki/data

section definition

  entity Page {
    name    :: String (id,name)
    authors -> Set<User> (inverse=User.authored)
    content :: Text
  }
