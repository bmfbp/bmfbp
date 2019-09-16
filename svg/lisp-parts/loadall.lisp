(ql:quickload :paiprolog)
(ql:quickload :loops)

(declaim (optimize (safety 3) (debug 3)))

(defpackage :arrowgram
  (:use :cl))

(in-package :arrowgram)

(paiprolog::clear-db)

(load "~/projects/bmfbp/svg/lisp-parts/common-queries")
(load "~/projects/bmfbp/svg/lisp-parts/assign-parents-to-ellipses")
(load "~/projects/bmfbp/svg/lisp-parts/find-comments")
(load "~/projects/bmfbp/svg/lisp-parts/find-metadata")
(load "~/projects/bmfbp/svg/lisp-parts/bounding-boxes")
(load "~/projects/bmfbp/svg/lisp-parts/lwpasses")