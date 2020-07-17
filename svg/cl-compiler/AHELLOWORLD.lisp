(AHELLOWORLD
  :metadata "\"[{\"dir\":\"parts/\",\"kindName\":\"ahello\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"cl/ahello.lisp\",\"ref\":\"master\"},{\"dir\":\"parts/\",\"kindName\":\"aworld\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"cl/aworld.lisp\",\"ref\":\"master\"},{\"dir\":\"parts/\",\"kindName\":\"astring-join\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"cl/astring-join.lisp\",\"ref\":\"master\"}]\""
  
   (START)
   (RESULT)
  
  (:code AWORLD (START) (S))
  (:code AHELLO (START) (S))
  (:code ASTRING-JOIN (B A) (C))
  "
    AHELLO.S -> ASTRING-JOIN.A
    AWORLD.S -> ASTRING-JOIN.B
    ASTRING-JOIN.C -> SELF.RESULT
    SELF.START -> AWORLD.START,AHELLO.START
    ")