module wiki-init

section globals

  globals {
    var zef : User := 
      User {
        username   := "ZefHemel"
        password   := "secret"
      };

    var mainPage : Page := 
      Page {
        name    := "MainPage"
	authors := {zef}
	content := "This is a simple main page."
      };
  }
