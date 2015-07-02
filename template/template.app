module template/template

  imports template/bootstrap

  template main(){
    bootstrap
    navbar
    body
    bootstrapJavascript
    //google analytics
    <script type="text/javascript">
      var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
      document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
    </script>
    <script type="text/javascript">
      try {
      var pageTracker = _gat._getTracker("UA-10588367-1");
      pageTracker._trackPageview();
      } catch(err) {}
    </script>
  }

  template body(){
    messages() // built-in
    localBody()
  }

  template sidebarPlaceholder(){}

  template sidebar(){
    <div class="sidebarcontent">
      elements
    </div>
  }

  template localBody(){
    "default localBody"
  }

  template footer(){
    <div class="footerinner">
      <div class="leftFooter">
        leftFooter()
      </div>
      <div class="rightFooter">
        rightFooter()
      </div>
    </div>
  }

  template leftFooter(){
    //navigate(home()) { "About WebDSL" }
  }

  template rightFooter(){
    "powered by "
    navigate(url("http://www.webdsl.org")){"WebDSL"}
    //" and "
    //navigate(url("http://www.strategoxt.org")){"Stratego/XT"}
  }
