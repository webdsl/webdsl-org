module index/init

  init {
    
    var manual : Index := 
      Index {
        url    := "MainPage"
        title    := "MainPage"
      };

    manual.save();
  }