(in-package :arrowgrams/parser)

(defrule tInt (and (+ (character-ranges (#\0 #\9)))
                   (* tWS))
  (:function butlast)
  (:text t)
  (:function parse-integer)
  (:lambda (x) `(int ,x)))

(defrule tVar (and (or tDontCare tNamedVar) (* tWS))
  (:function first)
  (:lambda (x) `(var ,x)))

(defrule tIdent (and tLowerCaseLetter (* tOtherLetter) (* tWS))
  (:function butlast)
  (:text t)
  (:lambda (x) `(ident ,x)))


