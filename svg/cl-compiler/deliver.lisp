(in-package "CL-USER")
(load-all-patches)
(load "~/quicklisp/setup.lisp")
(ql:quickload :alexandria)
(ql:quickload :esrap)
(ql:quickload :arrowgrams/compiler)
(deliver 'arrowgrams/compiler::main "~/quicklisp/local-projects/bmfbp/svg/compiler3/lwacomp3" 5
         :KEEP-LISP-READER T
         :keep-clos t
         :keep-symbols :all
         :packages-to-keep :all
         :keep-pretty-printer t)