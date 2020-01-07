(in-package :arrowgrams/parser)

(defparameter *test1*
"
findrects(ID) :- rect(ID),we('rect '),wen(ID),fail.
findrects(_).

printAll :- findrects(ID),we('printall '),wen(ID).

we(WE_ARG) :- write(user_output,WE_ARG).
wen(WEN_arg):- we(WEN_arg),nle.
nle :- nl(user_output).
")



