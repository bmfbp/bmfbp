(in-package :cl-user)

(defparameter *no-symbols-wiring* "
self.start -> dumper.start,tokenize.start
dumper.request,strings.request,ws.request,symbols.request -> tokenize.pull
tokenize.out -> strings.token
strings.out -> parens.token
parens.out -> spaces.token
spaces.out -> dumper.in
dumper.out -> self.out

dumper.error,tokenize.error,parens.error,strings.error,ws.error,symbols.error,spaces.error -> self.error
")

(defparameter *full-wiring* "
self.start -> dumper.start,tokenize.start
dumper.request,strings.request,symbols.request -> tokenize.pull
tokenize.out -> strings.token
strings.out -> parens.token
parens.out -> spaces.token
spaces.out -> symbols.token
symbols.out -> dumper.in
dumper.out -> self.out

dumper.error,tokenize.error,parens.error,strings.error,symbols.error,spaces.error -> self.error
")

(defparameter *wiring* *full-wiring*)

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
   `(,(destring part) ,(pin-name pin))))
(esrap:defrule <part-pin-comma> (and <part> <dot> <pin> <comma>)
  (:destructure (part dot pin comma)
   (declare (ignore dot comma))
   `(,(destring part) ,(pin-name pin))))
(esrap:defrule <part-pins> (and (* <part-pin-comma>) <part-pin> (* <ws>))
  (:destructure (part-pin-comma part-pin ws)
   (declare (ignore ws))
   `(,@part-pin-comma ,part-pin)))
(esrap:defrule <wire> (and <part-pins> <arrow> <part-pins>)
  (:destructure (LHS arrow RHS)
   (declare (ignore arrow))
   `(,LHS ,RHS)))

(esrap:defrule <wires> (and (* <ws>) (+ <wire>)) (:function second))

(defun make-wires ()
  (let ((result (esrap:parse '<wires> *wiring*)))
    (pprint result)
    nil))
  
(defun destring (str)
  (if (string= "self" str)
      :self
    (intern (string-upcase str))))

(defun pin-name (str)
  (intern (string-upcase str) "KEYWORD"))