module wiki-users

section pages
  
  define page viewUser(u : User)
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
  
  define page editUser(u : User)
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
            return viewUser(u);
          }
        }
      }
    }
  }
  
  define page register()
  { 
    main()
    title{"Register new user"}
    define body() {
      section {
	header{"Register new user"}
	"As a registered user you can edit pages and add new pages"
        var newUser : User := User { };
        form { 
          table {
            row{ "Username: " input(newUser.username) }
            row{ "Password: " input(newUser.password) }
          }
          actionLink("Register", createUser())
          action createUser() {
            newUser.persist();
            securityContext.principal := newUser;
            securityContext.loggedIn  := true;
	    return home();
	    // here we want to send an email to the user for confirmation
          }
	}
      }
    }
  }