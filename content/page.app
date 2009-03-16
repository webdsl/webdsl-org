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
  }
  
  //passing page shouldnt be necessary but currently is 
  define editContents(cl: ContentList){ 
    //output("length: "+cl.contents.length)
    for(c:Content in cl.contents){
      editContent(c)
      //form{
        action("remove",action{cl.contents.remove(c);cl.save();})
      //}
    }
    addContent(cl)
  }
  
  define editContent(c: Content){ 
    if(c isa WikiContent){
      editContent(c as WikiContent)  
    }
  }
  
  define addContent(cl: ContentList){
    //form{ 
      action("add WikiContent",addWikiContent())  
    //}
    action addWikiContent(){
      var wc := WikiContent{};
      wc.save();         
      cl.contents.add(wc as Content); //TODO upcast shouldn't be necessary
      cl.save(); //TODO this save shouldn't be necessary 
    }
  }