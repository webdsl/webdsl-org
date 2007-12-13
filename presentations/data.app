module presentations/data

section presentation

  entity Presentation {
    title   :: String (name)
    authors -> List<User>
    first   -> Slide
    last    -> Slide
  }
  
  entity Slide {
    title        :: String (name)
    content      :: WikiText
    previous     -> Slide
    next         -> Slide
    presentation -> Presentation
  }
  
section presentations

  define presentationsMenu()
  {
    menu{
      menuheader{ navigate(presentations()){"Presentations"} }
      menuitem{ navigate(newPresentation()){"New Presentation"} }
      menuspacer{}
      for(p : Presentation) {
        menuitem{ output(p) }
      }
    }
  }

  define page presentations()
  {
    main()
    define body()
    {
      section{
        header{"Presentations"}
        list { for(p : Presentation) {
          listitem{ output(p) }
        } }
      }
    }
  }

  define page newPresentation()
  {
    main()
    define body()
    {
      var firstSlide : Slide := Slide { title := "First Slide" };
      var newPresentation : Presentation := 
        Presentation{ 
          first := firstSlide
          last  := firstSlide
        };
      form{
        table{
          row{ "Title:" input(newPresentation.title) }
          row{ action("Create Presentation", createPresentation()) }
        }
      }
      action createPresentation() {
        firstSlide.next         := firstSlide;
        firstSlide.previous     := firstSlide;
        firstSlide.presentation := newPresentation;
        newPresentation.authors.add(securityContext.principal);
        newPresentation.persist();
        return presentation(newPresentation);
      }
    }
  }

  define page presentation(p : Presentation)
  {
    main()
    define top() { }
    define sidebar() {
      list{
        listitem{ "First: " output(p.first) }
        listitem{ "Last: " output(p.last) }
      }      
    }
    define body()
    {
      section{
        header{output(p.title)}
        output(p.authors)
      }
    }
  }
  
section slides

  define page slide(s : Slide)
  {
    main()
    define top() { }
    define sidebar() {
      list{
        listitem{ "Next: " output(s.next) }
        listitem{ "Previous: " output(s.previous) }
        listitem{ navigate(editSlide(s)){"Edit Slide"} }
        listitem{ insertSlide(s) }
        listitem{ moveSlideUp(s) }
        listitem{ moveSlideDown(s) }
      }
    }
    define body() {
      section{
        header{output(s.title)}
        output(s.content)
      }
    }
  }
  
  define page editSlide(s : Slide)
  {
    main()
    define top() {}
    define sidebar() {} 
    define body() {
      section{
        header{"Edit Slide " output(s.name)}
        form{
          table{
            row{ "Title:" input(s.title) }
            row{ ""       input(s.content) }
          }
          action("Save", save())
          action save() {
            s.presentation.authors.add(securityContext.principal);
            s.save();
            return slide(s);
          }
        }
      }
    }
  }
  
  define insertSlide(s : Slide)
  {
    form{ actionLink("Insert Slide", insertSlide()) }
    action insertSlide() {
      var newSlide : Slide := 
        Slide { 
          title        := "New Slide"
          presentation := s.presentation
          next         := s.next
          previous     := s
        };
      s.next := newSlide;
      newSlide.next.previous := newSlide;
      s.presentation.authors.add(securityContext.principal);
      newSlide.persist();
      return editSlide(newSlide);
    }
  }
  
  define moveSlideUp(s : Slide)
  {
    form{ actionLink("Move Up", moveUp()) }
    action moveUp() {
      var n : Slide := s.next;
      var p : Slide := s.previous;
      
      p.next     := n;
      n.previous := p;
      
      s.next     := n.next;
      s.previous := n;
      
      n.next     := s;
    }
  }
  
  define moveSlideDown(s : Slide)
  {
    form{ actionLink("Move Down", moveDown()) }
    action moveDown() {
      var n : Slide := s.next;
      var p : Slide := s.previous;

      n.previous := p;
      p.next     := n;
      
      s.next     := p;
      s.previous := p.previous;
      
      p.previous := s;      
    }
  }
  
section ac

  access control rules {
  
    rules page slide(*) {
      true
    }
    
    rules page presentation(*) {
      true
    }
    
    rules page presentations() {
      true
    }
    
    rules page newPresentation() {
      securityContext.loggedIn
    }
    
    rules page editPresentation(*) {
      securityContext.loggedIn
    }
  
    rules page editSlide(*) {
      securityContext.loggedIn
    }
    
    rules template insertSlide(*) {
      securityContext.loggedIn
    }
  
    rules template moveSlideDown(*) {
      securityContext.loggedIn
    }
    
    rules template moveSlideUp(*) {
      securityContext.loggedIn
    }
    
  }
  
  
  