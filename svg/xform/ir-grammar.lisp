(in-package :arrowgrams/compiler/xform)

(esrap:defrule arrowgrams-intermediate-representation
    (and LPAR @self-Part RPAR))

(esrap:defrule @self-Part 
    (and @self-kind @self-inputs @self-outputs @self-part-decls @self-wiring))

(esrap:defrule @self-kind IDENT)

(esrap:defrule @self-inputs @inputs)

(esrap:defrule @self-outputs @outputs)

(esrap:defrule @self-wiring (and LPAR (* @wire) RPAR)
  (:function second))

(esrap:defrule @self-part-decls <- LPAR (* part-decl) RPAR)


(esrap:defrule @wire (and LPAR @part @pin RPAR)
  (:destructure (lp part pin rp)
		(declare (ignore lp rp))
		(list part pin)))


(esrap:defrule @part-decl <- LPAR @id @kind @inputs @outputs RPAR)

(esrap:defrule @id <- IDENT)

(esrap:defrule @kind <- IDENT)

(esrap:defrule @inputs (and LPAR (* @pin) RPAR)
  (:function second))

(esrap:defrule @outputs (and LPAR (* @pin) RPAR)
  (:function second))


(esrap:defrule @part IDENT)
(esrap:defrule @pin IDENT)
  

  





(esrap:defrule IDENT (and STRING (* WS))
  (:function first))

(esrap:defrule STRING (and #\" (* @not-dquote) #\")
  (:function second)
  (:text t))

(esrap:defrule @not-dquote (and (esrap:! #\") character)
  (:function second))

  
(esrap:defrule LPAR (and #\( (* WS))
  (:constant #\())

(esrap:defrule RPAR (and #\) (* WS))
  (:constant #\)))

(esrap:defrule WS (or #\Space #\Tab #\Newline COMMENT-TO-EOL EOF)
  (:constant #\Space))

(esrap:defrule COMMENT-TO-EOL
    (and #\; (* character) (or EOL EOF))
  (:constant :COMMENT))

(esrap:defrule EOL #\Newline
  (:constant :NL))

(esrap:defrule EOF (and (esrap:! character))
  (:constant :EOF))

  
