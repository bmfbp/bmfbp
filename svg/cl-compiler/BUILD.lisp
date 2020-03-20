(BUILD
  :metadata "\"[{\"dir\":\"build_process/\",\"kindName\":\"build-collector\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/build-collector.lisp\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"build-recursive\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"lispparts/build-recursive.svg\",\"ref\":\"master\"}]\""
  
   (SVG-FILENAME DONE)
   (DONE JSON-COLLECTION ERROR)
  
  (:code BUILD-COLLECTOR (DONE GRAPH NAME DESCRIPTOR) (DONE FINAL-CODE ERROR))
  (:code BUILD-RECURSIVE (SVG-FILENAME) (GRAPH NAME CODE-PART-DESCRIPTOR ERROR))
  "
    BUILD-RECURSIVE.ERROR -> SELF.ERROR
    BUILD-RECURSIVE.CODE-PART-DESCRIPTOR -> BUILD-COLLECTOR.DESCRIPTOR
    BUILD-RECURSIVE.NAME -> BUILD-COLLECTOR.NAME
    BUILD-RECURSIVE.GRAPH -> BUILD-COLLECTOR.GRAPH
    SELF.SVG-FILENAME -> BUILD-RECURSIVE.SVG-FILENAME
    BUILD-COLLECTOR.ERROR -> SELF.ERROR
    BUILD-COLLECTOR.FINAL-CODE -> SELF.JSON-COLLECTION
    BUILD-COLLECTOR.DONE -> SELF.DONE
    SELF.DONE -> BUILD-COLLECTOR.DONE
    ")