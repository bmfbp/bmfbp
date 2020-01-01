(in-package :arrowgrams/parser)

(defun remTrailingSpace (x-spc)
  (destructuring-bind (x spc)
    x-spc
  (declare (ignore spc))
  x))

(defrule tInt (and (+ (character-ranges (#\0 #\9)))
                   (* tWS))
  (:function remTrailingSpace)
  (:text t)
  (:function parse-integer)
  (:lambda (x) `(int ,x)))

(defrule tVar (and (or tDontCare tNamedVar) (* tWS))
  (:function remTrailingSpace)
  (:lambda (x) `(var ,x))) 

(defrule tIdent (and tLowerCaseLetter (* tOtherLetter) (* tWS))
  (:function remTrailingSpace)
  (:text t)
  (:lambda (x) `(ident ,x)))


