(in-package :arrowgrams/parser)

(defrule tInt (and (+ (character-ranges (#\0 #\9)))
                   (* tWS))
  (:function ignore-trailing-ws)
  (:text t)
  (:function parse-integer)
  (:lambda (x) `(int ,x)))

(defrule tVar (and (or tDontCare tNamedVar) (* tWS))
  (:function ignore-trailing-ws)
  (:lambda (x) `(var ,x))) 

(defrule tIdent (and tLowerCaseLetter (* tOtherLetter) (* tWS))
  (:text t)
  (:lambda (x) `(ident ,x)))


