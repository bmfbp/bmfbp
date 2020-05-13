(BUILD-JSON
  :metadata "\"[{\"dir\":\"build_process/\",\"kindName\":\"file-writer\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"parts/cl/file-writer.lisp\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"alist-writer\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"parts/cl/alist-writer.lisp\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"build\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"parts/cl/build.lisp\",\"ref\":\"master\"}]\""
  
   (ALIST-FILENAME OUTPUT-FILENAME SVG-FILENAME DONE)
   (ERROR)
  
  (:code BUILD (DONE SVG-FILENAME) (ALIST JSON-COLLECTION ERROR))
  (:code ALIST-WRITER (WRITE FILENAME) (ERROR))
  (:code FILE-WRITER (WRITE FILENAME) (ERROR))
  "
    SELF.ALIST-FILENAME -> ALIST-WRITER.FILENAME
    SELF.OUTPUT-FILENAME -> FILE-WRITER.FILENAME
    SELF.SVG-FILENAME -> BUILD.SVG-FILENAME
    SELF.DONE -> BUILD.DONE
    FILE-WRITER.ERROR -> SELF.ERROR
    ALIST-WRITER.ERROR -> SELF.ERROR
    BUILD.ERROR -> SELF.ERROR
    BUILD.JSON-COLLECTION -> FILE-WRITER.WRITE
    BUILD.ALIST -> ALIST-WRITER.WRITE
    ")