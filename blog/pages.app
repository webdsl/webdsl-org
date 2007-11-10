module blog/pages

section queries
  
  globals {
  
    function sortedBlogEntries(b : Blog) : List<BlogEntry> {
      var entries : List<BlogEntry> := 
        select distinct e from BlogEntry as e, Blog as b
         where (b = ~b) and (e member of b._entries)
         order by e._created descending;
      return entries;
    }
    
  }
  
section sidebar

  define blogSidebar(b : Blog, entries : List<BlogEntry>)
  {
    list{
      listitem{ "Recent Entries" }
      listitem{
        list { for(entry : BlogEntry in entries) {
          listitem{ output(entry) output(entry.created) }
        } } }
      listitem{navigate(newBlogEntry(b)){"New Blog"}}
    }
  }
  
section blog frontpage

  define page blog(b : Blog) 
  {
    main()
    var entries : List<BlogEntry> := sortedBlogEntries(b);
    title{text(b.title)}
    define applicationSidebar() { 
      blogSidebar(b, entries) 
      navigate("Edit", editBlog(b))
    }
    define body() {
      section{ 
        header{ output(b) }
        for(entry : BlogEntry in entries) {
          blogEntryIntro(entry, b)
        }
      }
    }
  }
  
  define blogEntryIntro(entry : BlogEntry, b : Blog)
  {
    section{ 
      header{output(entry)}
      entryByline(entry)
      par{output(entry.intro)}
      par{ editBlogEntryLinks(entry) }
    }
  }
  
section blog entry page

  define page blogEntry(entry : BlogEntry)
  {
    main()
    
    title{output(entry.blog.title) " / " output(entry.title)}
    
    var entries : List<BlogEntry> := sortedBlogEntries(entry.blog);
    
    define applicationSidebar(){ 
      blogSidebar(entry.blog, entries)
    }
    
    define body() {
      section{
        output(entry.blog)
        header{text(entry.title)}
          entryByline(entry)
          par{ output(entry.intro) }
          par{ output(entry.body) }
          par{ form{ editBlogEntryLinks(entry) } }
        section{ 
          header{"Comments"}
          output(entry.comments)
        }
      }
    }
  }

  define editBlogEntryLinks(entry : BlogEntry) {
    form {
      navigate("Edit", editBlogEntry(entry))
      " | "
      actionLink("Delete", delete(entry))
      action delete(entry : BlogEntry) {
        entry.blog.entries.remove(entry);
        entry.blog.save();
        return blog(entry.blog);
      }
    }
  }
  
  define entryByline(entry : BlogEntry) {
     par{
       "by " output(entry.author) 
       " at " outputDate(entry.created)
    }
  }
  
section new blog

  define page newBlogEntry(b : Blog)
  {
    main()
    
    title{output(b.title) " / New Blog" }
    
    define applicationSidebar(){ 
      blogSidebar(b, sortedBlogEntries(b))
    }
    
    define body() {
      var newKey : String;
      
      section{ 
        header{ output(b) }
        form{
          table{row{"Key: " input(newKey)}}
          action("Create it", createBlog())
        }
      }
      
      action createBlog() {
        var entry : BlogEntry := 
          BlogEntry {
            key    := newKey
            title  := newKey
            blog   := b
            author := securityContext.principal
          };
        b.entries.add(entry);
        b.persist();
        return editBlogEntry(entry);
      }
    }
  }
