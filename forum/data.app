module forum/data

description {
  A forum is a collection of discussion threads.
}

section domain

  entity Forum { 
    key         :: String (id)
    title       :: String (name)
    discussions -> List<Discussion>
  }
  
  entity Discussion {
    topic    :: String (name)
    author   -> User
    posted   :: Date
    updated  :: Date
    forum    -> Forum (inverse=Forum.discussions)
    text     :: WikiText
    replies  <> List<Reply> 
  }
  
  // cache date of last reply in dicussion; in order to dynamically re-order discussions
  
  entity Reply {
    subject    :: String (name)
    author     -> User
    posted     :: Date
    discussion -> Discussion (inverse=Discussion.replies)
    text       :: WikiText
  }
  
note {
  @acl Access control requirements: 
  - the author of a reply is Person associated to the logged in User
    this may only be changed by an admin
  - a reply may only be edited by its author
  - a reply may be deleted by its author or by the author of the discussion
}

note {
  Some forums have a notion of nested threads, i.e., replies can be replies
  to an earlier reply.
}
  


  
  

