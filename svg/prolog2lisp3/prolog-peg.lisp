(in-package :arrowgrams/parser)

(defrule pRule (and pPredicate tColonDash pPredicateList tDot)
  (:lambda (y)
    (let ((x (delete nil y)))
      (assert (and (listp x) (= 2 (length x))))
      `(rule ,(first x) ,(second x)))))

(defrule pPredicateList (or (and pPredicate pNotComma)
                            (and pPredicate tComma pPredicateList))
  (:lambda (x)
    (setq *print-level* nil)
    (break "predicate list ~S" x)
    `(predicate-list ,x)))

(defrule pPredicate (or (and tAtom pNotLpar)
                        pStructure
                        is-Statement)
  (:lambda (x) `(predicate ,x)))

(defrule pStructure (or (and tAtom tLpar tRpar)
                        (and tAtom tLpar pTermList tRpar))
  (:function ignore-lpar-rpar-3)
  (:function ignore-lpar-rpar-4)
  (:lambda (x) `(structure ,x)))

(defrule pTermList (or (and pTerm pNotComma)
                       (and pTerm tComma pTermList))
  (:function ignore-not-comma-2)
  (:function ignore-mid-comma-3)
  (:lambda (x) `(term-list ,x)))


(defrule pTerm ( and
                 (or
                  pConstant
                  pAtomNotLpar
                  tSingleQuotedAtom
                  pVarNotIs
                  pStructure)
                 (* tWS))
  (:function ignore-trailing-ws-2)
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
  (:function ignore-leading-ws))

(defun test ()
  (setf cl:*print-right-margin* 40)

  #+nil(pprint (parse 'rule-TOP-IS "X is 1"))
  #+nil(pprint (parse 'rule-TOP-IS "X is 1+2"))
  #+nil(pprint (parse 'rule-TOP-IS "X is 1 + 2"))

  (pprint (parse 'rule-TOP-IS "X is (16 + 17) / (18 - 19)"))

  ;(esrap:trace-rule 'pPredicate :recursive t)

  (pprint (esrap:parse 'pStructure "namedSource()"))
  (pprint (esrap:parse 'pStructure "namedSource(X)"))

  #+nil(pprint (esrap:parse 'pPredicate "namedSource(X)"))
  #+nil(pprint (esrap:parse 'pPredicateList "namedSource(X),dummy(0)"))
  #+nil(pprint (esrap:parse 'pPredicateList "namedSource(X),pred(X,Y),dummy(0)"))
  #+nil(pprint (esrap:parse 'pPredicateList "atom,pred(X,Y),dummy(0)"))
  #+nil(pprint (esrap:parse 'pPredicateList "atom"))
  #+nil(pprint (esrap:parse 'pPredicateList "atom,pred(X,Y)"))
  #+nil(pprint (esrap:parse 'pPredicateList "atom,pred(X,Y),dummy(0),X is 1"))
  )
