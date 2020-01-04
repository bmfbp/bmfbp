(in-package :arrowgrams/parser)

(defrule rule-TOP (and (+ rule-TOP1) tEOF)
  (:lambda (x) `(list-of-rules ,@(first x))))

(defrule rule-TOP1 (and (* tWS) (or pRule rule-directive rule-fact)) (:function second))

(defrule rule-directive (and (* tWS) tColonDash tJunk-to-eol) (:constant '(directive)))

(defrule rule-fact (and pPredicate tDot) (:lambda (x) `(fact ,(first x))))



(defrule pRule (and pPredicate tColonDash pPredicateList tDot)
  (:lambda (x) `(rule ,(first x) ,(third x))))

(defrule pPredicateList (or pPredicateList1 pPredicateList2))
(defrule pPredicateList1 (and pPredicate pNotComma)
  (:function first)
  (:lambda (x) `(predicate-list ,x)))
(defrule pPredicateList2 (and pPredicate tComma pPredicateList)
  (:lambda (x) `(predicate-list ,(first x) ,(third x))))


(defrule pPredicate (or pAtomNotLpar
                        pStructure
                        is-predicate
                        GEQ-predicate
                        LEQ-predicate)
  (:lambda (x) `(predicate ,x)))

(defrule pStructure (or pStructure1 pStructure2))
(defrule pStructure1 (and tAtom tLpar tRpar)
  (:lambda (x) `(structure ,(first x))))
(defrule pStructure2 (and tAtom tLpar pTermList tRpar)
  (:lambda (x) `(structure ,(first x) ,(third x))))

(defrule pTermList (or pTermList1 pTermList2))
(defrule pTermList1 (and pTerm pNotComma)
  (:lambda (x) `(term-list ,(first x))))
(defrule pTermList2 (and pTerm tComma pTermList)
  (:lambda (x) `(term-list ,(first x) ,(third x))))

(defrule pTerm ( and
                 (or
                  pConstant
                  pAtomNotLpar
                  pVarNotIs
                  pStructure)
                 (* tWS))
  (:function first)
  (:lambda (x) `(term ,x)))

(defrule pAtomNotLpar (and tAtom (! #\()) (:function first))
(defrule pVarNotIs (and tVar pNotIs) (:function first))
(defrule pNotIs (! tIs))
(defrule pNotComma (! tComma))
(defrule pNotLpar (! tLpar))

(defrule tAtom (or tIdent tCut tTrue tFail) (:lambda (x) `(atom ,x)))

