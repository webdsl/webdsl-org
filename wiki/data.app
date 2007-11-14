module wiki/data

section definition

  entity Page {
    name    :: String (id,name)
    content :: WikiText
    authors -> Set<User> (inverse=User.authored)
  }

  extend entity User {
    authored -> Set<Page> (inverseSlave=Page.authors)
  }
  
section tag relation

  extend entity Tag {
    pages -> Set<Page>
  }
  
  extend entity Page {
    tags -> Set<Tag>
  }

  