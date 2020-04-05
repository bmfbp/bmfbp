(MAKE-ESA-COMPILER-ESA-COMPILER
  :metadata "\"[{\"dir\":\"build_process/\",\"kindName\":\"scanner\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/scanner.lisp\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"esa-paresr\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/esa-parser.lisp\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"file-writer\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/file-writer.lisp\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"error-handler\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/error-handler.lisp\",\"ref\":\"master\"}]\""
  
   (OUTPUT-FILENAME START)
   ()
  
  (:code FILE-WRITER (WRITE FILENAME) (ERROR))
  (:code ESA-PARSER (TOKEN) (ERROR OUT PULL))
  (:code ERROR-HANDLER (ERROR) ())
  (:code SCANNER (PULL START) (OUT ERROR))
  "
    SCANNER.ERROR -> ERROR-HANDLER.ERROR
    SCANNER.OUT -> ESA-PARSER.TOKEN
    SELF.OUTPUT-FILENAME -> FILE-WRITER.FILENAME
    SELF.START -> SCANNER.START
    ESA-PARSER.PULL -> SCANNER.PULL
    ESA-PARSER.OUT -> FILE-WRITER.WRITE
    ESA-PARSER.ERROR -> ERROR-HANDLER.ERROR
    FILE-WRITER.ERROR -> ERROR-HANDLER.ERROR
    ")