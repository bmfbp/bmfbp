(in-package :arrowgrams)

(defun parser-builder ()
  (cl-event-passing-user::@defnetwork arrowgrams::main
                                      (:code readfile (:filename) (:out :fatal) #'readfileintostring)
                                      (:code pegp (:peg-in) (:lisp-list-out :fatal) #'pegtolisp)
                                      (:code stripq (:in) (:out :fatal) #'stripquotes)
                                      (:schem arrowgrams::main (:peg-source-file-name) (:lisp-source-out :fatal-error)
                                       ;; internal-parts
                                       (readfile pegp stripq)
                                       ;; wiring
                                       ((((:self :peg-source-file-name)) ((readfile :filename)))
                                        (((readfile :out)) ((stripq :in)))
                                        (((stripq :out)) ((pegp :peg-in)))
                                        (((pegp :lisp-list-out)) ((:self :lisp-source-out)))
                                        (((readfile :fatal) (pegp :fatal) (stripq :fatal)) ((:self :fatal-error)))
                                        ))))
