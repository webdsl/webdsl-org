module tags/data

  description {
    A tag is a name-based identifier for an object. Entity types can
    subscribe to tagging by adding a collection of objects of its type
    to the Tag entity.
  }
  
section data model

  entity Tag {
    tagname :: String (id,name)  
  }