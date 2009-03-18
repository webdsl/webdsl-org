module content/indexcontent/data

  entity IndexContent : Content{
    index -> List<Page> //TODO cannot have content prop name here, mapping collision
    
    function clone() : IndexContent{
      var ic := IndexContent{ 
        index := index 
      };
      ic.save();
      return ic;
    }
    
    function versionHash() :String{
      return "IndexContent" + id + version;
    }
  }