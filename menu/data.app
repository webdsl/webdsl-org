module menu/data

  entity Menu {
    items -> List<MenuItem>
  }

  entity MenuItem {
    page -> Page
    viewtype -> MenuView (not null)
  }
  
  enum MenuView { indexview("index"),fullview("full"),singleview("single") }