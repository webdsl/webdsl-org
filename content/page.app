module content/page
  
  define output(contents: List<Content>){
    for(c:Content in contents){
      output(c)
    }
  }
  
  define output(c:Content){ 
    if(c isa WikiContent){
      output(c as WikiContent)  
    }
  }
  //passing page shouldnt be necessary but currently is 
  define editContents(contents: List<Content>, p:Page){ 
    for(c:Content in contents){
      editContent(c,p)
      form{action("remove",action{contents.remove(c);p.save();})}
    }
    addContent(contents,p)
  }
  
  define editContent(c: Content, p:Page){ 
    if(c isa WikiContent){
      editContent(c as WikiContent)  
    }
  }
  
  define addContent(contents: List<Content>, p:Page){
    form{ 
      action("add WikiContent",addWikiContent())  
    }
    action addWikiContent(){
      var wc := WikiContent{};
      wc.save();         
      contents.add(wc as Content); //TODO upcast shouldn't be necessary
      p.save(); //TODO this save shouldn't be necessary 
    }
  }