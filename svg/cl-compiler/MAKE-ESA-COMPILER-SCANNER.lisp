(MAKE-ESA-COMPILER-SCANNER
  :metadata "\"[{\"dir\":\"build_process/\",\"kindName\":\"tokenize\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/tokenize.lisp\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"raw-text\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/raw-text.lisp\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"comments\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/comments.lisp\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"spaces\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/spaces.lisp\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"strings\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/strings.lisp\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"symbols\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/symbols.lisp\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"integers\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/integers.lisp\",\"ref\":\"master\"}]\""
  
   (START PULL)
   (ERROR OUT)
  
  (:code INTEGERS (TOKEN) (ERROR PULL OUT))
  (:code SYMBOLS (PULL) (ERROR PULL OUT))
  (:code STRINGS (TOKEN) (ERROR PULL OUT))
  (:code SPACES (TOKEN) (ERROR PULL OUT))
  (:code RAW-TEXT (TOKEN) (ERROR PULL OUT))
  (:code COMMENTS (TOKEN) (ERROR PULL OUT))
  (:code TOKENIZE (START PULL) (ERROR OUT))
  "
    TOKENIZE.OUT -> RAW-TEXT.TOKEN
    TOKENIZE.ERROR -> SELF.ERROR
    COMMENTS.OUT -> SPACES.TOKEN
    COMMENTS.PULL -> TOKENIZE.PULL
    COMMENTS.ERROR -> SELF.ERROR
    RAW-TEXT.OUT -> COMMENTS.TOKEN
    RAW-TEXT.PULL -> TOKENIZE.PULL
    RAW-TEXT.ERROR -> SELF.ERROR
    SPACES.OUT -> STRINGS.TOKEN
    SPACES.PULL -> TOKENIZE.PULL
    SPACES.ERROR -> SELF.ERROR
    STRINGS.OUT -> SYMBOLS.PULL
    STRINGS.PULL -> TOKENIZE.PULL
    STRINGS.ERROR -> SELF.ERROR
    SYMBOLS.OUT -> INTEGERS.TOKEN
    SYMBOLS.PULL -> TOKENIZE.PULL
    SYMBOLS.ERROR -> SELF.ERROR
    INTEGERS.OUT -> SELF.OUT
    INTEGERS.PULL -> TOKENIZE.PULL
    INTEGERS.ERROR -> SELF.ERROR
    SELF.START -> TOKENIZE.START
    SELF.PULL -> TOKENIZE.PULL
    ")