(in-package :arrowgrams/compiler/xform)

(esrap:defrule arrowgrams-intermediate-representation
    (and LPAR @self-Part RPAR))


(esrap:defrule @self-Part 
    (and @self-kind @self-inputs @self-outputs @self-wiring))

(esrap:defrule @self-kind IDENT)

(esrap:defrule @self-inputs (and LPAR @pin-list RPAR)
  (:function second))

(esrap:defrule @self-outputs (and LPAR @pin-list RPAR)
  (:function second))

(esrap:defrule @self-wiring (and LPAR @wire-list RPAR)
  (:function second))


(esrap:defrule @wire-list (or @wire @wire-list))

(esrap:defrule @wire (and LPAR @part @pin RPAR)
  (:destructure (lp part pin rp)
		(declare (ignore lp rp))
		(list part pin)))
  
(esrap:defrule @pin-list (or @pin @pin-list))

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

(esrap:defrule RPAR (and #\( (* WS))
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

  
