module wiki-data

section definition

  entity User {
    username :: String (name)
    password :: Secret
    authored -> Set<Page> (inverseSlave=Page.authors)
  }

  entity Page {
    name    :: String (name)
    authors -> Set<User> (inverse=User.authored)
    content :: Text
  }
