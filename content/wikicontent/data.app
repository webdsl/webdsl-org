module content/wikicontent/data

  entity WikiContent : Content{
    content :: WikiText
    
    function clone() : WikiContent{
      var wc := WikiContent{ 
        content := content 
        //previousVersion := this.version
        //isClone := true  
      };
      wc.save();
      //message("wc copied "+content);
      return wc;
    }
    
    function versionHash() :String{
      return "WikiContent" + id + version;
    }
    
    /*
    function isBasedOnDifferentVersion(c:Content): Bool{
      return !(c isa WikiContent) || this.previousVersion != c.version;
    }
    */
  }