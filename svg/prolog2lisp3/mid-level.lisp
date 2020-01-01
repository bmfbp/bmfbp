(in-package :arrowgrams/parser)

(defrule tInt (+ (character-ranges (#\0 #\9)))
  (:text t) (:function parse-integer) (:lambda (x) `(int ,x)))

(defrule tVar (and (or tDontCare tNamedVar) (* tWS))
  (:destructure (x spc) (declare (ignore spc)) `(var ,x)))

(defrule tIdent (and tLowerCaseLetter (* tOtherLetter))
  (:text t) (:lambda (x) `(ident ,x)))


