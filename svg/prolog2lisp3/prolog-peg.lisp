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

(defun test0d ()
  (pprint (esrap:parse 'pRule "notNamedSource(X):- namedSource(S),!,fail.")))


(defun test0c ()
  (pprint (esrap:parse 'pRule "dummy:-namedSource(X),namedSource(0),!,fail."))
  (pprint (esrap:parse 'pRule "dummy(X):-namedSource(X),namedSource(0),!,fail.")))

(defun test0b ()
  (pprint (esrap:parse 'pPredicate "namedSource(X)"))
  (pprint (esrap:parse 'pPredicate "namedSource(0)"))
  (pprint (esrap:parse 'pPredicateList "namedSource(X),namedSource(0)"))
  (pprint (esrap:parse 'pPredicateList "namedSource(X),namedSource(0),!,fail"))
  (pprint (esrap:parse 'pRule "dummy:-namedSource(X),namedSource(0),!,fail.")))

(defun old-test ()
  (pprint (parse 'tComma ","))
  (pprint (parse 'pTermList "d"))
  (pprint (parse 'pTermList "a,f"))
  (pprint (parse 'pTermList "port,floor"))
  (pprint (parse 'pTermList "port(id391),floor(id391,0)"))
  (pprint (parse 'pTermList "port(id391),floor(id391,Var)")))

(defun test0a ()
  (pprint (parse 'pTermList "namedSource(X)"))
  (pprint (parse 'pTermList "!"))
  (pprint (parse 'pTermList "true"))
  (pprint (parse 'pTermList "fail"))
  (pprint (parse 'pTermList "!,fail"))
  (pprint (parse 'pTermList "fail,!"))
  (pprint (parse 'pTermList "namedSource(X),!,fail")))

(defun test0 ()
  (pprint (esrap:parse 'pTermList  "namedSource(X),!,fail.")))

(defun test2 ()
"notNamedSource(X) :-
    namedSource(X),
    !,
    fail.
checkZero(0) :- !.
dummy :-
  forall(ident(X),doident(X)).
dummy2 :-
  retract(ident(X)).
dummy3 :-
  X is Y + Z.
dummy4 :-
  asserta(ident(X)).")


#|
 Ford's thesis page 22
E <- N
   / '(' E '+' E ')'
   / '(' E '-' E ')'
N <- D N
   / D
D <- '0' | ... | ''9'
|#

(esrap:defrule is-Statement (and tVar tIs rule-Expr))

(esrap:defrule rule-Expr rule-Additive)

(esrap:defrule rule-Additive (or (and rule-Mult tPlus rule-Additive)
                                 (and rule-Mult tMinus rule-Additive)
                                 rule-Mult)
  (:lambda (x) (delete nil x))
  (:lambda (x)
    `(additive ,x)))

(esrap:defrule rule-Mult (or (and rule-Primary tMul rule-Mult)
                             (and rule-Primary tDiv rule-Mult)
                             rule-Primary)
  (:lambda (x) (delete nil x))
  (:lambda (x)
    `(multiplicative ,x)))

(esrap:defrule rule-Primary (or tInt
                                (and tLpar rule-Additive tRpar))
  (:lambda (x) (delete nil x))
  (:lambda (x)
    `(primary ,x)))



(esrap:defrule rule-TOP-Expr (and (* tWS) rule-Expr))

(defun test0f ()
  (pprint (parse 'rule-Expr "2"))
  (pprint (parse 'rule-Expr "2+3"))
  (pprint (parse 'rule-Expr "2+3-4"))
  (pprint (parse 'rule-Expr "2+3-4*5"))
  (pprint (parse 'rule-Expr "2+3-4*5/6"))
  (pprint (parse 'rule-Expr "2+3-4*5/6+(2+2)"))
  (pprint (parse 'rule-Expr "234"))
  (pprint (parse 'is-Statement "X is 234"))
  (pprint (parse 'rule-Expr "2+3-4*5/6+(2+2)")))



(defrule rule-TOP (and (* tWS) rule-Top-Expr ))
(defun test ()
  (pprint (parse 'rule-TOP-Expr " 2 + 3 - 4 * 5 / 6 + ( 2 + 2 )"))
  (pprint (parse 'rule-TOP " 2 + 3 - 4 * 5 / 6 + ( 2 + 2 )")))
  ;(pprint (parse 'rule-TOP "X is 234,computeWith(X)")))




#|
TODO
x 1. ws
2. tie is and expr into predicate? Thinking about term-list and how IS fits in.

|#