(in-package :arrowgrams/compiler/xform)

(esrap:defrule arrowgrams-intermediate-representation
    (and LPAR @self-Part RPAR <end-of-input>))

(esrap:defrule @self-Part 
    (and @self-kind @self-inputs @self-outputs @self-part-decls @self-wiring))

(esrap:defrule @self-kind IDENT)

(esrap:defrule @self-inputs @inputs)

(esrap:defrule @self-outputs @outputs)

(esrap:defrule @self-wiring (and LPAR WIRES (* @wire) RPAR)
  (:function second))

(esrap:defrule @self-part-decls (and LPAR PARTS (* @part-decl) RPAR))


(esrap:defrule @wire (and LPAR @part @pin RPAR)
  (:destructure (lp part pin rp)
		(declare (ignore lp rp))
		(list part pin)))


(esrap:defrule @part-decl (and LPAR @id @kind @inputs @outputs RPAR))

(esrap:defrule @id IDENT)

(esrap:defrule @kind IDENT)

(esrap:defrule @inputs (and LPAR (* @pin) RPAR)
  (:function second))

(esrap:defrule @outputs (and LPAR (* @pin) RPAR)
  (:function second))


(esrap:defrule @part IDENT)
(esrap:defrule @pin IDENT)
  

  

(esrap:defrule PARTS (and 'parts' (* WS)))
(esrap:defrule WIRES (and 'wires' (* WS)))




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

(esrap:defrule WS (or <white-space> <comment>))

(esrap:defrule <white-space> (or #\Space #\Tab #\Newline #\Page)
  (:constant #\Space))



(esrap:defrule <comment> (and #\; <same-line>)
  (:function second))


;; from https://github.com/scymtym/parser.common-rules

(esrap:defrule <end-of-input>
    (esrap::! character)
  (:constant :EOF))

(esrap:defrule <end-of-line>
    (or (esrap::& (or #\Newline #\Page)) <end-of-input>)
  (:constant :EOL))

(esrap:defrule <same-line>
    (* (not (or #\Newline #\Page)))
  (:text t))

  
