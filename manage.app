module manage

  define page manage() 
  {
    main()
    define localBody() {
      action cleanTempPages(){
        for(p:Page where p.temp){
          p.delete();
        }
      }
      action cleanTempPR(){
        for(p: PasswordReset){
          p.delete();
        }
      } 
      form{
        action("Clean temp page entities",cleanTempPages())
      }
      form{
        action("Clean password request entities",cleanTempPR())
      }
    }
  }
