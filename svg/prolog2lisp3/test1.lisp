(in-package :arrowgrams/parser)

(defparameter *test1*
"
rect(id1).

findrects(ID) :- rect(ID),fail.
findrects(_).

printAll :- findrects(ID),we('rect '),wen(ID).

we(WE_ARG) :- write(user_output,WE_ARG).
wen(WEN_arg):- we(WEN_arg),nle.
).
")