(defrule pConstant tInt (:lambda (x) `(constant ,x)))



;; revelation: math exprs only appear as the RHS of IS statements


(defrule rule-Expr rule-Additive)

(defrule rule-Additive (or (and rule-Mult tPlus rule-Additive)
                                 (and rule-Mult tMinus rule-Additive)
                                 rule-Mult)
  (:lambda (x)
    (if (and (listp x) (eq '+ (second x)))
        `(+ ,(first x) ,(third x))
      (if (and (listp x) (eq '- (second x)))
        `(- ,(first x) ,(third x))
        x))))

(defrule rule-Mult (or (and rule-Primary tMul rule-Mult)
                             (and rule-Primary tDiv rule-Mult)
                             rule-Primary)
  (:lambda (x)
    (if (and (listp x) (eq '* (second x)))
        `(* ,(first x) ,(third x))
      (if (and (listp x) (eq '/ (second x)))
        `(/ ,(first x) ,(third x))
        x))))

(defrule rule-Primary (or tInt rule-Primary2 tVar)
  (:lambda (x) `(primary ,x)))
(defrule rule-Primary2 (and tLpar rule-Additive tRpar)
  (:function second))

(defrule rule-TOP1-Expr (and (* tWS) rule-Expr)
  (:destructure (spc e) (declare (ignore spc)) e)
  (:lambda (x) `(top-expr ,x)))

(defrule is-predicate (and tVar tIs (or rule-Expr pPredicate))
  (:destructure (v is e) (declare (ignore is)) `(is ,v ,e)))

(defrule GEQ-predicate (and pTerm tGEQ pTerm) (:lambda (x) `(>= ,(first x) ,(third x))))
(defrule LEQ-predicate (and pTerm tLEQ pTerm) (:lambda (x) `(<= ,(first x) ,(third x))))


(defrule rule-TOP1-IS (and (* tWS)  is-predicate )
  (:function second))

(defun test0h ()
  (setf cl:*print-right-margin* 40)

  #+nil(pprint (esrap:parse 'rule-TOP1-IS "X is 1"))
  #+nil(pprint (esrap:parse 'rule-TOP1-IS "X is 1+2"))
  #+nil(pprint (esrap:parse 'rule-TOP1-IS "X is 1 + 2"))

  (pprint (esrap:parse 'rule-TOP1-IS "X is (16 + 17) / (18 - 19)"))

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

  (pprint (esrap:parse 'pRule "x :- namedSource(X)."))
  (pprint (esrap:parse 'pRule "x(X) :- namedSource(X)."))
  (pprint (esrap:parse 'pRule "x :- namedSource(X),dummy(0)."))
  (pprint (esrap:parse 'pRule "x :- namedSource(X),pred(X,Y),dummy(0)."))
  (pprint (esrap:parse 'pRule "a :- atom,pred(X,Y),dummy(0)."))
  (pprint (esrap:parse 'pRule "a :- atom."))
  (pprint (esrap:parse 'pRule "a :- atom,pred(X,Y)."))
  (pprint (esrap:parse 'pRule "a :- atom,pred(X,Y),dummy(0),X is 1."))

  (pprint (esrap:parse 'rule-TOP1 "x :- namedSource(X)."))
  (pprint (esrap:parse 'rule-TOP1 "x(X) :- namedSource(X)."))
  (pprint (esrap:parse 'rule-TOP1 "x :- namedSource(X),dummy(0)."))
  (pprint (esrap:parse 'rule-TOP1 "x :- namedSource(X),pred(X,Y),dummy(0)."))
  (pprint (esrap:parse 'rule-TOP1 "a :- atom,pred(X,Y),dummy(0)."))
  (pprint (esrap:parse 'rule-TOP1 "a :- atom."))
  (pprint (esrap:parse 'rule-TOP1 "a :- atom,pred(X,Y)."))
  (pprint (esrap:parse 'rule-TOP1 "a :- atom,pred(X,Y),dummy(0),X is 1."))

  (pprint (esrap:parse 'rule-TOP1 ":- initialization(main)."))
  (pprint (esrap:parse 'rule-TOP1 ":- include('head')."))
  (pprint (esrap:parse 'rule-TOP1 ":- include('tail')."))

  (pprint (esrap:parse 'rule-TOP1 "ellispse(id391)."))
  (pprint (esrap:parse 'rule-TOP1 "createRectBoundingBox(ID) :-
    geometry_left_x(ID,X)."))
  (pprint (esrap:parse 'rule-TOP1 "createRectBoundingBox(ID) :-
    geometry_left_x(ID,X)."))
  (pprint (esrap:parse 'rule-TOP1 "createRectBoundingBox(ID) :-
    geometry_left_x(ID,X),  Right is X + Width."))
  (pprint (esrap:parse 'rule-TOP "createRectBoundingBox(ID) :-
    geometry_left_x(ID,X),  Right is X + Width."))

  (format *standard-output* "~%")
  (format *standard-output* "~%")
  (format *standard-output* "~%")

  (pprint (esrap:parse 'rule-TOP "createRectBoundingBox(ID) :-
    geometry_left_x(ID,X),  Right is X + Width.
createRectBoundingBox2(ID) :-
    geometry_left_x(ID,X),  Right is X + Width."))

  (format *standard-output* "~%")
  (format *standard-output* "~%")
  (format *standard-output* "~%")

  (pprint (esrap:parse 'rule-TOP *all-prolog*)))

(defun test ()
  (setf cl:*print-right-margin* 40)
  #+nil(pprint (esrap:parse 'rule-TOP
"
:- initialization(main).
:- include('head').

calc_bounds_main :-
    readFB(user_input), 
    createBoundingBoxes,
    writeFB,
    halt.
"))
  #+nil(pprint (esrap:parse 'rule-TOP "createRectBoundingBox(ID) :-
    geometry_left_x(ID,X),  Right is X + Width.
createRectBoundingBox2(ID) :-
    geometry_left_x(ID,X),  Right is X + Width."))
  #+nil(pprint (esrap:parse 'rule-TOP "b(PortLeftX,ELeftX) :- PortLeftX =< ELeftX, PortLeftX >= ELeftX."))
  (let ((final (esrap:parse 'rule-TOP *all-prolog*)))
    final))

