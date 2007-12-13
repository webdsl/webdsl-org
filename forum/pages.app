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
        output(f.discussions)
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
        "by " output(d.author) " posted " output(d.posted)

        par{output(d.text)}
      
        for(reply : Reply in d.replies) { showReply(reply) }
      
        addReply(d)
      }
    }
  }

section replies

  define showReply(reply : Reply)
  {
    section{
      header{output(reply.name)}
      "by " output(reply.author) " posted " output(reply.posted)
          
      par{output(reply.text)}
          
      editReplyLinks(reply)
    }
  }
  
  define editReplyLinks(reply : Reply)
  {
    par{
      form{
        navigate("Edit", editReply(reply))
        " | "
        actionLink("Delete", delete(reply))
        action delete(reply : Reply) {
          reply.discussion.replies.remove(reply);
        }
      }
    }
  }
   
  define addReply(d : Discussion)
  {
    section { 
      header{"Reply"}
      form {
        var replySubject : String;
        var replyText : WikiText;
        table {
          row{ "Subject: " input(replySubject) }
          row{ ""          input(replyText) }
        }
        action("Post", post())
        action post() {
          var newReply : Reply := 
            Reply { 
              discussion := d 
              author     := securityContext.principal
              subject    := replySubject
              text       := replyText
            };
          replySubject := "";
          replyText    := "";
          newReply.save();
        }
      }
    }
  }
