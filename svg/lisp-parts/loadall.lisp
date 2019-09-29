;;; Deprecated in place of using arrowgram.asd


;;; Paul:  which package is this special supposed to be in?
;;; Doesn't seem to be present under SBCL
(setq *handle-warn-on-redefinition* nil)

(asdf:load-system :paip)

(in-package :paip)

 
(load (asdf:system-relative-pathname :paip "lisp/prologc.lisp"))
(load (asdf:system-relative-pathname :paip "lisp/prologc.lisp"))

(ql:quickload :loops)


(defpackage :arrowgram
  (:use :cl))

(paip::clear-db)

(in-package :paip)

(load (asdf:system-relative-pathname :arrowgram "collect.lisp"))



(load (asdf:system-relative-pathname :arrowgram "assign-parents-to-ellipses.lisp"))
;(load "find-comments")
(load (asdf:system-relative-pathname :arrowgram "bounding-boxes.lisp"))
(load (asdf:system-relative-pathname :arrowgram "lwpasses.lisp"))

