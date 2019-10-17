# working on (prolog::test4)



current usage (while debugging)

    lisp> (ql:quickload :arrowgram/prolog-grammar)
    lisp> (in-package :prolog)
    lisp> (esrap:trace-rule 'prolog::PrologProgram :recursive t) ;; this line shows what the parser is thinking
    ;; pperiod 39? says that the parser is trying the rule pPeriod at position 39
    ;; pperiod -|  says that the parser failed to find a pPeriod here
    ;; pcall 33-38 -> (TRUE) says that the parser found a pCall in positions 33-39 and show what is being returned
    lisp> (test8)

working up to test8 (meaning that test8 appears to produce valid Lisp given the Prolog clauses that it parses)

The best way to think about this is:

CL-PEG creates a SED script that is more powerful than SED - the Parsing Expression Grammar is much like regexp, except that it can match across newlines (see spacing-peg.lisp if you really want to see how it lumps newlines into whitespace (not a necessary exercise)).

Hence, PEG, can parse "structured" programs, where "structuring" happens across lines (if desired).

Hence, this PEG script (much like a SED script) can match valid Prolog, and, then (later) can convert the matched stuff into valid Lisp.

Most of this replacement isn't done yet - the first test is to simply create a grammar (SED-like script) that can survive matching everything in all.pl.

It is possible to write an anal-retentive Prolog grammar that rejects invalid Prolog code...

...BUT...

In this case we know that we are parsing valid Prolog - it works with gprolog.  So, we can cut some corners and write a "sloppier" parser (SED-like script).  For example, we know that there are no FLOATs in all.pl, hence, we can cut corners in number-peg.lisp and match only integers.  Other bits of slop are harder to identify (e.g. pIsExpr is composed of 2 different patterns), but we can get away with them because we know that the code already passes through an anal-retentive prolog parser (e.g. gprolog).

FYI - once a pattern has been matched, we used ESRAP operators like :lambda and :destructure to manipulate matched phrases.  Idiom: (:lambda (x) (declare (ignore x))) is often used to return "nothing" (NIL) - the act of simply matching something (like an operator "+") is good enough.  I've split the matching rules up into pieces that make it "obvious" what should be returned.

NB. ESRAP creates a list where multiple matches are possible, e.g. the use of * and + matching operators.  One can disassemble and observe ESRAP's return values by turning on esrap:trace-rule  


NEXT STEPS:  
(1) Add tests until all of the constructs of all.pl are successfully matched.  
(2) Then add :destructure operators to the code to build up valid Lisp sequences on successful matches.


TRICKS:

- When ESRAP gives an error, it provides a Position NNNN.  Use EMACS to see the line - position the cursor on the first char of the string (e.g.
(defun test11 ()
  (pprint (esrap:parse 'prolog::PrologProgram
               " 
                ^ here) and hit ^U NNNN ^F (NNNN forward-chars).



# Dependencies
Things not in Quicklisp, but referred to in ASDF files. 
## CL-PEG

<git+https://github.com/guitarvydas/cl-peg>
