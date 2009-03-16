module content/wikicontent/data

  entity WikiContent : Content{
    content :: WikiText
    
    function clone() : WikiContent{
      var wc := WikiContent{ 
        content := content 
        previousVersion := this.version  
      };
      wc.save();
      //message("wc copied "+content);
      return wc;
    }
  }