See sample.lisp (main) for an example of working queries.  This solution uses special variables and needs to be changed.

See the earlier commit of sample.lisp to see the starting point and a version that did not work. 

The code in (ql:quickload :paiprolog) is a modified form of PAIP Prolog.  AFAICT, the modifications are not documented.  There are changes in prolog-ext.lisp and prologc.lisp (at the least).


At present, it seems that paiprolog:prolog-collect must use hard-coded expressions that cannot be parameterized easily.

What is desired is a form of the macro "paiprolog:prolog-collect" that can be parameterized.

I haven't tried the "paiprolog:?-" (query) operator.

FYI: The "paiprolog:<-" operator creates a prolog rule.  The first sexpr is the HEAD (the declaration of the rule) and the rest of the sexprs are the body of the rule.  If there is no body, then it is a simple Prolog assertion (aka fact).

FYI: "paiprolog:<--" is the same as "paiprolog:<-", except that it wipes any rules associated with the rule.

FYI: "paiprolog::*db-predicates*" is a list of symbols that are rules (and/or facts).  GET (plist access) is used to fetch the set of rules associated with that symbol.

For example, in sample.lisp / main(), I use <- to create 2 sets of facts, for "rect" and for "geometry-left-x".  I use "paiprolog::clear-db" at the beginning of each run, so I never need to use "paiprolog:<--".

The first query for all-rules, uses a hard-coded expression in "paiprolog:prolog-collect", so it is not a problem.

The second query happens in the mapcar. -- It seems -- that the only way to parameterize that second query is to use the special variable *id*.  The first line in the mapcar -- (paiprolog::lisp ?id *id*) -- assigns *id* to the Prolog variable ?id.  "Paiprolog::lisp" is defined in prologc.lisp (and the original Norvig implementation is commented out above it).

