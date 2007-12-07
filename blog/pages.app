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
      newBlogEntryLink(b)
    }
  }
  
  define newBlogEntryLink(b : Blog) {
    listitem{ navigate(newBlogEntry(b)){"New Entry"} }
  }
  
  define blogOperationsMenu(b : Blog) {
  
  }
  
  define blogMenu() {
  
  }
  
  define newBlogLink() {
    navigate(newBlog()){"Start a new blog"}
  }
  
  define page newBlog()
  {
    main()
    title{"Create New Blog"}
    define body()
    {
      form{
        section{"Create New Blog"}      
        var blogKey : String;
        var blogTitle : String;
        table{
          row{ "Key:"   input(blogKey) }
          row{ ""       "Key is used in URL, cannot be changed" }
          row{ "Title:" input(blogTitle) }
          row{ ""       "Title is used as header on pages" }
        }
        action("Create Blog", createBlog())
        action createBlog() {
          var newBlog : Blog :=
            Blog {
              key     := blogKey
              title   := blogTitle
              authors := {securityContext.principal}
            };
          newBlog.persist();
          return blog(newBlog);
        }
      }
    }
  }
  
section blog frontpage


  define page blogs()
  {
    main()
    define body() {
      section { 
        header{"Blogs"}
        for(entry : BlogEntry) {
          blogEntryIntro(entry, entry.blog)
        }
      }
    }
  }
  
  define page blog(b : Blog) 
  {
    main()
    var entries : List<BlogEntry> := sortedBlogEntries(b);
    title{text(b.title)}
    define applicationSidebar() { 
      blogSidebar(b, entries)
      editBlogLink(b)
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
  
  define editBlogLink(b : Blog) {
    navigate("Edit", editBlog(b))
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
  
section new blog entry

  define page newBlogEntry(b : Blog)
  {
    main()
    
    title{output(b.title) " / New Blog Entry" }
    
    define applicationSidebar(){ 
      blogSidebar(b, sortedBlogEntries(b))
    }
    
    define body() {
      var newKey : String;
      
      section{ 
        header{ output(b) }
        form{
          table{row{"Key: " input(newKey)} }
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
