(HELLOWORLD
  :metadata "\"[{\"dir\":\"build_process/\",\"kindName\":\"hello\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/hello.lisp\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"world\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/world.lisp\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"string-join\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/string-join.lisp\",\"ref\":\"master\"}]\""
  
   (START)
   (RESULT)
  
  (:code WORLD (START) (S))
  (:code HELLO (START) (S))
  (:code STRING-JOIN (B A) (C))
  "
    HELLO.S -> STRING-JOIN.A
    WORLD.S -> STRING-JOIN.B
    STRING-JOIN.C -> SELF.RESULT
    SELF.START -> WORLD.START,HELLO.START
    ")