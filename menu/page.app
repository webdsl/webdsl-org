module menu/page
  
  define output(m:Menu){ 
    for(i:MenuItem in m.items){
      "  |  "
      output(i)
    }
  }
  
  define output(mi:MenuItem){
    case(mi.viewtype.name){
      "index"  { navigate(indexpage (mi.page)){output(mi.page.title)} }
      "full"   { navigate(page      (mi.page)){output(mi.page.title)} }
      "single" { navigate(singlepage(mi.page)){output(mi.page.title)} }
    }
  }


//see comments in content/indexcontent/page for improvements, list component could be reused with generics on entities
  define page editMenu(){
      var addCol := select u from Page as u;
      init{
        for(p:Page in addCol){
          if(!p.isLatestVersion()
             || p.hidden
             ){
            addCol.remove(p);
          }
        }
      }
      var toAdd : Page
    main()
    define localBody(){
      action up(m:MenuItem){
        var temp : Int := topmenu.items.indexOf(m);
        if(temp != null){
          topmenu.items.set(temp,topmenu.items.get(temp-1));
          topmenu.items.set(temp-1,m);
          topmenu.save();
        }
      }
      action down(m:MenuItem){
        var temp : Int := topmenu.items.indexOf(m);
        if(temp != null){
          topmenu.items.set(temp,topmenu.items.get(temp+1));
          topmenu.items.set(temp+1,m);
          topmenu.save();
        }
      }
      action remove(m:MenuItem){
        topmenu.items.remove(m);
        topmenu.save();
      }
      action save(m:MenuItem){
        m.save();
      }
  
      table{
        for(m:MenuItem in topmenu.items){
          row{
            output(m)
            form{
              action("up",up(m))
              action("down",down(m))
              action("remove",remove(m))
              input(m.viewtype)
              action("save",save(m))
            }
          }
        }
      }
      form{
        select(toAdd from addCol)
        action("add",add())
      }
      action add(){
        if(toAdd != null){
          topmenu.items.add(MenuItem{page:=toAdd viewtype:=indexview});
          topmenu.save();
        }
      }   
    }
  }