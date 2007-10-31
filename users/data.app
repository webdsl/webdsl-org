module users/data

section definition

  entity User {
    username :: String (name)
    password :: Secret
    authored -> Set<Page> (inverseSlave=Page.authors)
  }
