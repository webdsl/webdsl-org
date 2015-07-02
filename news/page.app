module news/page

  template showNews(){
    container{
      gridrow{
        gridcolmiddle{
          <div class="news-header">
            <h1 class="news-title">"WebDSL"</h1>
            <p class="lead news-description">"Domain-Specific Language for Web Applications"</p>
          </div>
        }
      }
      gridrow{
        gridcolmiddle{
          for(n: News in select u from News as u order by time descending){
            <div class="news-post">
              output(n)
            </div>
          }
        }
      }
    }
  }

  template output(n: News){
    <h2 class="news-post-title">output(n.title)</h2>
    <p class="news-post-meta">
      output("by " + n.creator.name + " at "  + n.time.format("d MMM yyyy HH:mm"))
    </p>
    <p>
      output(n.content)
    </p>
    if(loggedIn()){
      break
      navigate(editNews(n)){"edit"}
      " "
      navigate(deleteNews(n)){"delete"}
    }
  }

  page createNews(){
    main()
    define localBody(){
      var n := News{creator := securityContext.principal time:=now()}
      action save(){
        n.save();
        return home();
      }
      header{"News"}
      form{
        formgroup("Create News Item")[labelWidth := "75"]{
          label("Title"){input(n.title)}
          label("Content"){input(n.content)}
          label("Creator"){input(n.creator)}
          label("Time"){input(n.time)}
        }
        action("save",save())
        navigate(home()){"cancel"}
      }
    }
  }

  page editNews(n: News){
    main()
    define localBody(){
      action save(){
        n.save();
        return home();
      }
      header{"News"}
      form{
        formgroup("Edit News Item")[labelWidth := "75"]{
          label("Title"){input(n.title)}
          label("Content"){input(n.content)}
          label("Creator"){input(n.creator)}
          label("Time"){input(n.time)}
        }
        action("save",save())
        navigate("cancel",home())
      }
    }
  }

  page deleteNews(n: News){
    main()
    define localBody(){
      output(n)
      break
      "This news item will be deleted "
      form{
        action("confirm",delete())
      }
      navigate(home()){"cancel"}
      action delete(){
        n.delete();
        return home();
      }
    }
  }
