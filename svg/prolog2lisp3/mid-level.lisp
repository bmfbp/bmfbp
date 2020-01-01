(in-package :arrowgrams/parser)

(defrule tInt (and (+ (character-ranges (#\0 #\9)))
                   (* tWS))
  (:destructure (x spc) (declare (ignore spc)) x)                 
  (:text t)
  (:function parse-integer)
  (:lambda (x) `(int ,x)))

(defrule tVar (and (or tDontCare tNamedVar) (* tWS))
  (:destructure (x spc) (declare (ignore spc)) x)
  (:lambda (x) `(var ,x))) 

(defrule tIdent (and tLowerCaseLetter (* tOtherLetter) (* tWS))
  (:destructure (x spc) (declare (ignore spc)) x)                 
  (:text t)
  (:lambda (x) `(ident ,x)))


