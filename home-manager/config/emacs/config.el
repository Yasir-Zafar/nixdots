(setq org-capture-templates
      '(
        ("j" "Uni Log Entry"
         entry (file+datetree "~/org/uni-log.org")
         "* %?"
         :empty-lines 0)
        ))
(setq org-capture-templates
      '(
        ("n" "Note"
         entry (file+headline "~/org/notes.org" "Random Notes")
         "** %?"
         :empty-lines 0)
        ))
(setq org-capture-templates
      '(
        ("g" "General To-Do"
         entry (file+headline "~/org/todos.org" "General Tasks")
         "* TODO [#B] %?\n:Created: %T\n "
         :empty-lines 0)
      ))
(setq org-capture-templates
      '(
        ("c" "Code To-Do"
         entry (file+headline "~/org/todos.org" "Code Related Tasks")
         "* TODO [#B] %?\n:Created: %T\n%i\n%a\nProposed Solution: "
         :empty-lines 0)
        ))
