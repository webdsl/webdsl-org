module user/page
  
  define page user(u:User){ 
    main()
    define localBody(){
      formgroup("User"){
        label("Name"){output(u.displayname)}
        //label("Email"){output(u.email)}
        label("Homepage"){output(u.homepage)}
      }
    }
  }
  
  define page editUser(u:User){ 
    main()
    define localBody(){
      form{
        formgroup("Edit User"){
          label("Name"){input(u.displayname)}
          label("Email"){input(u.email)}
          label("Homepage"){input(u.homepage)}
          break
          action("save",save())
          action save(){
            u.save();
            message("user info updated");
            return user(u);
          }
        }
      }
      form{
        formgroup("Change Password"){
          var temp : Secret := "";
          label("Password"){input(u.password)}
          label("Repeat Password"){input(temp){ validate(u.password == temp, "Password does not match") } }
          break
          action("change",changePassword())
          action changePassword(){
            u.password := u.password.digest();
            u.save();
            message("password changed");
            return user(u);
          }
        }
      }
    }
  }
  
  define page createUser(){ 
    main()
    define localBody(){
      var u := User{};  //TODO vars cannot be in enclosing def, fix 
      var temp : Secret := "";
      form{
        formgroup("Create User"){
          label("Name"){input(u.displayname)}
          label("Email"){input(u.email)}
          label("Password"){input(u.password)}
          label("Repeat Password"){input(temp){ validate(u.password == temp, "Password does not match") } }
          break
          action("save",save())
          action save(){
            u.password := u.password.digest();
            u.save();
            if(!globalSettings.firstUserCreated) {
              globalSettings.firstUserCreated := true;
              globalSettings.save();
            }
            message("user info updated");
            return user(u);
          }
        }
      }
    }
  }
  
  define page listUsers(){ 
    main()
    define localBody(){
      formgroup("Users"){
        for(u:User){
          output(u)
        }
      }
    }
  }