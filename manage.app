module manage

  define page manage() 
  {
    main()
    define localBody() {
    
      form{
        action("Clean temp page entities",cleanTempPages())
        action cleanTempPages(){
          for(p:Page where p.temp){
            p.delete();
          }
        }
      }
      form{
        action("Clean password request entities",cleanTempPR())
        action cleanTempPR(){
          for(p: PasswordReset){
            p.delete();
          }
        }
      }
    }
  }
