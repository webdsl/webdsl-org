module page/page
  
  define page page(p:Page){
    main()
    define localBody(){
    header{ 
      output(p.title)
    } 
    break
    output(p.content)
    break
    navigate(editPage(p)){"edit"}
    break
    if(p.next != null){
      "View next version: "
      output(p.next)
    }
    if(p.previous != null){
      "View previous version: "
      output(p.previous)
    }
    }
  }
  
  //TODO ac rule to prevent editing of older versions
  define page editPage(p:Page){
    main()
    define localBody(){
    header{ 
      output(p.title)
    } 
    output(p.content)    
    
    var temp : Page := Page { title := p.title content := p.content }
    table{
      form {
        label("Content: "){input(temp.content)}
        action("preview",preview())
      }
    }
    action preview(){
      temp.url := temp.id.toString(); //needed because url property is used in url, caused by id annotation
      temp.creator := test_user; //current user
      temp.save();
      return previewPage(p,temp);
    } 
    }
  }
  
  define page previewPage(old:Page,p:Page){
    main()
    define localBody(){
    header{ 
      output(p.title)
    } 
    output(p.content)
    table{
      form{
        label("Content: "){input(p.content)}
        action("refresh",action{p.save();} ) 
        action("finalize",finalize())
        navigate(page(old)){"cancel"} //temp pages still need to be removed somewhere
      }
    }
    action finalize(){
      var temp := Page {
        content := old.content
        creator := old.creator
        previous := old.previous
      };
      
      //old becomes the new, to keep clean url on latest version
      old.content := p.content;
      old.previous := p;
      old.creator := p.creator;
      old.save();
      
      p.previous := temp.previous;
      p.content := temp.content;
      p.creator := temp.creator;
      //p.next := old; not necessary due to inverse relation
      p.save();
      
      return page(old);   
    }
    }
  }
