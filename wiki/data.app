module wiki/data

section definition

  entity Page {
    name     :: String    (id,name)
    content  :: WikiText
    authors  -> Set<User> 
    author   -> User      // contributor of latest change
    previous -> PageDiff  // diff with respect to content
    
    function makeChange(text : WikiText, newAuthor : User) : Page {
      var diff : PageDiff := 
        PageDiff {
          page     := this
          previous := this.previous
          patch    := text.makePatch(this.content)
          author   := this.author
        };
      this.content := text;
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

  extend entity User {
    authored -> Set<Page> (inverse=Page.authors)
  }
  
  entity PageDiff {
    page     -> Page
    next     -> PageDiff
    patch    :: Patch    
    previous -> PageDiff
    date     :: Date
    author   -> User
    
    content  :: WikiText := computeContent()
    
    function computeContent() : WikiText {
      if (next = null) {
        return patch.applyPatch(page.content);
      } else {
        return patch.applyPatch(next.content);
      }
    }
  }
  
section tag relation

  extend entity Tag {
    pages -> Set<Page>
  }
  
  extend entity Page {
    tags -> Set<Tag>
  }