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
    function sortedBlogEntriesAll() : List<BlogEntry> {
      var entries : List<BlogEntry> := 
        select distinct e from BlogEntry as e
         order by e._created descending;
      return entries;
    }
  }

section navigation and operations

  define blogMenu() {
    menu { 
      menuheader{ navigate(blogs()){"Blogs"} }
      blogOperationsMenu()
      menuitem{ navigate(newBlog()){"New Blog"} }
      menuspacer{}
      for(b : Blog in config.blogsList) {
        menuitem{ output(b) }
      }
    }
  }
  
  define blogOperationsMenu() { }
  
  define blogOperationsMenuItems(b : Blog) {
    menuitem{ navigate(newBlogEntry(b)){"New Blog Entry"} }
    menuitem{ navigate(editBlog(b)){"Configure This Blog"} }
  }
  
  define blogEntryOperationsMenu(e : BlogEntry) {
    menuitem{ navigate(newBlogEntry(e.blog)){"New Blog Entry"} }
    menuitem{ navigate(editBlogEntry(e)){"Edit This Blog Entry"} }
    menuitem{ navigate(editBlog(e.blog)){"Configure This Blog"} }
  }
  
  define blogSidebar(b : Blog, entries : List<BlogEntry>)
  {
    list{
      listitem{ "Recent Entries" }
      listitem{
        list { for(entry : BlogEntry in entries) {
          listitem{ navigate(blogEntry(entry)){output(entry.title)} " " output(entry.created) }
        } } }
    }
  }
  
section creation
  
  define page newBlog()
  {
    main()
    title{"Create New Blog"}
    define body()
    {
      form{
        section{
          header{"Create New Blog"}
          var blogKey : String;
          var blogTitle : String;
          table{
            row{ "Key:"   input(blogKey) }
            row{ ""       "Key is used in URL, cannot be changed later" }
            row{ "Title:" input(blogTitle) }
            row{ ""       "Title is used as header on pages" }
          }
          action("Create Blog", createBlog())
          action createBlog() {
            if (blogTitle == "") { blogTitle := blogKey; }
            var newBlog : Blog :=
              Blog {
                key     := blogKey
                title   := blogTitle
                // authors := {securityContext.principal} // does not work!?
              };
            newBlog.authors.add(securityContext.principal);
            // does not work either !?
            newBlog.persist();
            return blog(newBlog);
          }
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
        for(entry : BlogEntry in sortedBlogEntriesAll()) {
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
    }
    define blogOperationsMenu() {
      blogOperationsMenuItems(b)
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
      par{ output(entry.intro) }
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
    
    define blogOperationsMenu() {
      blogEntryOperationsMenu(entry)
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
      navigate(blogEntry(entry)){"Read More"}
      navigate(editBlogEntry(entry)){" | Edit"}
      actionLink(" | Delete", delete(entry))
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
