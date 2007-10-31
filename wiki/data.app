module wiki/data

section definition

  entity Page {
    name    :: String (name)
    authors -> Set<User> (inverse=User.authored)
    content :: Text
  }
