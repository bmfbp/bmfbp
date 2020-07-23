(JHELLOWORLD
  :metadata "\"[{\"dir\":\"parts/\",\"kindName\":\"jshello\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"js/jshello.js\",\"ref\":\"master\"},{\"dir\":\"parts/\",\"kindName\":\"jsworld\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"js/jsworld.lisp\",\"ref\":\"master\"},{\"dir\":\"parts/\",\"kindName\":\"jsstring-join\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"js/jsstring-join.lisp\",\"ref\":\"master\"}]\""
  
   (START)
   (RESULT)
  
  (:code JSWORLD (START) (S))
  (:code JSHELLO (START) (S))
  (:code JSSTRING-JOIN (B A) (C))
  "
    JSHELLO.S -> JSSTRING-JOIN.A
    JSWORLD.S -> JSSTRING-JOIN.B
    JSSTRING-JOIN.C -> SELF.RESULT
    SELF.START -> JSWORLD.START,JSHELLO.START
    ")