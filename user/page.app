module user/page
  
  define page user(u:User){ 
    main()
    define localBody(){
      header{"User:" output(u.displayname)}
      table{
        label("Name"){output(u.displayname)}
        label("Email"){output(u.email)}
        label("Homepage"){output(u.homepage)}
      }
    }
  }
  
  define page editUser(u:User){ 
    main()
    define localBody(){
      header{"User: " output(u.displayname)}
      form{
        table{
          label("Name"){input(u.displayname)}
          label("Email"){input(u.email)}
          label("Homepage"){input(u.homepage)}
          action("save",save())
          action save(){
            u.save();
            message("user info updated");
            return user(u);
          }
        }
      }
      form{
        table{
          var temp : Secret := "";
          label("Password"){input(u.password)}
          label("Repeat Password"){input(temp)}
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