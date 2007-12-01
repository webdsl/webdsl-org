module wiki/data

section definition

  entity Page {
    name     :: String    (id,name)
    title    :: String
    content  :: WikiText
    authors  -> Set<User> 
  }
 
  extend entity User {
    authored -> Set<Page> (inverse=Page.authors)
  }
  
section tagging

  extend entity Tag {
    pages -> Set<Page> (inverse=Page.tags)
  }
  
  extend entity Page {
    tags -> Set<Tag>
  }
  
section versioning

  extend entity Page {
    previous -> PageDiff  // diff with respect to content
    modified :: Date
    version  :: Int
    author   -> User      // contributor of latest change
  }
  
  entity PageDiff {
    page     -> Page
    next     -> PageDiff
    title    :: String
    patch    :: Patch     // patch to create content of this version from next
    created  :: Date
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

  // hmm, this implements a doubly linked list of diffs; you'd expect a List
  // implementation to deal with this correctly; however, sofar Hibernate
  // lists have not preserved ordering; but then one would always need the
  // Page in combination with the version; maybe good anyway to use the
  // page key as partial key of the diff anyway

  extend entity Page {
    function makeChange(newTitle : String, newText : WikiText, newAuthor : User) : Page {
      if (this.version > 0) {
        var diff : PageDiff := 
          PageDiff {
            page     := this
            previous := this.previous 
            created  := this.modified
            title    := this.title
            patch    := newText.makePatch(this.content)
            author   := this.author
            version  := this.version
          };
        if (this.previous != null) {
          this.previous.next := diff;
        }
        this.previous := diff;
      }
      //this.modified := now();
      this.version := this.version + 1;
      this.title   := newTitle;
      this.content := newText;
      this.author  := newAuthor;
      this.authors.add(newAuthor);
      if (this.author != null) {
        this.author.authored.add(this);
      }
      return this;
    }
  }