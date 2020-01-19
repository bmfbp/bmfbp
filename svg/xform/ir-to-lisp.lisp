(in-package :arrowgrams/compiler/xform)

(esrap:defrule ir-to-lisp-grammar
    (and (* WS) LPAR <i2l-self-Part> RPAR <end-of-input>)
  (:destructure (ws lp self-part rp eoi)
   (declare (ignore ws lp rp eoi))
   self-part))

(esrap:defrule <i2l-self-Part> 
    (and <i2l-self-kind> <i2l-self-inputs> <i2l-self-outputs> <i2l-react-function> <i2l-first-time-function> <i2l-self-part-decls> <i2l-self-wiring>))

(esrap:defrule <i2l-self-kind> IDENT)

(esrap:defrule <i2l-self-inputs> <i2l-inputs>)

(esrap:defrule <i2l-self-outputs> <i2l-outputs>)

(esrap:defrule <i2l-self-wiring> (and LPAR (* <i2l-wire>) RPAR)
  (:function second))

(esrap:defrule <i2l-self-part-decls> (and LPAR (* <i2l-part-decl>) RPAR)
  (:function second))

(esrap:defrule <i2l-wire> (and LPAR <i2l-wire-id> <i2l-froms> <i2l-tos> RPAR)
  (:destructure 
   (lp wire-id froms tos rp)
   (declare (ignore wire-id lp rp))
   (list froms tos)))

(esrap:defrule <i2l-wire-id> (or IDENT <INTEGER>))

(esrap:defrule <i2l-froms> (and LPAR (* <i2l-part-pin>) RPAR)
  (:function second))

(esrap:defrule <i2l-tos> (and LPAR (* <i2l-part-pin>) RPAR)
  (:function second))

(esrap:defrule <i2l-part-pin> (and LPAR <i2l-part-id-or-self> <i2l-pin-id> RPAR)
  (:destructure (lp part pin rp)
   (declare (ignore lp rp))
   (list (convert-to-symbol part) pin)))

(esrap:defrule <i2l-part-decl> (and LPAR <i2l-id> <i2l-kind> <i2l-inputs> <i2l-outputs> <i2l-react-function> <i2l-first-time-function> RPAR)
  (:destructure (lp id kind inputs outputs react first-time rp)
   (declare (ignore lp rp kind))
   (list (convert-to-symbol id) inputs outputs react first-time)))

(defun convert-to-symbol (x) (if (string= "self" x)
				 :self
				 (intern (string-upcase x))))

(esrap:defrule <i2l-id> IDENT)

(esrap:defrule <i2l-kind> IDENT)

(esrap:defrule <i2l-inputs> (or <i2l-empty-list> <i2l-nil-keyword> <i2l-pin-id-list>))

(esrap:defrule <i2l-pin-id-list> (and LPAR (* <i2l-pin-id>) RPAR)
  (:function second))

(esrap:defrule <i2l-empty-list> (and LPAR RPAR) (:constant :empty-list))

(esrap:defrule <i2l-outputs> (or <i2l-nil-keyword> (and LPAR (* <i2l-pin-id>) RPAR))
  (:function second))


(esrap:defrule <i2l-part-id-or-self> (or <i2l-part-id> <i2l-self-keyword>))

(esrap:defrule <i2l-react-function> IDENT)
(esrap:defrule <i2l-first-time-function> IDENT)
(esrap:defrule <i2l-part-id> IDENT)
(esrap:defrule <i2l-pin-id> IDENT)
  

  

(esrap:defrule <i2l-self-keyword>  (and "self" (* WS)))
(esrap:defrule <i2l-nil-keyword>  (and (or "nil" "NIL") (* WS)))




