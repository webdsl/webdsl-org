module content/indexcontent/data

  entity IndexContent : Content{
    index -> List<Page> //TODO cannot have content prop name here, mapping collision
    title :: String
    subsections <> List<IndexContent>
  
    function clone() : IndexContent{
      var ic := IndexContent{ 
        index := index 
        title := title 
      };
      for(c : IndexContent in subsections){
        ic.subsections.add(c.clone());
      }
      ic.save();
      return ic;
    }
    
    function versionHash() :String{
      return "IndexContent" + id + version;
    }
  }