module page/init

  var page_manual := 
  Page {
    url    := "Manual"
    title    := "Manual"
    tempurl := "none"
  };
  
  var page_about := 
  Page {
    url    := "About"
    title    := "About"
    tempurl := "none"
  };
  
  var page_publications := 
  Page {
    url    := "Publications"
    title    := "Publications"
    tempurl := "none"
  };
  
  //TODO figure out what is wrong with object creations with collections and hibernate, references seem to break
  
  init{
    page_manual.initContentList();
    page_manual.save();
    page_about.initContentList();
    page_about.save();
    page_publications.initContentList();
    page_publications.save();
  }
  

  
  
/*
  init {

    var main := Page {
        url    := "MainPage"
        title    := "MainPage"
      };
    main.save(); 
    
    //TODO when adding to this collection before main.save, it doesn't work, investigate weird hibernate behaviour
    main.contentlist.contents.add(
      WikiContent{ 
        content := "This is a simple main page. Here's An[[page(OtherPage)]]."
      });
    
    var other := Page{
        url    := "OtherPage"
        title    := "OtherPage"
      };
    other.save();
    other.contentlist.contents.add(
      WikiContent{ 
        content := "This is another page, refering to the [[page(MainPage)]]."
      } as Content);
  
    var other1 := Page {
        url   := "OtherPage1"
        title   := "OtherPage1"
        next := other
      };
    other1.save();
    other1.contentlist.contents.add(
      WikiContent{ 
        content := "(1) This is another page, refering to the [[page(MainPage)]]."
      } as Content);
 
    var other2 := Page {
        url   := "OtherPage2"
        title   := "OtherPage2"
        next := other1
      };
    other2.save();
    other2.contentlist.contents.add(
      WikiContent{ 
        content := "(2) This is another page, refering to the [[page(MainPage)]]."
      } as Content); 
            
    other.previous := other1;
    other1.previous := other2;

  }
*/  
