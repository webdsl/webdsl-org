module login

  define page login() 
  {
    main()
    define localBody() {
      var e:Email;
      var p:Secret;
      form{
        formgroup("Login"){
          validate(checkLogin(e,p),"Login failed")
          
          label("Email"){input(e)}
          label("Password"){input(p)}
          
          action("login",login())
        }
      }
      action login(){
        securityContext.principal := getUsersWithEmailAddress(e).get(0); 
        message("Successfully logged in.");
        return home();
      }
    }
  }
  
  function checkLogin(e:Email,p:Secret):Bool{
    var users : List<User> := getUsersWithEmailAddress(e);
    return users.length == 1 && users.get(0).password.check(p);
  }
  
  function getUsersWithEmailAddress(e:Email): List<User>{
     return select u from User as u where (u._email = ~e);
  }

  define page logout() 
  {
    init{
      securityContext.principal := null;
      return home();
    } 
  }
  
