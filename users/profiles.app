module users/profiles

// workflow for registering a new user

section create new user
  
  //define page register(message : String)
  define page register()
  {
    main()
    title{"Register new user"}
    define body() {
      section {
	header{"Register New User"}
	
	par { "To become a registered user for this site, "
	"fill in the following information."
	"The moderator will decide on registration based on this information."
	"Due to spamming, registration cannot be automatic" }
	
        //par{ output(message) }
	
        var newUser : UserRegistration := UserRegistration { };
        form { 
          editRowsUserRegistration(newUser)
          action("Register", createUser())
          action createUser() {
            var users : List<User> :=
              select u from User as u 
              where (u._username = ~newUser.username) or (u._email = ~newUser.email);
              
            if (users.length > 0) 
              {
                return register();
                //return register("Username or email address already in use");
                // todo: display error message on page (using FaceMessages?)
              } 
            else 
              {  
                newUser.password := newUser.password.digest();
                newUser.persist();
                email(confirmEmail(newUser));
	        return registrationPending(newUser.username);
	      }
          }
	}
      }
    }
  }
  
  define page registrationPending(name : String)
  {
    main()
    define body() {
      output(name) 
      ": Your registration request has been stored and is awaiting moderation"
    }
  }

section email confirmation by new user
  
  define email confirmEmail(reg : UserRegistration)
  {
    to(reg.email)
    from("admin@webdsl.org")
    subject("Email confirmation")
    body {
      "Dear " output(reg.fullname) ",\n"
      "Please confirm the receipt of this message by visiting the following page"
      output(reg)
    }
  }
  
  define page confirmEmail(reg : UserRegistration)
  {
    main()
    define body() {
      var username : String;
      var email    : Email;
      var password : Secret;
      form { 
        table {
          row{ "Username: " input(username) }
          row{ "Email: "    input(email) }
          row{ "Password: " input(password) }
        }
        action("Check", check())
        action check() {
          if (reg.username = username
              && reg.email = email
              && reg.password.check(password))
          {
            reg.confirmed := true;
          }
        }
      }
    }
  }

section moderation of user registration requests by admin

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
      viewRowsUserRegistration(reg)
      form{
        var rejection : Text;
        
        action("Confirm registration", confirm(reg))
        action("Reject registration", reject(reg, rejection))
        
        par{}
        
        "Reason for rejection: " inputText(rejection)
        
        action confirm(reg : UserRegistration) {
          var user : User := reg.makeUser();
          reg.delete();
          user.persist();
          email(confirmRegistration(user));
          //return pendingRegistrations();
        }
        
        action reject(reg : UserRegistration, rejection : Text) {
          email(rejectRegistration(reg, rejection));
          reg.delete();
          //return pendingRegistrations();
        }
      }
    }
  }

section emails
  
  define email confirmRegistration(user : User)
  {
    to(user.email)
    from("admin@webdsl.org")
    subject("Welcome")
    body {
      "Dear " output(user.fullname) ",\n"
      "Your registration has been confirmed."
      "Your profile is " output(user)
    }
  }
  
  define email rejectRegistration(reg : UserRegistration, rejection : Text)
  {
    to(reg.email)
    from("admin@webdsl.org")
    subject("Registration unsuccesful")
    body {
      "Unfortunately your registration has been rejected"
      output(rejection)
    }
  }

section change password

  define page changePassword()
  {
    main()
    define body() {
      form {
        var oldPassword  : Secret;
        var newPassword1 : Secret;
        var newPassword2 : Secret;
      
        table {
          row{ "Old password: "    input(oldPassword) }
          row{ "New password: "    input(newPassword1) }
          row{ "Repeat password: " input(newPassword2) }
        }
        action("Reset password", resetPassword())
        action resetPassword() {
          if (securityContext.principal.password.check(oldPassword)
              && newPassword1 = newPassword2)
          {
            securityContext.principal.password := newPassword1.digest();
            securityContext.principal.save();
            return user(securityContext.principal);
          } else {
            return changePassword();
          }
        }
      }
    }
  }