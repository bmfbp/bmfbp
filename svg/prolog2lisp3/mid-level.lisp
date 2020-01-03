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

(defrule tIdent (or tIdent1 tIdent2))

(defrule tIdent1 (and tLowerCaseLetter (* tOtherLetter) (* tWS))
  (:function butlast)
  (:text t)
  (:lambda (x) `(ident ,x)))

(defrule tIdent2 (and tSingleQuotedAtom (* tWS))
  (:function first)
  (:lambda (x) `(ident ,x)))


