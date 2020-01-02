(in-package :arrowgrams/parser)

(defrule pRule (and pPredicate tColonDash pPredicateList tDot)
  (:lambda (y)
    (let ((x (delete nil y)))
      (assert (and (listp x) (= 2 (length x))))
      `(rule ,(first x) ,(second x)))))

(defrule pPredicateList (or (and pPredicate pNotComma)
                            (and pPredicate tComma pPredicateList))
  (:function pr)
  (:function ignore-trailing-not)
  (:function ignore-middle-comma)
  (:lambda (x) `(predicate-list ,x)))

(defrule pPredicate (or (and tAtom pNotLpar)
                        pStructure
                        is-Statement)
  (:function pr)
  (:function ignore-trailing-not)
  (:lambda (x) `(predicate ,x)))

(defrule pStructure (or (and tAtom tLpar tLpar)
                        (and tAtom tLpar pTermList tRpar))
  (:function ignore-lpar-rpar)
  (:lambda (x)
      (assert (and (listp x)
                   (= 2 (length x)))) ;; dummy(X,Y) => (struct (atom (ident "dummy")) (term-list ???
      `(structure ,(first x) ,(second x))))

(defrule pTermList (or (and pTerm pNotComma)
                       (and pTerm tComma pTermList))
  (:function ignore-trailing-not)
  (:function ignore-middle-comma)
  (:lambda (x) `(term-list ,x)))


(defrule pTerm ( and
                 (or
                  pConstant
                  (and tAtom (! #\())
                  tSingleQuotedAtom
                  (and tVar pNotIs)
                  pStructure)
                 (* tWS))
  (:function remTrailingSpace)
  (:lambda (x) `(term ,x)))

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
  (:lambda (x) (skip-nil x))
  (:lambda (x)
    (if (and (listp x) (eq '+ (second x)))
        `(+ ,(first x) ,(third x))
      (if (and (listp x) (eq '- (second x)))
        `(- ,(first x) ,(third x))
        x))))

(esrap:defrule rule-Mult (or (and rule-Primary tMul rule-Mult)
                             (and rule-Primary tDiv rule-Mult)
                             rule-Primary)
  (:lambda (x) (skip-nil x))
  (:lambda (x)
    (if (and (listp x) (eq '* (second x)))
        `(* ,(first x) ,(third x))
      (if (and (listp x) (eq '/ (second x)))
        `(/ ,(first x) ,(third x))
        x))))

(esrap:defrule rule-Primary (or tInt
                                (and tLpar rule-Additive tRpar))
  (:lambda (x) (skip-nil x))
  (:lambda (x)
    (format *standard-output* "~&primary  c = ~a x = ~s~%" (if (listp x) (length x) 0) x)
    (assert (listp x))
    (if (and (= 1 (length x)) (listp (first x)))
        `(paren ,(first x))
    `(primary ,x))))



(esrap:defrule rule-TOP-Expr (and (* tWS) rule-Expr)
  (:destructure (spc e) (declare (ignore spc)) e)
  (:lambda (x) (skip-nil x))
  (:lambda (x) `(top-expr ,x)))

(esrap:defrule is-Statement (and tVar tIs rule-Expr)
  (:lambda (x) (skip-nil x))
  (:destructure (v is e) (declare (ignore is)) `(is ,v ,e)))


(defrule rule-TOP-IS (and (* tWS)  is-Statement )
  (:function ignore-leading-space))
  
(defun test ()
  (setf cl:*print-right-margin* 40)
  (pprint (parse 'rule-TOP-IS "X is (16 + 17) / (18 - 19)"))
  ;(esrap:trace-rule 'pPredicate :recursive t)
  #+nil(pprint (esrap:parse 'pPredicate "namedSource(X)"))
  #+nil(pprint (esrap:parse 'pPredicateList "namedSource(X),dummy(0)"))
  #+nil(pprint (esrap:parse 'pPredicateList "namedSource(X),pred(X,Y),dummy(0)"))
  #+nil(pprint (esrap:parse 'pPredicateList "atom,pred(X,Y),dummy(0)"))
  #+nil(pprint (esrap:parse 'pPredicateList "atom"))
  (pprint (esrap:parse 'pPredicateList "atom,pred(X,Y)"))
  #+nil(pprint (esrap:parse 'pPredicateList "atom,pred(X,Y),dummy(0),X is 1"))
  )
