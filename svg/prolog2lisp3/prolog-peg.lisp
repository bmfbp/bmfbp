(in-package :arrowgrams/parser)

(defconstant +prolog-grammar+
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

(defrule pPredicateList (or (and pPredicate (! tComma))
                            (and pPredicate tComma pPredicateList))
  (:lambda (x) `(predicate-list ,(delete nil x))))

(defrule pPredicate (or (and tAtom (! tLpar))
                        pStructure)
  (:lambda (x) `(predicate ,(delete nil x))))

(defrule pStructure (or (and tAtom tLpar tRpar)
                        (and tAtom tLpar pTermList tRpar))
  (:lambda (y)
    (let ((x (delete nil y)))
      (assert (and (listp x)
                   (= 2 (length x)))) ;; dummy(X,Y) => (struct (atom (ident "dummy")) (term-list ???
      `(structure ,(first x) ,(second x)))))

(defrule pTermList (or (and pTerm (! tComma))
                       (and pTerm tComma pTermList))
  (:lambda (x) `(term-list ,(delete nil x))))


(defrule pTerm (or
                pConstant
                (and tAtom (! #\())
                tSingleQuotedAtom
                tVar
                pStructure)
  (:lambda (x) `(term ,x)))

(defrule tAtom (or tIdent tCut tTrue tFail) (:lambda (x) `(atom ,x)))

(defrule pConstant tInt (:lambda (x) `(constant ,x)))

(defun test ()
  (pprint (esrap:parse 'pRule "notNamedSource(X):- namedSource(S),!,fail."))
  (pprint (esrap:parse 'pRule "checkZero(X):-!."))
  (pprint (esrap:parse 'pRule "dummy(Y):-forall(ident(X),doident(X,Y))."))
  (pprint (esrap:parse 'pRule "dummy2:-rectract(ident(X)).")))

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
