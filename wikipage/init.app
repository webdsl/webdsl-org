module wikipage/init

  init {
    
    var main := WikiPage {
        url    := "MainPage"
        title    := "MainPage"
        content := "This is a simple main page. Here's An[[page(OtherPage)]]."
      };
      
    var other := WikiPage{
        url    := "OtherPage"
        title    := "OtherPage"
        content := "This is anoter page, refering to the [[page(MainPage)]]."
      };
  
    var other1 := WikiPage {
        url   := "OtherPage1"
        title   := "OtherPage1"
        content := "This is anoter page, refering to the [[page(MainPage)]]."
        next := other
      };
  
    var other2 := WikiPage {
        url   := "OtherPage2"
        title   := "OtherPage2"
        content := "This is anoter page, refering to the [[page(MainPage)]]."
        next := other1
      };
      
    other.previous := other1;
    other1.previous := other2;
    
    
    main.save();
    other.save();
    other1.save();
    other2.save();
  }