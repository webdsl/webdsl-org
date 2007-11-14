module contexts/data

  description {
    organization of navigation contexts
  }

section data model

  entity Context {
    name :: String (id, name)
  }
  
 
//section blog application definition
//
//  extend entity Context {
//    blog -> Blog
//  }
//  
//  extend entity Blog {
//    context -> Context
//  }
// 
//  extend define contextSidebar(c : Context)
//  {
//    if (c.blog != null) { blogSideBar(c.b) } 
//    // what is the context of the current page ???
//    // we need global variables !-(
//  }
//  
//section issue application definition
//
//  define page issue(i : Issue)
//  {
//    define sidebar() { if (i.context != null) { contextSidebar(i.context) } } 
//  }
