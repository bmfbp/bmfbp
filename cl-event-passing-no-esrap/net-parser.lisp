(in-package :cl-event-passing)

(esrap:defrule <ws> (or #\Space #\Newline #\Tab))
(esrap:defrule <arrow> (and "->" (* <ws>)) (:constant :arrow))
(esrap:defrule <dot> (and "." (* <ws>)) (:constant :dot))
(esrap:defrule <comma> (and "," (* <ws>)))
;; exclude . and -
(esrap:defrule <lisp-id-char-first> (esrap:character-ranges (#\a #\z) (#\A #\Z) #\@ #\* #\~ #\! #\$ #\% #\^ #\+ #\_ #\= #\{ #\} #\[ #\] #\\ #\/ #\< #\> #\?))
;; exclude .
(esrap:defrule <lisp-id-char-follow> (or (esrap:character-ranges (#\0 #\9)) #\- <lisp-id-char-first>))
(esrap:defrule <ident> (and <lisp-id-char-first> (* <lisp-id-char-follow>)) (:text t))
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

(defun net-parser (net)
  (if (stringp net)
      (esrap:parse '<wires> net)
    net))
  
(defun destring (str)
  (if (string= "self" str)
      :self
    (intern (string-upcase str))))

(defun pin-name (str)
  (intern (string-upcase str) "KEYWORD"))

