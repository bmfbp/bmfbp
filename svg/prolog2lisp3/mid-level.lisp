(in-package :arrowgrams/parser)

(defrule tInt (+ (character-ranges (#\0 #\9)))
  (:text t) (:function parse-integer) (:lambda (x) `(int ,x)))

(defrule tVar (or tDontCare tNamedVar)
  (:lambda (x) `(var ,x)))

(defrule tIdent (and tLowerCaseLetter (* tOtherLetter))
  (:text t) (:lambda (x) `(ident ,x)))


