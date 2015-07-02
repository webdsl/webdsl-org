module template/bootstrap

  template bootstrap(){
    head{
      <meta charset="utf-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
      <title>"WebDSL"</title>

      <!-- Bootstrap -->
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">

      <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
      <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
      <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
      <![endif]-->
    }
  }

  template bootstrapJavascript(){
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
  }

  template navbar(){
    <nav class="navbar navbar-default">
      <div class="container-fluid">
        navbarheader
        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
          navbarleft
          navbarsearch
        </div><!-- /.navbar-collapse -->
      </div><!-- /.container-fluid -->
    </nav>
  }

  template navbarheader(){
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
        <span class="sr-only">"Toggle navigation"</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      navigate root()[class="navbar-brand"]{  image("/images/logosmall.png")[alt="WebDSL",class="logo-image"] } //"WebDSL" }
    </div>
  }

  template navbarleft(){
    <ul class="nav navbar-nav">
      for(i:MenuItem in topmenu.items){
        <li>output(i)</li>
      }
      <li>navigate(page(page_about)){"About"}</li>
      if(loggedIn()){
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">"Admin"<span class="caret"></span></a>
          <ul class="dropdown-menu">
            <li>navigate(createPage()){"Add Page"}</li>
            <li>navigate(listPages()){"List Pages"}</li>
            navbarsep
            <li>navigate(user(securityContext.principal)){"Your Account"}</li>
            if(loggedIn() && securityContext.principal.isAdmin){
              navbarsep
              if(allowCreateUser()){
                <li>navigate(createUser()){"Add User"}</li>
              }
              <li>navigate(listUsers()){"List Users"}</li>
              navbarsep
              <li>navigate(createNews()){"Add News"}</li>
              navbarsep
              <li>navigate(editMenu()){"Edit Menu"}</li>
              navbarsep
              <li>navigate(manage()){"Cleaning"}</li>
            }
          </ul>
        </li>
      }
      <li>
        if(!loggedIn()){
          navigate(login()){"Login"}
        }
        else{
          navigate(logout1()){"Logout"}
        }
      </li>
    </ul>
  }

  template navbarsep(){ <li role="separator" class="divider"></li> }

  template navbarsearch(){ navbarsearch("") }

  template navbarsearch(query: String){
    var q := query
    form[class="navbar-form navbar-right", role="search"]{
      <div class="form-group">
        input(q)[class="form-control", placeholder="Search"]
      </div>
      submit action{ return search(q); } [class="btn btn-default"] {"Submit"}
    }
  }

  override template container(){ <div class="container" all attributes> elements </div> }

  template gridrow(){ <div class="row" all attributes> elements </div> }

  template gridcolmiddle(){ <div class="col-sm-10 col-sm-offset-1" all attributes> elements </div> }

  template gridcol(i:Int){ <div class="col-sm-"+i all attributes> elements </div> }

  template standardLayout(){
    container{
      gridrow{
        gridcolmiddle{
          elements
        }
      }
    }
  }

  override attributes submit{ class="btn btn-default" }
  override attributes inputInt{ class="inputInt form-control" }
  override attributes inputString{ class="inputString form-control" }
  override attributes inputEmail{ class="inputEmail form-control" }
  override attributes inputSecret{ class="inputSecret form-control" }
  override attributes inputURL{ class="inputURL form-control " }
  override attributes inputText{ class="inputTextarea inputText form-control" }
  override attributes inputWikiText{ class="inputTextarea inputWikiText form-control" }
  override attributes inputFloat{ class="inputFloat form-control" }
  override attributes inputLong{ class="inputLong form-control" }
  override attributes inputDate{ class="inputDate form-control" }
  override attributes inputSelect{ class="select form-control" }
  override attributes inputSelectMultiple{ class="select form-control" }
  override attributes inputFile{ class="inputFile  form-control" }
  override attributes inputMultiFile{ class="inputFile  form-control" }
  override attributes inputSDF{ class="inputSDF form-control" }
