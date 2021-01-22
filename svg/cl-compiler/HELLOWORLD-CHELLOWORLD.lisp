(HELLOWORLD-CHELLOWORLD
  :metadata "\"[{\"dir\":\"\",\"kindName\":\"\",\"repo\":\"bmfbp/bmfbp.git\",\"file\":\"cl/chello.lisp\",\"ref\":\"\"},{\"dir\":\"parts/\",\"kindName\":\"aworld\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"cl/cworld.lisp\",\"ref\":\"master\"},{\"dir\":\"parts/\",\"kindName\":\"astring-join\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"cl/astring-join.lisp\",\"ref\":\"master\"}]\""
  
   (START)
   (RESULT)
  
  (:code ASTRING-JOIN (B A) (C))
  (:code CWORLD (START) (S))
  (:code CHELLO (START) (S))
  "
    CHELLO.S -> ASTRING-JOIN.A
    CWORLD.S -> ASTRING-JOIN.B
    ASTRING-JOIN.C -> SELF.RESULT
    SELF.START -> CWORLD.START,CHELLO.START
    ")