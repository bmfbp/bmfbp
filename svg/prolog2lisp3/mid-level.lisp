(in-package :arrowgrams/parser)

(defrule tInt (and (+ (character-ranges (#\0 #\9)))
                   (* tWS))
  (:function ignore-trailing-ws-2)
  (:text t)
  (:function parse-integer)
  (:lambda (x) `(int ,x)))

(defrule tVar (and (or tDontCare tNamedVar) (* tWS))
  (:function ignore-trailing-ws-2)
  (:lambda (x) `(var ,x)))

(defrule tIdent (and tLowerCaseLetter (* tOtherLetter) (* tWS))
  (:function ignore-trailing-ws-2)
  (:text t)
  (:lambda (x) `(ident ,x)))


