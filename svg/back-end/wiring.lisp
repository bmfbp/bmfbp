(in-package :cl-user)

(defparameter *wiring* "
self.start -> dumper.start tokenize.start
dumper.request strings.request ws.reqest symbols.request -> tokenize.pull
tokenize.out -> strings.token
strings.out -> parens.token
parens.out -> spaces.token
spaces.out -> symbols.token
symbols.out -> dumper.in
dumper.out -> self.out

dumper.error tokenize.error parens.error strings.error ws.error symbols.error spaces.error -> self.error
")

(esrap:defrule <ws> (or #\Space #\Newline))
(esrap:defrule <arrow> (and "->" (* ws)) (:constant :arrow))
(esrap:defrule <dot> (and "." (* ws)) (:constant :dot))
(esrap:defrule <ident> (and (esrap:character-ranges (#\a #\z) (#\A #\Z)) (* (esrap:character-ranges (#\a #\z) (#\A #\Z) (#\0 #\9)))) (:text t))
(esrap:defrule <part> <ident>)
(esrap:defrule <pin> <ident>)
(esrap:defrule <part-pin> (and <part> <dot> <pin> (* <ws>)))
(esrap:defrule <part-pins> (+ <part-pin>))
(esrap:defrule <wire> (and <part-pins> <arrow> <part-pins>))
(esrap:defrule <wires> (+ wire))

(defun make-wires ()
  (esrap:parse '<wires> *wiring*))
  