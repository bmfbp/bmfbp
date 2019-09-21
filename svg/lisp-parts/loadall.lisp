;(ql:quickload :paip-prolog)
(setq *handle-warn-on-redefinition* nil)


(asdf:load-system :paip)

(in-package :paip)

(load (asdf:system-relative-pathname :paip "lisp/prolog.lisp"))
(load "~/projects/bmfbp/svg/lisp-parts/everything.lisp")

(defpackage :arrowgram
  (:use :cl :paip))

(ql:quickload :loops)

(in-package :arrowgram)

(paip::clear-db)

(load "~/projects/bmfbp/svg/lisp-parts/assign-parents-to-ellipses")
(load "~/projects/bmfbp/svg/lisp-parts/find-comments")
(load "~/projects/bmfbp/svg/lisp-parts/bounding-boxes")
(load "~/projects/bmfbp/svg/lisp-parts/lwpasses")