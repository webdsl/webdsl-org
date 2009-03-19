module user/password
  
  entity PasswordReset{
    user -> User
  }  
  
  function requestPasswordReset(u:User){
    var pr := PasswordReset{ user := u };
    pr.save();
    email(emailPasswordResetConfirm(u,pr));
  }
  
  define email emailPasswordResetConfirm(u:User,pr:PasswordReset){
    to(u.email)
    from("webdslorg@gmail.com")
    subject("Password reset confirmation")
    
    par{ "Dear " output(u.name) ", " }
    par{
     "Your password can be reset by visiting this page: "
     navigate(passwordReset(pr)){"reset password"}
    }
  }
  
  define page passwordReset(pr:PasswordReset){
    init{
      var password : String := randomUUID().toString();
      var secret : Secret := password;
      secret := secret.digest();
      email(emailNewPassword(pr.user,password));
      pr.user.password := secret;
      pr.user.save();
      pr.delete();      
    }
    main()
    define localBody(){
      "Your new password has been emailed to you."
    } 
  }  
  
  define email emailNewPassword(u:User,p: String){
    to(u.email)
    from("webdslorg@gmail.com")
    subject("New password confirmation")
    
    par{ "Dear " output(u.name) ", " }
    par{
     "Your password has been changed to: "
     output(p)
    }
  }
 