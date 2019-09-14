(in-package "CL-USER")
(load-all-patches)
(defvar *delivered-image-name* "~/bin/lwpasses")
(load "~/quicklisp/setup.lisp")
(ql:quickload :paip-prolog)
(ql:quickload :loops)
(compile-file (current-pathname "lwpasses") :output-file :temp :load t)
(deliver 'main *delivered-image-name* 5 :KEEP-LISP-READER T)





