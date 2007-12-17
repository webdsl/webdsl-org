module forum/pages

section navigation

  define forumMenu() 
  {
    menu { 
      menuheader{ navigate(forums()){"Forums"} }
      forumOperationsMenu()
      menuitem{ navigate(newForum()){"New Forum"} }
      menuspacer{}
      for(b : Forum in config.forumsList) {
        menuitem{ output(b) }
      }
    }
  }

  define forumOperationsMenu() { }
  
  define forumOperationsMenuInst(f : Forum)
  {
    menuitem{ navigate(newDiscussion(f)){"New Discussion"} }
    menuitem{ navigate(editForum(f)){"Configure This Forum"} }
  }
  
  define discussionOperationsMenuInst(d : Discussion)
  {
    menuitem{ navigate(editDiscussion(d)){"Edit This Discussion"} }
    menuitem{ navigate(newDiscussion(d.forum)){"New Discussion"} }
    menuitem{ navigate(editForum(d.forum)){"Configure This Forum"} }
  }
  
section forum

  define page newForum()
  {
    main()
    define body() {
      section{
        header{"New Forum"}
        var newKey : String;
        var newTitle : String;
        form {
          table{
            row{"Key:"   input(newKey)}
            row{"Title:" input(newTitle)}
            row{ action("Create Forum", createForum()) ""}
          }
        }
        action createForum() {
          if (newKey = "") { newTitle := newKey; }
          var newForum : Forum := 
            Forum{
              key := newKey
              title := newTitle 
            };
          newForum.persist();
          return forum(newForum);
        }
      }
    }
  }

  define page forum(f : Forum)
  {
    main()
    define forumOperationsMenu() {
      forumOperationsMenuInst(f)
    }
    define body() {
      section{
        header{"Forum " output(f.name)}
        for (d : Discussion in f.discussions) {
          section{
            header{output(d)}
            output(d.text)
            block("discussionByLine") {
              "by " output(d.author) " at " output(d.posted)
              navigate(discussion(d)){" | Read More"}
              navigate(editDiscussion(d)){" | Edit"}
            }
          }
        }
      }
    }
  }
  
section discussions

  define page newDiscussion(f : Forum)
  {
    main()
    title{text(f.name) " : New Discussion"}
    define body() 
    {
      section{
        header{"New Discussion"}
        form{
          var newTopic : String;
          var newText  : WikiText;
          par{ 
            table{
              row{"Topic:" input(newTopic)}
              row{""       input(newText)}
            }
            action("Start new discussion", newDiscussion())
          }
        }
        action newDiscussion() {
          var d : Discussion := 
            Discussion{ 
              forum  := f 
              topic  := newTopic
              text   := newText
              author := securityContext.principal
            };
          f.discussions.add(d);
          d.persist();
          newTopic := "";
          newText  := "";
          return discussion(d);
        }
      }
    }
  }
        
  define page discussion(d : Discussion)
  {
    main()
  
    title{text(d.forum.name) " : " text(d.name)}
    
    define forumOperationsMenu() { 
      discussionOperationsMenuInst(d)
    }
    
    define body() {
      output(d.forum) " Forum"
      
      section{ 
        header{text(d.name)}
        block("discussion") {
          par{output(d.text)}
          block("discussionByLine") {
            "by " output(d.author) " at " output(d.posted)
            navigate(editDiscussion(d)){" | Edit"}
          }
        }
        // note: separators should not be part of link, but this is done
        // to avoid them showing up when links are not there because of
        // access control
      
        for(reply : Reply in d.replies) { showReply(reply) }
      
        addReply(d)
      }
    }
  }

section replies

  define showReply(reply : Reply)
  {
    block("discussionReply") {
      par{output(reply.text)}
      block("replyByLine") {
        form{
          "by " output(reply.author) " at " output(reply.posted)
          navigate(editReply(reply)){" | Edit"}
          actionLink("| Delete", delete(reply))
          action delete(reply : Reply) {
            reply.discussion.replies.remove(reply);
          }
          // note: separators should not be part of link, but this is done
          // to avoid them showing up when links are not there because of
          // access control
        }
      }
    }
  }
   
  define addReply(d : Discussion)
  {
    section { 
      header{"Reply"}
      form {
        var replyText : WikiText;
        input(replyText)
        action("Post", post())
        action post() {
          var newReply : Reply := 
            Reply { 
              discussion := d 
              author     := securityContext.principal
              text       := replyText
            };
          replyText    := "";
          newReply.save();
        }
      }
    }
  }
