(in-package :cl-user)

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
(esrap:defrule <part-pin> (and <part> <dot> <pin> (* <ws>))
  (:destructure (part dot pin ws)
   (declare (ignore dot ws))
   `(,part ,pin)))
(esrap:defrule <part-pin-comma> (and <part> <dot> <pin> <comma>)
  (:destructure (part dot pin comma)
   (declare (ignore dot comma))
   `(,part ,pin)))
(esrap:defrule <part-pins> (and (* <part-pin-comma>) <part-pin> (* <ws>)))
(esrap:defrule <wire> (and <part-pins> <arrow> <part-pins>)
  (:destructure (LHS arrow RHS)
   (declare (ignore arrow))
   `(,LHS ,RHS)))

(esrap:defrule <wires> (and (* <ws>) (+ <wire>)) (:function second))

(defun make-wires ()
  (esrap:parse '<wires> *wiring*))
  