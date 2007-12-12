module blog/data

description {
  A blog is a journal-like sequence of time-stamped entries. The
  main page of a blog shows the n most recent entries. Entries also
  have their own page.
}

imports tags/data
imports users/data

section domain

  entity Blog {
    key        :: String (id)
    title      :: String (name)
    authors    -> Set<User>          // group of authors?
    entries    -> List<BlogEntry>    
    categories -> List<Category>     // share categories between blogs?
  }
  
  entity BlogEntry {
    blog      -> Blog  (inverse=Blog.entries)
    key       :: String (id)
    title     :: String (name)
    author    -> User
    created   :: Date
    updated   :: Date
    category  -> Category // select from categories defined in blog
    intro     :: WikiText
    body      :: WikiText
    comments  <> List<BlogComment>
  }
  
section authorship

  extend entity User {
    blogs -> Set<Blog> (inverse=Blog.authors)
  }
 
  extend entity User {
    blogentries -> Set<BlogEntry>
  }
 
section categories
  
  entity Category {
    name :: String
  }
  
section comments

  entity BlogComment {
    author -> User
    text   :: WikiText
  }

section blog tagging

//  extend entity BlogEntry {
//    tags -> Set<Tag> (inverse=Tag.blogentries)
//  }
  
//  extend entity Tag {
//    blogentries -> Set<BlogEntry> (inverse=BlogEntry.tags)
//  }
