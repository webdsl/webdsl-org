module app/blog

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

section pages

  define blogSidebar(blog : Blog) {
    personSidebar(blog.author)
  }
  
  define blogEntries() {}
    
  define page viewBlog(blog : Blog) {
    main()
    
    var entries : List<BlogEntry> := 
        select distinct e from BlogEntry as e, Blog as b
         where e member of b._entries
         order by e._created descending;
    
    define blogEntries() {
      list{
        for(entry : BlogEntry in entries) {
          listitem { navigate(entry.name, viewBlogEntry(entry)) }
        }
      }
    }
    
    define sidebar(){ blogSidebar(blog) }
    
    define manageMenu() { 
       navigate("Edit", editBlog(blog))
       
       form{actionLink("New Blog", createNewBlogEntry())} 
       action createNewBlogEntry() {
         var entry : BlogEntry := 
           BlogEntry{
             blog := blog
             title := "title here"
           };
         blog.entries.add(entry);
         blog.persist();
         return editBlogEntry(entry);
       }
    }
    
    define body() {
      title{text(blog.title)}
      
      tabs {
      
        tab("Foo") {
        
        }
        
      }
      
      section{ 
        header{ text(blog.title) }
        for(entry : BlogEntry in entries) {
          section{ 
            header{ text(entry.title) }
            output(entry.created)
            
            par{outputText(entry.intro)}
            
            par{ 
              form{
                navigate("Read more", viewBlogEntry(entry))
                " | "
                navigate("Edit", editBlogEntry(entry))
                " | "
                actionLink("Delete", delete(entry))
                action delete(entry : BlogEntry) {
                  blog.entries.remove(entry);
                  blog.save();
                  return viewBlog(blog);
                }
              }
            }
          }
        }
      }
    }
  }

  define page viewBlogEntry(entry : BlogEntry) {
    main()
    define sidebar(){ blogSidebar(entry.blog) }
    define manageMenu() { navigate("Edit", editBlogEntry(entry)) }
    define body() {
      title{text(entry.title)}
      section{
        header{text(entry.title)}
          div("blogDate"){outputDate(entry.created)}
          div("blogIntro"){outputText(entry.intro)}
          div("blogBody"){outputText(entry.body)}
          
        section{ 
          header{"Comments"}
          output(entry.comments)
        }
      }
    }
    define blogEntries() {
      list{
        for(entry : BlogEntry in entry.blog.entries) {
          listitem { navigate(entry.name, viewBlogEntry(entry)) }
        }
      }
    }
  }
