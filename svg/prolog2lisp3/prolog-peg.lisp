(in-package :arrowgrams/parser)

(defrule pRule (and pPredicate tColonDash pPredicateList tDot)
  (:lambda (y)
    (let ((x (delete nil y)))
      (assert (and (listp x) (= 2 (length x))))
      `(rule ,(first x) ,(second x)))))

(defrule pPredicateList (or pPredicateList1 pPredicateList2))
(defrule pPredicateList1 (and pPredicate pNotComma)
  (:function first)
  (:lambda (x) `(predicate-list ,x)))
(defrule pPredicateList2 (and pPredicate tComma pPredicateList)
  (:lambda (x) `(predicate-list ,(first x) ,(third x))))


(defrule pPredicate (or pAtomNotLpar
                        pStructure
                        is-Statement)
  (:lambda (x) `(predicate ,x)))

(defrule pStructure (or pStructure1 pStructure2))
(defrule pStructure1 (and tAtom tLpar tRpar)
  (:function first)
  (:lambda (x) `(structure ,x)))
(defrule pStructure2 (and tAtom tLpar pTermList tRpar)
  (:function ignore-lpar-rpar-4)
  (:lambda (x) `(structure ,@x)))

(defrule pTermList (or pTermList1 pTermList2))
(defrule pTermList1 (and pTerm pNotComma)
  (:lambda (x) `(term-list ,(first x))))
(defrule pTermList2 (and pTerm tComma pTermList)
  (:lambda (x) `(term-list ,(first x) ,(third x))))

(defrule pTerm ( and
                 (or
                  pConstant
                  pAtomNotLpar
                  tSingleQuotedAtom
                  pVarNotIs
                  pStructure)
                 (* tWS))
  (:function first)
  (:lambda (x) `(term ,x)))

(defrule pAtomNotLpar (and tAtom (! #\()) (:function ignore-trailing-lp-2))
(defrule pVarNotIs (and tVar pNotIs) (:function ignore-trailing-ws-2))
(defrule pNotIs (! tIs))
(defrule pNotComma (! tComma))
(defrule pNotLpar (! tLpar))

(defrule tAtom (or tIdent tCut tTrue tFail) (:lambda (x) `(atom ,x)))

(defrule pConstant tInt (:lambda (x) `(constant ,x)))



;; revelation: math exprs only appear as the RHS of IS statements


(esrap:defrule rule-Expr rule-Additive)

(esrap:defrule rule-Additive (or (and rule-Mult tPlus rule-Additive)
                                 (and rule-Mult tMinus rule-Additive)
                                 rule-Mult)
  (:lambda (x)
    (if (and (listp x) (eq '+ (second x)))
        `(+ ,(first x) ,(third x))
      (if (and (listp x) (eq '- (second x)))
        `(- ,(first x) ,(third x))
        x))))

(esrap:defrule rule-Mult (or (and rule-Primary tMul rule-Mult)
                             (and rule-Primary tDiv rule-Mult)
                             rule-Primary)
  (:lambda (x)
    (if (and (listp x) (eq '* (second x)))
        `(* ,(first x) ,(third x))
      (if (and (listp x) (eq '/ (second x)))
        `(/ ,(first x) ,(third x))
        x))))

(esrap:defrule rule-Primary (or tInt
                                (and tLpar rule-Additive tRpar))
  (:function ignore-parens)
  (:lambda (x) `(primary ,x)))



(esrap:defrule rule-TOP-Expr (and (* tWS) rule-Expr)
  (:destructure (spc e) (declare (ignore spc)) e)
  (:lambda (x) `(top-expr ,x)))

(esrap:defrule is-Statement (and tVar tIs rule-Expr)
  (:destructure (v is e) (declare (ignore is)) `(is ,v ,e)))


(defrule rule-TOP-IS (and (* tWS)  is-Statement )
  (:function ignore-leading-ws)
  (:function first))

(defun test ()
  (setf cl:*print-right-margin* 40)

  #+nil(pprint (parse 'rule-TOP-IS "X is 1"))
  #+nil(pprint (parse 'rule-TOP-IS "X is 1+2"))
  #+nil(pprint (parse 'rule-TOP-IS "X is 1 + 2"))

  (pprint (parse 'rule-TOP-IS "X is (16 + 17) / (18 - 19)"))

  ;(esrap:trace-rule 'pPredicate :recursive t)

  (pprint (esrap:parse 'pStructure "namedSource()"))
  (pprint (esrap:parse 'pStructure "namedSource(X)"))

  (pprint (esrap:parse 'pPredicate "namedSource(X)"))
  (pprint (esrap:parse 'pPredicateList "namedSource(X),dummy(0)"))
  (pprint (esrap:parse 'pPredicateList "namedSource(X),pred(X,Y),dummy(0)"))
  (pprint (esrap:parse 'pPredicateList "atom,pred(X,Y),dummy(0)"))
  (pprint (esrap:parse 'pPredicateList "atom"))
  (pprint (esrap:parse 'pPredicateList "atom,pred(X,Y)"))
  (pprint (esrap:parse 'pPredicateList "atom,pred(X,Y),dummy(0),X is 1"))
  )
