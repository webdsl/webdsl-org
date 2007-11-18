module wiki-init

section globals

  globals {
    var zef : User := 
      User {
        username   := "ZefHemel"
        password   := "secret"
      };

    var eelco : User := 
      User {
        username   := "EelcoVisser"
        password   := "foo"
      };

    var mainPage : Page := 
      Page {
        name    := "MainPage"
        author  := zef
	authors := {zef}
	content := "This is a simple main page. Here's An[[page(OtherPage)]]."
      };
      
    var otherPage : Page := 
      Page {
        name    := "OtherPage"
        author  := zef
	authors := {zef}
    	content := "This is anoter page, refering to the [[page(MainPage)]]."
      };
  }
