module menu/data

  entity Menu {
    items -> List<MenuItem>
  }

  entity MenuItem {
    page -> Page
    viewtype -> MenuView
  }
  
  enum MenuView { indexview("index"),fullview("full"),singleview("single") }