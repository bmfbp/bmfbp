(in-package :prolog)

(defun test1 ()
  (esrap:parse 'prolog::PrologProgram "x(y)."))

(defun test2 ()
  (esrap:parse 'prolog::PrologProgram "x(y). a(b)."))

(defun test3 ()
  (esrap:parse 'prolog::PrologProgram "x(Y) :- a(Y)."))

(defun test4 ()
  (esrap:parse 'prolog::PrologProgram "x(Y) :- a(Y),b(Y)."))

(defun test5 ()
  (esrap:parse 'prolog::PrologProgram "x(Y,Z) :- a(Y),b(Z)."))

(defun test6 ()
  (esrap:parse 'prolog::PrologProgram "x(Y,Z) :- a(Y,Z),b(Y,Z)."))

(defun test7 ()
  (esrap:parse 'prolog::PrologProgram "x(Y,Z) :- a(Y,Z,1),b(Y,Z,2)."))

(defun test8 ()
  (esrap:parse 'prolog::PrologProgram
               "
findCoincidentSource(_,_):-
    true.
"))

;; (esrap:trace-rule 'prolog::PrologProgram :recursive t)

#|
notNamedSource(X) :-
    \+ namedSource(X)\.

closeTogether(X,Y):-
    Delta is X - Y,
    Abs is abs(Delta),
    20 >= Abs\.

closeTogether(_,_) :- 
    fail\.
")
|#
