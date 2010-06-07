module page/page
  
  define showPage(p:Page){
    header{ 
      output(p.title)
    }
    pageDetails(p, true)
    
    output(p.contentlist.contents[0])
    outputIndexContentLinksInContext(p,true)
    
    break
  }
  
  define page editPage(p:Page){
    /**
     *  need to create a temp object right away in order to keep track of the latest version number
     *  that way changes to the object while editing can be observed
     */     
    init{
      var temp : Page; // TODO fix bug: this is seen as page var, vardeclinit init was happening twice
      
      temp := p.clone();
      
      temp.save();
      
      return previewPage(temp);
    }
  }
  
  function previewPageWarning(p: Page): Bool{
    var old : Page := p.previousPage;
    var oldPageCurrentHash :String := old.versionHash();
    if(p.warnedAboutVersion != oldPageCurrentHash){   // < operator on strings should not be allowed
      p.warnedAboutVersion := oldPageCurrentHash;
      message("Warning: original page has been modified");
      return true;
    }
    return false;
  }
  
  function finalizePageEdit(p: Page): Bool{
    var old : Page := p.previousPage;
    if(previewPageWarning(p)){
      p.save();
      return false;
    }
    else{
      var creator := old.creator;
      var previous := old.previous;
      var contentlist := old.contentlist;
      var title := old.title;  
      var time := old.time;
      var hidden := old.hidden;
        
      //old becomes the new, to keep clean url on latest version
      old.previous := p;
      old.creator := p.creator;
      old.contentlist := p.contentlist;
      old.title := p.title;
      old.time := p.time; 
      old.url := p.tempurl;
      old.hidden := p.hidden;
      old.save();
      
      p.hidden := hidden;
      p.time := time;
      p.title := title;   
      p.contentlist := contentlist;
      p.previous := previous;
      p.creator := creator;
      p.previousVersionNumber := old.version;
      p.temp := false;
      //p.next := old; not necessary due to inverse relation
      p.save();
      return true;
    }    
  }
  
  define page previewPage(p: Page){
    var old : Page := p.previousPage
    main()
    define localBody(){
      var oldcontent := (old.contentlist.contents.get(0) as WikiContent).content;
      var previewcontent := (p.contentlist.contents.get(0) as WikiContent).content;
                
      form{
        formgroup("Edit")[labelWidth := "75"]{
          label("Identifier"){input(p.tempurl){validate(isUniquePageId(p.tempurl,p.previousPage),"Identifier is taken")}}
          label("Title"){input(p.title)}
          label("Content"){editContents(p.contentlist)}
          label("Hidden"){input(p.hidden)}
          formgroupDoubleColumn{"Hidden pages will still be accessible, but not shown in the index selections."}
        }
        action("Preview",refresh() ) 
        action("Finalize",finalize())
        navigate(page(old)){"cancel"} //temp page entities still need to be removed somewhere
      }
      break
      navigate(url("http://daringfireball.net/projects/markdown/syntax")){"Markdown syntax"} " is supported."
      break
      "Links to other pages in the wiki can be created using [[page(identifier)|caption]], e.g. [[page(Types)|Types page]]."

      <h2>"Preview"</h2>
        header{ 
          output(p.title)
        } 
      output(p.contentlist)
   
      
      //TODO replace with toggle visibility abstraction
      <script>
        function toggle_visibility(id) {
           var e = document.getElementById(id);
           if(e.style.display == 'block')
              e.style.display = 'none';
           else
              e.style.display = 'block';
        }
      </script>
      break
      <a onclick="toggle_visibility('hidden-diff-page')">"show differences"</a>
     
      <div id="hidden-diff-page" style="display:none;">
        <div class="differences">
          <h2>"Differences"</h2>
          output((old.contentlist.contents.get(0) as WikiContent).content.diff((p.contentlist.contents.get(0) as WikiContent).content))  
        </div>
   
        //need to tweak custom layout here, provide clear css class hooks
        <div class="original-page">
          <h2>"Original page"</h2>
          header{ 
            output(old.title)
          } 
          output(old.contentlist)  
          input(oldcontent) //abuse of input here, since there is no form around it, it wont be submitted
        </div>
        <div class="preview-page">
          <h2>"Preview"</h2>
          header{ 
            output(p.title)
          } 
          output(p.contentlist)
          input(previewcontent)
        </div>
      </div>
     
      action refresh(){
        previewPageWarning(p);
        p.save();
      }
      action finalize(){
        if(finalizePageEdit(p)){           
          return singlepage(old);
        }
      }
      //hide footer using a local template override
      define rightFooter(){}
    }
  }

  define page createPage(){ 
    main()
    define localBody(){
      var p := Page{}; 
      action save(){
        p.initContentList();
        p.creator := securityContext.principal;
        p.tempurl := p.url;
        p.save();
        message("New page created.");
        return singlepage(p);
      }
      form{
        formgroup("Create Page"){
          label("Identifier"){input(p.url)}
          formgroupDoubleColumn{"The identifier will be used in the URL for this page."}
          label("Title"){input(p.title)}
          break
          action("save",save())
        }
      }
    }
  }


  function produceListOfPages(lim:Int,off:Int):List<Page>{
    var tmp := List<Page>();
    for(p:Page where p.isLatestVersion() && !p.hidden order by p.title){
      tmp.add(p);
    }
    return tmp;
  }
  define listPagesTemplate(lim:Int,off:Int){
    var pages := produceListOfPages(lim,off)
    main()
    define localBody(){
      group("Pages"){
        table{
          for(p:Page in pages limit lim offset off){
            output(p)
          }
          break
          if(off > 0){navigate(listSpecificPages(lim,off-25)){"show previous 25 pages"}}
          if(pages.length > off + lim){navigate(listSpecificPages(lim,off+25)){"show next 25 pages"}}
          navigate(listAllPages()){"show all pages"}
        }
      }
    }
  }
  define page listPages(){ 
    listPagesTemplate(25,0)
  }
  define page listSpecificPages(lim:Int,off:Int){ 
    listPagesTemplate(lim,off)
  }
  
  define page listAllPages(){ 
    main()
    define localBody(){
      group("Pages"){
        table{
          for(p:Page where p.isLatestVersion() && !p.hidden order by p.title ){
            output(p)
          }
          break
          navigate(listPages()){"show per 25"}
        }
      }
      if(loggedIn()){
        group("Hidden Pages"){
          table{
            for(p:Page where p.isLatestVersion() && p.hidden order by p.title ){
              output(p)
            }
          }
        }
      }
    }
  }
  
  /*
  define page deletePage(p:Page){
    main()
    define localBody(){
      showPage(p)
      break
      "This page and all its older revisions will be deleted: "
      form{
        validate(checkDeleteEdit(p),"This page is being edited and cannot be deleted.")
        validate(checkDeleteRef(p),"This page is referenced by another page and cannot be deleted.")
        break
        action("confirm",delete())
      }
      navigate("cancel",singlepage(p))
      action delete(){
        p.delete();
        return listPages();
      }
    }
  }
  
  function checkDeleteEdit(p:Page):Bool{
    return (select u from Page as u where ((u._previousPage = ~p)
                                             and (u._temp = 1))).length == 0;
  }
  function checkDeleteRef(p:Page):Bool{
    var tmp : List<IndexContent> := select u from IndexContent as u; 
    for(ic:IndexContent in tmp){
      if(!(p in ic.index)){
        tmp.remove(ic);
      }
    }
    return tmp.length == 0;     
  }
  */