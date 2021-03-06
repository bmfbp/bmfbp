(in-package :arrowgrams/parser)

(defparameter *str1*
"
nle :- nl(user_error).
")

(defparameter *str2*
"
we(X) :- write(user_error,X).
")

(defparameter *str3*
"
condRect :-
    forall(rect(ID), createRectBoundingBox(ID)).
")

(defparameter *str4*
"
notNamedSource(X) :-
    namedSource(X),
    !,
    true,
    fail.
")

(defparameter *str5*
"
notNamedSource(X) :-
    asserta(log(BoxID,box_is_meta_data)),
    retract(rect(BoxID)).
")

(defparameter *str6*
"
sem_speechVScomments_main :-
    readFB(user_input),
    g_assign(counter,0),
% pt
    forall(speechbubble(ID),inc(counter,_)),
% pt
    forall(comment(ID),dec(counter,_)),
    g_read(counter,Counter),
    checkZero(Counter),
    writeFB,
    halt.
")

(defparameter *str7*
"
sem_speechVScomments_main :-
    g_assign(counter,0),
    prolog_not_equal(Kind1,Kind2),
    prolog_not_equal_equal(Kind1,Kind2).
")

(defparameter *str8*
"
x :-    
     Left is CX - HalfWidth,
     L1 >= L2.
")

(defparameter *str9*
  "
x :-
    prolog_not_proven(namedSink(X)),
    prolog_not_proven(used(TextID)),
    prolog_not_proven(used(TextID)).
")

(defparameter *str10*
"
a :-    
     Left is (CX - HalfWidth).
b :-    
     Left is CX - HalfWidth.
")

(defparameter *str11*
"
collect_distances :-
wen('a'),
  text(TextID,StrID),
wen('b'),
  unassigned(TextID),
wen('c'),
  lisp_collect_begin,
wen('d'),
wen('e'),
  join_distance(PortID,TextID),
  distance_xy(JoinID,Distance),
  join_centerPair(PortID,JoinID),
  lisp_collect_distance(TextId,StrID,PortID,Distance),
  fail.
collect_distances :-
  lisp_collect_finalize,
  TextID is lisp_return_closest_text,
  PortID is lisp_return_closest_port,
  StrID is  lisp_return_closest_string,
  XX is sqrt(YY),
  XX is abs(YY),
  asserta(portNameByID(PortID,TextID)),
  asserta(portName(PortID,StrID)).
")

(defun test ()
  ;(let ((tree (esrap:parse 'rule-TOP *all-prolog*)))
  (let ((tree (esrap:parse 'rule-TOP *str11*)))
    (let ((converted1 (convert tree)))
      (let ((converted2 (if *foralls* (cons *foralls* converted1) converted1)))
        (pprint converted2)))
    'done))
