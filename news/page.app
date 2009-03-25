module news/page
  
  define showNews(){
    for(n:News in select u from News as u order by _time descending){
      output(n)
    }
  }
  
  define output(n:News){ 
    group(n.title) [style := "display : block;"] {
      output(n.content)
      break
      output("by " + n.creator.name + " at "  + n.time.format("d MMM yyyy HH:mm"))
      if(loggedIn()){
        break
        navigate(editNews(n)){"edit"} 
        " "
        navigate(deleteNews(n)){"delete"}
      }
    }
  }
  
  define page createNews(){
    main()
    define localBody(){
      var n := News{creator := securityContext.principal};
      header{"News"}
      form{
        formgroup("Create News Item")[labelWidth := "75"]{
          label("Title"){input(n.title)}
          label("Content"){input(n.content)}
          label("Creator"){input(n.creator)}
          label("Time"){input(n.time)}
        }
        action("save",save())
        navigate(home()){"cancel"}
        action save(){
          n.save();
          return home();
        }
      } 
    } 
  }
 
  define page editNews(n: News){
    main()
    define localBody(){
      header{"News"}
      form{
        formgroup("Edit News Item")[labelWidth := "75"]{
          label("Title"){input(n.title)}
          label("Content"){input(n.content)}
          label("Creator"){input(n.creator)}
          label("Time"){input(n.time)}
        }
        action("save",save())
        navigate("cancel",home())
        action save(){
          n.save();
          return home();
        }
      }
    }
  } 
  
  define page deleteNews(n: News){
    main()
    define localBody(){
      output(n)
      break
      "This news item will be deleted "
      form{
        action("confirm",delete())
      }
      navigate(home()){"cancel"}
      action delete(){
        n.delete();
        return home();
      }
    }
  } 
 