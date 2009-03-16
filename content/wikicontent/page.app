module content/wikicontent/page
  
  define output(c: WikiContent){ 
    output(c.content)
  }
  
  define editContent(c: WikiContent){ 
    //form{
      input(c.content)
    //  action("save",action{c.save();})
    //}
  }