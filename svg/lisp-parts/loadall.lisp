(ql:quickload :paiprolog)
(ql:quickload :loops)

(defpackage :arrowgram
  (:use :cl))

(in-package :arrowgram)

(paiprolog::clear-db)

(load "~/projects/bmfbp/svg/lisp-parts/common-queries")
(load "~/projects/bmfbp/svg/lisp-parts/assign-parents-to-ellipses")
;(load "~/projects/bmfbp/svg/lisp-parts/find-comments")
(load "~/projects/bmfbp/svg/lisp-parts/bounding-boxes")
(load "~/projects/bmfbp/svg/lisp-parts/lwpasses")