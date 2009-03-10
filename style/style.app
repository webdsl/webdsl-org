module style/style

style webdslorg

  const bodyWidth        : Length := 700px;
  //const localBodyWidth   : Length := 600px;
  //const sidebarWidth     : Length := 100px;
  const verticalMargin   : Length := 20px;
  const footnoteFontSize : Length := 10pt;

  
  main() {
    display  := Display.block;
    width    := bodyWidth;
    align    := Align.center;
    border-width   := 0px;
    background-color := Color.white;
  }

  top() {
    display        := Display.block;
    width          := bodyWidth;
    align          := Align.left;
    margin-bottom := verticalMargin;
    border-bottom-style := BorderStyle.dotted;
    border-bottom-width := 1px;
    border-bottom-color := Color.black;
  }
  
  topRight() {
    display   := Display.block;
    align     := Align.right;
    font-size := footnoteFontSize;
  }
  
  body() {    
    width   := bodyWidth;
    display := Display.block;
    align   := Align.left;
    border-bottom-style := BorderStyle.dotted;
    border-bottom-width := 1px;
    border-bottom-color := Color.black;
  }
  
  localBody() {
    margin-bottom := verticalMargin;    
    width   := bodyWidth;
    display := Display.block;
    align   := Align.right;
  }
  
  const topMenuBgColor   : Color := #dddddd;
  
  sitemenu() { 
    width := bodyWidth;
    margin-bottom := verticalMargin;   
    padding-bottom := verticalMargin;
    display        := Display.block;
    align          := Align.center;
    border-bottom-style := BorderStyle.dotted;
    border-bottom-width := 1px;
    border-bottom-color := Color.black;
  }
/*
  localMenu() { 
    width := bodyWidth;
    align          := Align.left;
    //background-color := topMenuBgColor;
    //padding := 5px;
    display        := Display.block;
    border-bottom-style := BorderStyle.dotted;
    border-bottom-width := 1px;
    border-bottom-color := Color.black;
  }
*/
  /*
  sidebar() { 
    //margin-top := verticalMargin;
    margin-bottom := verticalMargin;   
    display        := Display.block;
    align          := Align.left;
    vertical-align := VerticalAlign.top;
  }
  */
  footer() {
    width            := bodyWidth;
    display          := Display.block;
    font-size        := footnoteFontSize;
    align            := Align.center;
  }

  leftFooter() {
    margin-top := verticalMargin;
    display        := Display.block;
    font-size      := footnoteFontSize;
    align          := Align.left;
  }

  rightFooter() {
    margin-top := verticalMargin;
    display        := Display.block;
    font-size      := footnoteFontSize;
    align          := Align.right;
  }
    
    
    /*
  templateSuccess(messages : List<String>){
    width            := bodyWidth;
    display          := Display.block;
    align            := Align.center;
  }
*/