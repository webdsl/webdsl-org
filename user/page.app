module user/page
  
  define page user(u:User){ 
    main()
    define localBody(){
      formgroup("User"){
        label("Name"){output(u.displayname)}
        //label("Email"){output(u.email)}
        label("Homepage"){output(u.homepage)}
      }
      break
      navigate(editUser(u)){"edit"}
    }
  }
  
  define editUserDetails(u:User){
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
  }
  
  define editUserPassword(u:User){
    form{
      formgroup("Change Password"){
        var temp : Secret := "";
        label("Password"){input(u.password)}
        label("Repeat Password"){input(temp){ validate(u.password == temp, "Password does not match") } }
        break
        action("change",changePassword())
        action changePassword(){
          var pass : String := u.password.toString();
          u.password := u.password.digest();
          u.save();
          email(emailNewPassword(u,pass));
          message("password changed");
          return user(u);
        }
      }
    }
  }
  
  define editUserResetPassword(u:User){
    form{
      formgroup("Reset Password"){
        action("Request Password Reset",resetPassword())
        action resetPassword(){
          requestPasswordReset(u);
          message("Password reset requested.");
          return user(u);
        }
      }
    }
  }
  
  define page editUser(u:User){ 
    main()
    define localBody(){
      editUserDetails(u)
      editUserPassword(u)
      editUserResetPassword(u)
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
      group("Users"){
        table{
          for(u:User){
            output(u)
          }
        }
      }
    }
  }