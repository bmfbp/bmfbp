(HELLOWORLD-PAULTARVYDAS
  :metadata "\"[{\"dir\":\"parts/\",\"kindName\":\"paul\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"cl/paul.lisp\",\"ref\":\"master\"},{\"dir\":\"parts/\",\"kindName\":\"tarvydas\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"cl/tarvydas.lisp\",\"ref\":\"master\"},{\"dir\":\"parts/\",\"kindName\":\"string-join\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"cl/string-join.lisp\",\"ref\":\"master\"}]\""
  
   (START)
   (RESULT)
  
  (:code STRING-JOIN (B A) (C))
  (:code TARVYDAS (START) (S))
  (:code PAUL (START) (S))
  "
    PAUL.S -> STRING-JOIN.A
    TARVYDAS.S -> STRING-JOIN.B
    STRING-JOIN.C -> SELF.RESULT
    SELF.START -> TARVYDAS.START,PAUL.START
    ")