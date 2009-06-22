module message/page
  
  //not integrated with styling matching yet
  define ignore-access-control templateSuccess(messages : List<String>){
    <div style = "text-align: center;display := block; width: 700px; margin-left: auto ; margin-right: auto ; margin-bottom: 5px; border: 1px solid #BB8800;">
      for(ve: String in messages){
        block()[style := "display := block;margin-left: auto ; margin-right: auto ; width:100%; color: #BB8800;"]{
          output(ve)   
        }    
      }
    </div>
  }
  
  define ignore-access-control errorTemplateInput(messages : List<String>){
    <div style = "clear:left; float:left; border: 1px solid #FF0000; margin: 5px 5px 5px -5px; padding: 4px 8px 4px 4px;">
      validatedInput
      for(ve: String in messages){
        block()[style := "width:100%; clear:left; float:left; color: #FF0000; margin-top: 5px;"]{
          formgroupDoubleColumn{output(ve)} //inserted
         }     
      }
    </div>
  }
     