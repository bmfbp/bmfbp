(TOKENIZER-TESTER
  :metadata "\"[{\"dir\":\"parts/\",\"kindName\":\"tokenizer\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"cl/tokenizer.lisp\",\"ref\":\"master\"},{\"dir\":\"parts/\",\"kindName\":\"token-dumper\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"cl/token-dumper.lisp\",\"ref\":\"master\"},{\"dir\":\"parts/\",\"kindName\":\"error-crasher\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"cl/error-crasher.lisp\",\"ref\":\"master\"}]\""
  
   (FILENAME)
   ()
  
  (:code TOKENIZER (FILENAME REQUEST) (TOKEN ERROR EOF))
  (:code TOKEN-DUMPER (TOKEN EOF) (ERROR REQUEST))
  (:code ERROR-CRASHER (ERROR) ())
  "
    TOKENIZER.EOF -> TOKEN-DUMPER.EOF
    TOKENIZER.ERROR -> ERROR-CRASHER.ERROR
    TOKEN-DUMPER.REQUEST -> TOKENIZER.REQUEST
    TOKEN-DUMPER.ERROR -> ERROR-CRASHER.ERROR
    TOKENIZER.TOKEN -> TOKEN-DUMPER.TOKEN
    SELF.FILENAME -> TOKENIZER.FILENAME
    ")