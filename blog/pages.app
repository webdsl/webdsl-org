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
    output(b)
    output(entries)
    newBlogEntry(b)
  }
  
  define newBlogEntry(b : Blog)
  {
    var entry : BlogEntry := BlogEntry{ blog := b };
    form{
      actionLink("Blog this", createNewBlogEntry())
      input(entry.title)
    }
    action createNewBlogEntry() {
      entry.author := securityContext.principal;
      b.entries.add(entry);
      b.persist();
      return editBlogEntry(entry);
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
        header{ text(b.title) }
        for(entry : BlogEntry in entries) {
          blogEntryIntro(entry, b)
        }
      }
    }
  }
  
  define blogEntryIntro(entry : BlogEntry, b : Blog)
  {
    section{ 
      header{output(entry.title)}
      output(entry.created)
            
      par{outputText(entry.intro)}
            
      par{ 
        form{
          navigate("Read more", blogEntry(entry))
          " | "
          navigate("Edit", editBlogEntry(entry))
          " | "
          actionLink("Delete", delete(entry))
          action delete(entry : BlogEntry) {
            b.entries.remove(entry);
            b.save();
            return blog(b);
          }
        }
      }
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
      navigate("Edit", editBlogEntry(entry))
    }
    
    define body() {
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
    
  }
