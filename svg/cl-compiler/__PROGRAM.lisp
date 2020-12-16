(__PROGRAM
  :metadata "\"[{\"dir\":\"build_process/\",\"kindName\":\"hello\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/hello.lisp\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"world\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/world.lisp\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"string-join\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/string-join.lisp\",\"ref\":\"master\"}]\""
  
   (START)
   (RESULT)
  
  (:code STRING-JOIN (A B) (C))
  (:code WORLD (START) (S))
  (:code HELLO (START) (S))
  "
    HELLO.S -> STRING-JOIN.B
    WORLD.S -> STRING-JOIN.A
    STRING-JOIN.C -> SELF.RESULT
    SELF.START -> WORLD.START,HELLO.START
    ")