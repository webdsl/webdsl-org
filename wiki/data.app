module wiki/data

section definition

  entity Page {
    name     :: String    (id,name)
    content  :: WikiText
    authors  -> Set<User> 
  }
 
  extend entity User {
    authored -> Set<Page> (inverse=Page.authors)
  }
  
section tagging

  extend entity Tag {
    pages -> Set<Page>
  }
  
  extend entity Page {
    tags -> Set<Tag>
  }
  
section versioning

  extend entity Page {
    previous -> PageDiff  // diff with respect to content
    version  :: Int
    author   -> User      // contributor of latest change
  }
  
  entity PageDiff {
    page     -> Page
    next     -> PageDiff
    patch    :: Patch     // patch to create content of this version from next
    previous -> PageDiff  
    date     :: Date
    author   -> User
    version  :: Int
  }

section content of a page diff

  extend entity PageDiff {
    content  :: WikiText := computeContent()
    
    function computeContent() : WikiText {
      if (next = null) {
        return patch.applyPatch(page.content);
      } else {
        return patch.applyPatch(next.content);
      }
    }
  }
  
section creating new pages

  globals {
  
    function newPage(n : String) : Page {
      return Page {
        name    := n
        author  := securityContext.principal
        version := 0
      };
    }
    
  }
  
section making change to a page

  extend entity Page {
    function makeChange(text : WikiText, newAuthor : User) : Page {
      var diff : PageDiff := 
        PageDiff {
          page     := this
          previous := this.previous
          patch    := text.makePatch(this.content)
          author   := this.author
          version  := this.version
        };
      this.content := text;
      this.version := this.version + 1;
      this.previous := diff;
      if (diff.previous != null) {
        diff.previous.next := diff;
      }
      this.author := newAuthor;
      this.authors.add(newAuthor);
      if (this.author != null) {
        this.author.authored.add(this);
      }
      return this;
    }
  }