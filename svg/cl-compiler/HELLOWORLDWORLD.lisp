(HELLOWORLDWORLD
  :metadata "\"[{\"dir\":\"build_process/\",\"kindName\":\"hello\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/hello.lisp\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"world\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/world.lisp\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"string-join\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/string-join.lisp\",\"ref\":\"master\"}]\""
  
   (START)
   (RESULT)
  
  (:code STRING-JOIN2 (A B) (C))
  (:code STRING-JOIN (B A) (C))
  (:code WORLD (START) (S))
  (:code HELLO (START) (S))
  "
    HELLO.S -> STRING-JOIN.A
    WORLD.S -> STRING-JOIN2.B,STRING-JOIN.B
    STRING-JOIN.C -> STRING-JOIN2.A
    SELF.START -> WORLD.START,HELLO.START
    STRING-JOIN2.C -> SELF.RESULT
    ")