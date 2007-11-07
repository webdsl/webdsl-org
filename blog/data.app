module blog/data

description {
  A blog is a journal-like sequence of time-stamped entries. The
  main page of a blog shows the n most recent entries. Entries also
  have their own page.
}

section domain

  entity Blog {
    title      :: String (name)
    author     -> Person
    entries    <> List<BlogEntry>
    categories -> List<Category> // share categories between blogs?
  }
  
  entity BlogEntry {
    blog     -> Blog
    title    :: String (name)
    created  :: Date
    category -> Category // select from categories defined in blog
    intro    :: Text
    body     :: Text
    comments <> List<BlogComment>
  }
  
  entity Category {
    name :: String
  }
  
  entity BlogComment {
    author -> Person
    text :: Text
  }

section blog tagging

  extend entity BlogEntry {
    tags -> Set<Tag> {inverse=Tag.blogentries}
  }
  
  extend entity Tag {
    blogentries -> Set<BlogEntry> {inverse=Blog.tags}
  }
