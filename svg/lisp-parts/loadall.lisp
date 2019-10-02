;;; Deprecated in place of using arrowgram.asd


;;; Paul:  which package is this special supposed to be in?
;;; Doesn't seem to be present under SBCL
(setq *handle-warn-on-redefinition* nil)

(asdf:load-system :paip)

(in-package :paip)

 
(load (asdf:system-relative-pathname :paip "lisp/prolog.lisp"))

(ql:quickload :loops)


(defpackage :arrowgram
  (:use :cl))

(paip::clear-db)

(in-package :arrowgram)

(load "~/projects/bmfbp/svg/lisp-parts/everything.lisp")



(load "~/projects/bmfbp/svg/lisp-parts/assign-parents-to-ellipses")
;(load "~/projects/bmfbp/svg/lisp-parts/find-comments")
(load "~/projects/bmfbp/svg/lisp-parts/bounding-boxes")
(load "~/projects/bmfbp/svg/lisp-parts/lwpasses")
