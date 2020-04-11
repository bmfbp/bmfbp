#|

notNamedSource(X) :-
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
  asserta(ident(X)).

|#

(rule (predicate notNamedSouce (argList (var x)))
      (predicateList
       (predicate namedSource (argList (var x)))
       (predicate cut)
       (predicate fail)))

(PREDICATE
 (STRUCTURE
  ((ATOM "namedSource") NIL (TERM-LIST ((TERM "X") NIL)) NIL)))

(rule (predicate chekZero (argList (int 0)))
      (predicateList
       (predicate cut)))

(rule (predicate dummy (argList))
       (predicate forall (argList
                          (predicate ident (argList (var x)))
                          (predicate doident (argList (var X))))))

(rule (predicate dummy2 (argList))
      (predicate retract (argList
                          (predicate ident (argList (var x))))))

(rule (predicate dummy3 (argList))
      (binary is (predicate (var x))
                 (precidate binary plus
                            (var y)
                            (var z))))

(rule (predicate dummy4 (argList))
      (predicate asserta (argList (predicate (var x)))))
                            



(rule (notNamedSouce ((var x)))
      (
       (namedSource ((var x)))
       (cut)
       (fail)
      )
)

(rule ( chekZero (argList (int 0)))
      (
       ( cut)))

(rule ( dummy (argList))
       ( forall (argList
                          ( ident (argList (var x)))
                          ( doident (argList (var X))))))

(rule ( dummy2 (argList))
      ( retract (argList
                          ( ident (argList (var x))))))

(rule ( dummy3 (argList))
      (binary is ( (var x))
                 (precidate binary plus
                            (var y)
                            (var z))))

(rule ( dummy4 (argList))
      ( asserta (argList ( (var x)))))
                            
