module news/page
  
  define showNews(){
    for(n:News){
      output(n)
    }
  }
  
  define output(n:News){ 
    formgroup("by " + n.creator.name + " at "  +n.time ) [style := "display : block;"] {
      output(n.content)
      if(loggedIn()){
        break
        navigate(editNews(n)){"edit"}
      }
    }
  }
  
  define page createNews(){
    main()
    define localBody(){
      var n := News{creator := securityContext.principal};
      header{"Create News Item"}
      table{
        form{
          label("Content"){input(n.content)}
          label("Creator"){input(n.creator)}
          label("Time"){input(n.time)}
          action("save",save())
          action save(){
            n.save();
            return home();
          }
        }
      } 
    } 
  }
 
  define page editNews(n: News){
    main()
    define localBody(){
      header{"Edit News Item"}
      table{
        form{
          label("Content"){input(n.content)}
          label("Creator"){input(n.creator)}
          label("Time"){input(n.time)}
          action("save",save())
          action save(){
            n.save();
            return home();
          }
        }
      } 
    }
  } 
 
 