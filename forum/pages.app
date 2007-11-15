module forum/pages

section pages

  define page forum(f : Forum)
  {
    main()
    define body() {
      section{
        header{output(f.name)}
        output(f.discussions)
        newDiscussion(f)
      }
    }
  }
  
  define newDiscussion(f : Forum)
  {
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
        
  define page discussion(d : Discussion)
  {
    main()
  
    title{text(d.forum.name) " : " text(d.name)}
  
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
        
      var newReply : Reply := Reply { discussion := d };
        
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
          d.replies.add(newReply);
          newReply := Reply { discussion := d };
        }
      }

    }
  }