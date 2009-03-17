module page/init
  init {

    var main := Page {
        url    := "MainPage"
        title    := "MainPage"
        contentlist := ContentList{}
      };
    main.save(); 
    
    //TODO when adding to this collection before main.save, it doesn't work, investigate weird hibernate behaviour
    main.contentlist.contents.add(
      WikiContent{ 
        content := "This is a simple main page. Here's An[[page(OtherPage)]]."
      } as Content);
    
    var other := Page{
        url    := "OtherPage"
        title    := "OtherPage"
        contentlist := ContentList{}
      };
    other.save();
    other.contentlist.contents.add(
      WikiContent{ 
        content := "This is another page, refering to the [[page(MainPage)]]."
      } as Content);
  
    var other1 := Page {
        url   := "OtherPage1"
        title   := "OtherPage1"
        contentlist := ContentList{}
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
        contentlist := ContentList{}
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