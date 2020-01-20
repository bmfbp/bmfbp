(in-package :cl-user)

(defparameter *test-wiring* "
self.start -> dumper.start,tokenize.start
self.start -> dumper.start,tokenize.start
")

(defparameter *wiring* "
self.start -> dumper.start,tokenize.start
dumper.request,strings.request,ws.reqest,symbols.request -> tokenize.pull
tokenize.out -> strings.token
strings.out -> parens.token
parens.out -> spaces.token
spaces.out -> symbols.token
symbols.out -> dumper.in
dumper.out -> self.out

dumper.error,tokenize.error,parens.error,strings.error,ws.error,symbols.error,spaces.error -> self.error
")

(esrap:defrule <ws> (or #\Space #\Newline))
(esrap:defrule <arrow> (and "->" (* <ws>)) (:constant :arrow))
(esrap:defrule <dot> (and "." (* <ws>)) (:constant :dot))
(esrap:defrule <comma> (and "," (* <ws>)))
(esrap:defrule <ident> (and (esrap:character-ranges (#\a #\z) (#\A #\Z)) (* (esrap:character-ranges (#\a #\z) (#\A #\Z) (#\0 #\9)))) (:text t))
(esrap:defrule <part> <ident>)
(esrap:defrule <pin> <ident>)
(esrap:defrule <part-pin> (and <part> <dot> <pin> (* <ws>)))
(esrap:defrule <part-pin-comma> (and <part> <dot> <pin> <comma>))
(esrap:defrule <part-pins> (and (* <part-pin-comma>) <part-pin> (* <ws>)))
(esrap:defrule <wire> (and <part-pins> <arrow> <part-pins>))
(esrap:defrule <wires> (and (* <ws>) (+ <wire>)))

(defun make-wires ()
  (esrap:parse '<wires> *wiring*))
  