(BOOT-BOOT
  :metadata "\"[{\"dir\":\"build_process/\",\"kindName\":\"compiler\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/compiler.lisp\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"part-namer\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/part-namer.lisp\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"build process\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/json-array-splitter.svg\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"probe3\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/probe3.svg\",\"ref\":\"master\"}]\""
  
   (SVG-FILENAME)
   (ERROR GRAPH JSON-FILE-REF NAME)
  
  (:code JSON-ARRAY-SPLITTER (JSON ARRAY) (ERROR GRAPH ITEMS))
  (:code PART-NAMER (FILENAME) (NAME))
  (:code COMPILER (SVG-FILENAME) (JSON ERROR LISP METADATA))
  "
    COMPILER.METADATA -> JSON-ARRAY-SPLITTER.ARRAY
    COMPILER.ERROR -> SELF.ERROR
    COMPILER.JSON -> JSON-ARRAY-SPLITTER.JSON
    SELF.SVG-FILENAME -> COMPILER.SVG-FILENAME,PART-NAMER.FILENAME
    PART-NAMER.NAME -> SELF.NAME
    JSON-ARRAY-SPLITTER.ITEMS -> SELF.JSON-FILE-REF
    JSON-ARRAY-SPLITTER.GRAPH -> SELF.GRAPH
    JSON-ARRAY-SPLITTER.ERROR -> SELF.ERROR
    ")