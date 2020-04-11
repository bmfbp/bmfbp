(HELLOWORLD3
  :metadata "\"[{\"dir\":\"build_process/\",\"kindName\":\"hello\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/hello.lisp\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"world\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/world.lisp\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"string-join\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/string-join.lisp\",\"ref\":\"master\"}]\""
  
   (START)
   (RESULT)
  
  (:code STRING-JOIN (A B) (C))
  (:code WORLD () (S))
  (:code HELLO () (S))
  "
    HELLO.S -> STRING-JOIN.B
    WORLD.S -> STRING-JOIN.A
    STRING-JOIN.C -> SELF.RESULT
    SELF.START -> SELF.RESULT
    ")