module wiki-users

section pages
  
  define page userFoo(u : User)
  {
    main()
    title{"Profile of " output(u.name)}
    define body() {
      section{
        header{"Profile of " output(u.name)}
        section { header{"Pages"} output(u.authored) }
        par{ navigate(editUser(u)){"Edit profile"} }
      }
    }
  }

section edit profile information
  
  define page editUserFoo(u : User)
  {
    main()
    title{"Edit profile of " output(u.name)}
    define body() {
      section{
        header{"Change your profile"}
        form{
          table{
            row{"Username" input(u.username)}
            row{"Password" input(u.password)}
          }
          actionLink("Save profile", save())
          action save() {
            u.persist();
            return user(u);
          }
        }
      }
    }
  }
  
section create new user
  
  define page register()
  { 
    main()
    title{"Register new user"}
    define body() {
      section {
	header{"Register New User"}
	
	"To become a registered user for  this site, fill in the following information."
	"The moderator will decide on registration based on this information."
	"Due to spamming, registration cannot be automatic"
	
        var newUser : UserRegistration := UserRegistration { };
        form { 
          table {
            row{ "Username: "   input(newUser.username) }
            row{ "Fullname: "   input(newUser.fullname) }
            row{ "Email: "      input(newUser.email) }
            row{ "Homepage: "   input(newUser.homepage) }
            row{ "Password: "   input(newUser.password) }
            row{ "Motivation: " input(newUser.motivation) }
          }
          actionLink("Register", createUser())
          action createUser() {
            // check that username and email are not yet used by an existing User
            newUser.password := newUser.password.digest();
            newUser.persist();
            //securityContext.principal := newUser;
            //securityContext.loggedIn  := true;
	    return home();
	    // here we want to send an email to the user for confirmation
          }
	}
      }
    }
  }
  
  define page pendingRegistrations()
  {
    main()
    title{"Pending User Registrations"}
    define body() {
      section{
        header{"Pending User Registrations"}
        for(reg : UserRegistration) {
          showUserRegistration(reg)
        }
      }  
    }
  }
  
  define showUserRegistration(reg : UserRegistration) 
  {
    section{
      header{output(reg.username)}
      table {
        row{ "Username: "   output(reg.username) }
        row{ "Fullname: "   output(reg.fullname) }
        row{ "Email: "      output(reg.email) }
        row{ "Homepage: "   output(reg.homepage) }
        row{ "Password: "   output(reg.password) }
        row{ "Motivation: " output(reg.motivation) }
      }
      form{
        action("Confirm registration", confirm(reg))
        action confirm(reg : UserRegistration) {
          var user : User := reg.makeUser();
          user.persist();
          return pendingRegistrations();
        }
      }
    }
  }