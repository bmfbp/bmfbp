(defsystem :json-from-editor
  :depends-on (:parsing-assembler/use :alexandria)
  :components ((:module "source"
                        :pathname "./"
                        :components ((:file "path")
				     (:static-file "editor.pasm")
				     (:static-file "hello_world.json")
				     (:file "classes")
				     (:file "mechanisms" :depends-on ("classes"))
				     (:file "generate" 
					    :depends-on ("path" 
							 "classes"
							 "mechanisms"
							 "editor.pasm" 
							 "hello_world.json"))))))

