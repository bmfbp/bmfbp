(in-package :arrowgrams/compiler/xform)

(esrap:defrule ir-to-lisp-grammar
    (and (* WS) LPAR {self-Part} RPAR <end-of-input>)
  (:function third))

(esrap:defrule {self-Part}
    (and {self-kind} {self-inputs} {self-outputs} {react-function} {first-time-function} {self-part-decls} {self-wiring})
  (:destructure (kind inputs outputs react first-time parts wiring)
		(declare (ignore kind react first-time))
		(list inputs outputs parts wiring)))


(esrap:defrule {self-kind} IDENT)

(esrap:defrule {self-inputs} {inputs})

(esrap:defrule {self-outputs} {outputs})

(esrap:defrule {self-wiring} (and LPAR (* {wire}) RPAR)
  (:function second))

(esrap:defrule {self-part-decls} (and LPAR (* {part-decl}) RPAR))


(esrap:defrule {wire} (and LPAR {wire-id} {froms} {tos} RPAR)
  (:destructure (lp wire-id froms tos rp)
		(declare (ignore lp rp))
		(list wire-id froms tos)))

(esrap:defrule {wire-id} (or IDENT <INTEGER>))

(esrap:defrule {froms} (and LPAR (* {part-pin}) RPAR)
  (:function second))
  
(esrap:defrule {tos} (and LPAR (* {part-pin}) RPAR)
  (:function second))

(esrap:defrule {part-pin} (and LPAR {part-id-or-self} {pin-id} RPAR)
  (:destructure (lp part pin rp)
		(declare (ignore lp rp))
		(list part pin)))

(esrap:defrule {part-decl} (and LPAR {id} {kind} {inputs} {outputs} {react-function} {first-time-function} RPAR)
  (:destructure (lp id kind inputs outputs react first-time rp)
		(declare (ignore lp kind react first-time rp))
		(let ((ins (if (eq :xxx inputs) 
			       nil
			       inputs))
		      (outs (if (eq :xxx outputs)
				nil
				outputs)))
		(list ':{part-decl} id inputs outputs))))


(esrap:defrule {id} IDENT)

(esrap:defrule {kind} IDENT)

(esrap:defrule {inputs} (or <nil> {pin-list}))

(esrap:defrule {pin-list} (and LPAR (* {pin-id}) RPAR)
  (:function second))

(esrap:defrule {outputs} (or <nil> {pin-list}))


(esrap:defrule {part-id-or-self} (or {part-id} {self-keyword}))

(esrap:defrule {react-function} IDENT)
(esrap:defrule {first-time-function} IDENT)
(esrap:defrule {part-id} IDENT)
(esrap:defrule {pin-id} IDENT)
