(defsystem :esa
    :depends-on (:cl-event-passing :alexandria)
    :around-compile (lambda (next)
                      (proclaim '(optimize (debug 3)
                                  (safety 3)
                                  (speed 0)))
                      (funcall next))
    :components ((:module "source"
                          :pathname "./"
                          :components ((:file "package")
                                       (:file "token" :depends-on ("package"))
                                       (:file "classes" :depends-on ("package"))
                                       (:file "rp-macros" :depends-on ("package"))
				       
                                       (:file "dumper" :depends-on ("package" "token"))

				       (:file "tokenize" :depends-on ("package" "token"))
                                       (:file "comments" :depends-on ("package" "token"))
                                       (:file "raw-text" :depends-on ("package" "token"))
                                       (:file "strings" :depends-on ("package" "token"))
                                       (:file "spaces" :depends-on ("package" "token"))
                                       (:file "symbols" :depends-on ("package" "token"))
                                       (:file "integers" :depends-on ("package" "token"))

                                       (:file "parser-mechanisms"
					      :depends-on ("package" "token" "dumper"
                                                           "rp-macros"
							   "tokenize" "comments" "raw-text" "strings" "spaces"
							   "symbols" "integers"))
                                       (:file "rp-rules" :depends-on ("parser-mechanisms"))
                                       (:file "rp-parser" :depends-on ("rp-rules"))
                                       (:file "esa-dsl" :depends-on ("parser-mechanisms"))
                                       (:file "esa-parser" :depends-on ("esa-dsl"))
                                       (:file "file-writer" :depends-on ("package"))
                                       (:file "parser-schem" :depends-on ("file-writer" "esa-parser" "rp-parser"))))))
