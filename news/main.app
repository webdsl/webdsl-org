module news/main

imports news/data

section default pages
  define page editNewsEntry(n:NewsEntry){derive editPage from n}

section present news

  globals {
    function recentNewsEntries(n : Int) : List<NewsEntry> {
      var entries : List<NewsEntry> := 
         select e from NewsEntry as e
         order by e._date descending;
      return entries;
    }
  }
  
  define page news() 
  {
    main()
    define body() {
      for( e : NewsEntry ) {
        showNewsEntry(e)
      }
    }
  }
  
  define recentNews() {
    for( e : NewsEntry ) { // in recentNewsEntries(15) ) {
      showNewsEntry(e)
    }
  }
  
  define showNewsEntry(n : NewsEntry)
  {
    section{
      header{output(n.date) " - " output(n)}
      output(n.content)
    }
  }
  
  define page newsEntry(n : NewsEntry)
  {
    main()
    define newsMenu() {
      newsMenuItems(n)
    }
    define body() {
      showNewsEntry(n)
      par{"-- " output(n.author)}
    }
  }
  
section add news

  define newsMenu() {
    menuitem{ navigate(postNews()){"Post News Item"} }
  }

  define newsMenuItems(n : NewsEntry) {
    menuitem{ navigate(postNews()){"Post News Item"} }
    menuitem{ navigate(editNewsEntry(n)){"Edit"} }
  }
  
  define page postNews()
  {
    main()
    define body() {
      var newsEntry : NewsEntry := NewsEntry { };
      section{
        header{"New News"}
        form{ 
          table{
            row{"Title: " input(newsEntry.title)}
            row{"Date: "  input(newsEntry.date)}
            row{""        input(newsEntry.content)}
          }
          action("Post", postNews())
          action postNews() {
            newsEntry.author := securityContext.principal;
            newsEntry.persist();
            return news();
          }
        }
      }
    }
  }
  
section access-control

  access control rules {
  
    rules page news() {
      true
    }
   
    rules page newsEntry(*) {
      true
    }
   
    rules page editNewsEntry(*) {
      securityContext.loggedIn
    }
   
    rules template showNewsEntry(*) {
      true
    }
    
    rules page postNews() {
      securityContext.loggedIn
    }
    
    rules template newsMenu() {
      securityContext.loggedIn
    }
    
    rules template newsMenuItems(*) {
      securityContext.loggedIn
    }
  }