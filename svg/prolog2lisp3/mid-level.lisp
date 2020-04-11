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

(defrule tIdent (or tIdent1))

(defrule tIdent1 (and tLowerCaseLetter (* tOtherLetter) (* tWS))
  (:function butlast)
  (:text t)
  (:lambda (x) `(ident ,x)))

(defrule tString (and tSingleQuotedAtom (* tWS)) ;; strictly, prolog allows '...' as an atom, but I use it only as Strings
  (:function first)
  (:function strip-leading-and-trailing-single-quotes)
  (:lambda (x) `(string ,x)))

(defun strip-leading-and-trailing-single-quotes (x)
  (assert (stringp x))
  (subseq x 1 (1- (length x))))

