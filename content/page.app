module content/page
  
  define output(cl: ContentList){
    for(c:Content in cl.contents){
      output(c)
    }
  }
  
  define output(c:Content){ 
    if(c isa WikiContent){
      output(c as WikiContent)  
    }
    if(c isa IndexContent){
      output(c as IndexContent)  
    }
  }
  
  define editContents(cl: ContentList){ 
    for(c:Content in cl.contents){
      editContent(c)
      //action("remove",action{cl.contents.remove(c);cl.save();})
      break
    }
    //addContent(cl)
  }
  
  define editContent(c: Content){ 
    if(c isa WikiContent){
      editContent(c as WikiContent)  
    }
    if(c isa IndexContent){
      editContent(c as IndexContent)  
    }
  }
  
  define addContent(cl: ContentList){
    action("add WikiContent",addWikiContent())  
    action addWikiContent(){
      var wc := WikiContent{};
      wc.save();         
      cl.contents.add(wc as Content); //TODO upcast shouldn't be necessary
      cl.save(); //TODO this save shouldn't be necessary 
    }
    action("add IndexContent",addIndexContent())  
    action addIndexContent(){
      var ic := IndexContent{};
      ic.save();         
      cl.contents.add(ic as Content); //TODO upcast shouldn't be necessary
      cl.save(); //TODO this save shouldn't be necessary 
    }
  }