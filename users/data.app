module users/data

section definition

  entity User {
    username :: String (id,name)
    fullname :: String
    email    :: Email (unique)
    homepage :: URL
    password :: Secret
  }

  entity UserRegistration {
    username   :: String (notnull)
    fullname   :: String (notnull)
    email      :: Email  (notnull)
    homepage   :: URL
    password   :: Secret
    motivation :: WikiText
  }
  
  extend entity UserRegistration {
    function makeUser() : User {
      return User {
        username := this.username
        fullname := this.fullname
        email    := this.email
        homepage := this.homepage
        password := this.password
      };
    }
  }