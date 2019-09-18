(ql:quickload :paiprolog)

(declaim (optimize (safety 3) (debug 3)))

(defpackage :arrowgram
  (:use :cl))

(in-package :arrowgram)

(defun t1 ()
  (paiprolog:prolog-collect (?T ?S) (speechbubble ?S) (write d) (text ?T ?) (write e) (point-completely-inside-bounding-box ?T ?S) (write f)))

(defun t2 ()
  (paiprolog:prolog-collect (?T ?S) (speechbubble ?S) (write a) (text ?T ?) (write b) (text-completely-inside-box ?T ?S) (write c)))
