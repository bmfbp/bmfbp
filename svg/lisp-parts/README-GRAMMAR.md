current usage (while debugging)

lisp> (ql:quickload :arrowgram/prolog-grammar)
lisp> (in-package :prolog)
lisp> (esrap:trace-rule 'prolog::PrologProgram :recursive t) ;; this line shows what the parser is thinking
;; pperiod 39? says that the parser is trying the rule pPeriod at position 39
;; pperiod -|  says that the parser failed to find a pPeriod here
;; pcall 33-39 -> (TRUE.) says that the parser found a pCall in positions 33-39 and show what is being returned
;;;; ^ that's wrong, btw, pCall should fail and should not consume the . (the expression is TRUE, not a pCall)
lisp> (test8)
