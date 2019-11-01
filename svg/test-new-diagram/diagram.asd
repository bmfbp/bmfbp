(defsystem "diagram"
  :depends-on (:cl-peg :alexandria)
  :components ((:module "source"
                        :serial t 
                        :pathname "./"
                        :components ((:file "package")
                                     (:file "reset")
				     (:file "diagram-peg")))))
