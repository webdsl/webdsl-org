module message/page
  
  //not integrated with styling matching yet
  define ignore-access-control templateSuccess(messages : List<String>){
    block()[style := "text-align: center;display := block; width: 700px; margin-left: auto ; margin-right: auto ; border: 1px solid #BB8800;"]{
      for(ve: String in messages){
        block()[style := "display := block;margin-left: auto ; margin-right: auto ; width:100%; color: #BB8800;"]{
          output(ve)   
        }    
      }
    }
  }
