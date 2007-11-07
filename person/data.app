module person/data

  description {
    The Person entity describes 'real' people that are not necessarily
    users of the system. For examples, when listing authors of a publication,
    not all authors have to be users of the system. Still we want to identify
    all authors, such that information about them is stored in one place.    
 }
 
 note {
   Probably needs to evolve to store more interesting information. When changing
   personal information it may be useful to remember the changes (history).
 }
 
 note {
   Most linking information should probably be added as inverse assocations
   that are added by applications involving Persons.
 }
 
section data model

  entity Person {
    key        :: String (id) // unique name to refer to this person
    firstnames :: String
    lastname   :: String
    fullname   :: String (name) := firstnames + " " + lastname
    email      :: Email
    homepage   :: URL
    photo      :: Image
    birthdate  :: Date
  }
  
section relations

  // personal information about a User is stored in Person

  extend entity User {
    person -> Person (inverse=Person.user)
  }

  extend entity Person {
    user -> Person (inverse=User.person)
  }
  
  // note: such a mutually inverse association should really be declared as a relation
  
  // relation User.person <-> Person.user
  
  // relation Person.publications (Set) -> Publication.authors (List)
  
  //extend entity Person {
  //  publications -> Set<Publication>
  //}
  //extend entity Publication {
  //  authors -> List<Person>
  //}