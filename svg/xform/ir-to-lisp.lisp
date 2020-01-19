(in-package :arrowgrams/compiler/xform)

(esrap:defrule ir-to-lisp-grammar
    (and (* WS) LPAR <xself-Part> RPAR <end-of-input>)
  (:function third))

(esrap:defrule <xself-Part> 
    (and <xself-kind> <xself-inputs> <xself-outputs> <xreact-function> <xfirst-time-function> <xself-part-decls> <xself-wiring>)
  (:destructure (kind inputs outputs react first-time parts wiring)
		(declare (ignore kind react first-time))
		(list inputs outputs parts wiring)))


(esrap:defrule <xself-kind> IDENT)

(esrap:defrule <xself-inputs> <xinputs>)

(esrap:defrule <xself-outputs> <xoutputs>)

(esrap:defrule <xself-wiring> (and LPAR (* <xwire>) RPAR)
  (:function second))

(esrap:defrule <xself-part-decls> (and LPAR (* <xpart-decl>) RPAR))


(esrap:defrule <xwire> (and LPAR <xwire-id> <xfroms> <xtos> RPAR)
  (:destructure (lp wire-id froms tos rp)
		(declare (ignore lp rp))
		(list wire-id froms tos)))

(esrap:defrule <xwire-id> (or IDENT <INTEGER>))
(esrap:defrule <xfroms> (and LPAR (* <xpart-pin>) RPAR))
(esrap:defrule <xtos> (and LPAR (* <xpart-pin>) RPAR))

(esrap:defrule <xpart-pin> (and LPAR <xpart-id-or-self> <xpin-id> RPAR))

(esrap:defrule <xpart-decl> (and LPAR <xid> <xkind> <xinputs> <xoutputs> <xreact-function> <xfirst-time-function> RPAR))

(esrap:defrule <xid> IDENT)

(esrap:defrule <xkind> IDENT)

(esrap:defrule <xinputs> (or <nil> <xpin-list>))

(esrap:defrule <xpin-list> (and LPAR (* <xpin-id>) RPAR)
  (:function second))

(esrap:defrule <xoutputs> (and LPAR (* <xpin-id>) RPAR)
  (:function second))


(esrap:defrule <xpart-id-or-self> (or <xpart-id> <xself-keyword>))

(esrap:defrule <xreact-function> IDENT)
(esrap:defrule <xfirst-time-function> IDENT)
(esrap:defrule <xpart-id> IDENT)
(esrap:defrule <xpin-id> IDENT)
