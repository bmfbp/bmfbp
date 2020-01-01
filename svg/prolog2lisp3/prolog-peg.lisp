(in-package :arrowgrams/parser)

#+nil(defconstant +prolog-grammar+
"
pClause <- pPredicate tDot / pPredict tColonDash tDot
pPredicateList <- pPredicate / pPredicate tComma pPredicateList
pPredicate <- pAtom / pStructure
pStructure <- pAtom tLpar tRpar / pAtom tLpar pTermList tRpar
pTermList <- pTerm / pTerm tComma pTermList
pTerm <- pConstant / tAtom / tVar / pStructure
pConstant <- tInt
")

#|
(defrule pClause (or (and pPredicate tDot) (and pPredicate tColonDash tDot)))

|#

(defrule pRule (and pPredicate tColonDash pPredicateList tDot)
  (:lambda (y)
    (let ((x (delete nil y)))
      (assert (and (listp x) (= 2 (length x))))
      `(rule ,(first x) ,(second x)))))

(defrule pPredicateList (or (and pPredicate pNotComma)
                            (and pPredicate tComma pPredicateList))
  (:lambda (x) `(predicate-list ,(delete nil x))))

(defrule pPredicate (or (and tAtom pNotLpar)
                        pStructure)
  (:lambda (x) `(predicate ,(delete nil x))))

(defrule pStructure (or (and tAtom tLpar tLpar)
                        (and tAtom tLpar pTermList tRpar))
  (:lambda (y)
    (let ((x (delete nil y)))
      (assert (and (listp x)
                   (= 2 (length x)))) ;; dummy(X,Y) => (struct (atom (ident "dummy")) (term-list ???
      `(structure ,(first x) ,(second x)))))

(defrule pTermList (or (and pTerm pNotComma)
                       (and pTerm tComma pTermList))
  (:lambda (x) `(term-list ,(delete nil x))))


(defrule pTerm ( and
                 (or
                  pConstant
                  (and tAtom (! #\())
                  tSingleQuotedAtom
                  (and tVar pNotIs)
                  pStructure)
                 (* tWS))
  (:destructure (x spc) (declare (ignore spc)) x)
  (:lambda (x) `(term ,x)))

(defrule pNotIs (! tIs))
(defrule pNotComma (! tComma))
(defrule pNotLpar (! tLpar))

(defrule tAtom (or tIdent tCut tTrue tFail) (:lambda (x) `(atom ,x)))

(defrule pConstant tInt (:lambda (x) `(constant ,x)))

;; revelation: math exprs only appear as the RHS of IS statements


(defun delnil (x) (delete nil x))


(esrap:defrule rule-Expr rule-Additive)

(esrap:defrule rule-Additive (or (and rule-Mult tPlus rule-Additive)
                                 (and rule-Mult tMinus rule-Additive)
                                 rule-Mult)
  (:lambda (x) (delnil x))
  (:lambda (x)
    #+nil(format *standard-output* "~&additive c = ~a x = ~S~%" (length x) x)
    (if (and (listp x) (eq '+ (second x)))
        `(+ ,(first x) ,(third x))
      (if (and (listp x) (eq '- (second x)))
        `(- ,(first x) ,(third x))
        x))))
;;;     (ecase (length x)
;;;       (2 x)
;;;       (3 (list (second x) (first x) (third x))))))

(esrap:defrule rule-Mult (or (and rule-Primary tMul rule-Mult)
                             (and rule-Primary tDiv rule-Mult)
                             rule-Primary)
  (:lambda (x) (delnil x))
  (:lambda (x)
    x))

(esrap:defrule rule-Primary (or tInt
                                (and tLpar rule-Additive tRpar))
  (:lambda (x) (delnil x))
  (:lambda (x)
    (format *standard-output* "~&primary  c = ~a x = ~s~%" (if (listp x) (length x) 0) x)
    (assert (listp x))
    (if (and (= 1 (length x)) (listp (first x)))
        `(paren ,(first x))
    `(primary ,x))))



(esrap:defrule rule-TOP-Expr (and (* tWS) rule-Expr)
  (:destructure (spc e) (declare (ignore spc)) e)
  (:lambda (x) (delnil x))
  (:lambda (x) `(top-expr ,x)))

(esrap:defrule is-Statement (and tVar tIs rule-Expr)
  (:lambda (x) (delnil x))
  (:destructure (v is e) (declare (ignore is)) `(is ,v ,e)))


(defun remLeadingSpace (spc-x)
  (destructuring-bind (spc x)
      spc-x
    (declare (ignore spc))
    x))

(defrule rule-TOP-IS (and (* tWS)  is-Statement )
  (:function remLeadingSpace))
  
(defun test ()
  ;(pprint (esrap:parse 'pPredicate "namedSource(X)"))
  ;(pprint (esrap:parse 'pPredicate "namedSource(0)"))
  #+nil(pprint (parse 'rule-TOP-IS "X is 2"))
  #+nil(pprint (parse 'rule-TOP-IS "X is 2 + 3 "))
  #+nil(pprint (parse 'rule-TOP-IS "X is 2 + 3 - 4"))
  #+nil(pprint (parse 'rule-TOP-IS "X is 2 + 3 - 4 * 5"))
  #+nil(pprint (parse 'rule-TOP-IS "X is (2)"))
  #+nil(pprint (parse 'rule-TOP-IS "X is (2 + 3)"))
  #+nil(pprint (parse 'rule-TOP-IS "X is (4 - 5)"))
  #+nil(pprint (parse 'rule-TOP-IS "X is 1 + (4 - 5)"))
  (pprint (parse 'rule-TOP-IS "X is (6 + 7) + (4 - 5)"))
  #+nil(pprint (parse 'rule-TOP-IS "X is (2 + 3) - 5"))
  #+nil(pprint (parse 'rule-TOP-IS "X is 2 + 3 - 4 * 5 / 6 + ( 2 + 2 )")))
  ;(pprint (parse 'rule-TOP "X is 234,computeWith(X)")))




#|
TODO
x 1. ws
2. tie is and expr into predicate? Thinking about term-list and how IS fits in.

|#