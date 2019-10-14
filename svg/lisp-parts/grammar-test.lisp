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

notNamedSource(X) :-
    \+ namedSource(X).

closeTogether(X,Y):-
    Delta is X - Y,
    Abs is abs(Delta),
    Abs =< 20.

closeTogether(_,_) :- 
    fail.
"))


(defun test9 ()
  (pprint (esrap:parse 'prolog::PrologProgram
               "
% a comment
test(X) :-
fun(X),
true,
fail,
!,
halt,
asserta(log(coincidentsource,A,B,N)),
retract(log(conincidentsource,A,B,N)),
\\+ fun(X),
\\+ true,
readFB(user_input),
writeFB,
forall(rect(ID), createRectBoundingBox(ID)),
A \\== B,
A == B,
A \\= B,
A = B,
123.
"))
T)

;; (esrap:trace-rule 'prolog::PrologProgram :recursive t)


