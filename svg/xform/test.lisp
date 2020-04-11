(in-package :cl-user)

(defun test ()

  (esrap:defrule LPAR (and #\( (* WS)))
  (esrap:defrule RPAR (and #\) (* WS)))
  (esrap:defrule <nil> (and "NIL" (* WS)))
  (esrap:defrule WS #\Space)
  (esrap:defrule STRING (and #\" (* <not-dquote>) #\" (* WS)))
  (esrap:defrule <not-dquote> (and (esrap:! #\") character))
  (esrap:defrule <eof> (esrap:! character))
  
  (esrap:defrule <part> (and <inputs> <outputs>))
  (esrap:defrule <inputs> (or <nil> (and LPAR <pin-list> RPAR)))
  (esrap:defrule <outputs> (or <nil> (and LPAR <pin-list> RPAR)))
  (esrap:defrule <pin-list> (and LPAR STRING RPAR))

  (let ((str-to-be-parsed "((\"abc\"))")
        (str-to-be-parsed1 "((\"abc\")) ((\"ghi\"))")
        (str-to-be-parsed2 "NIL ((\"ghi\"))")
        (str-to-be-parsed3 "((\"ghi\")) NIL")
        )
    (let ((result (esrap:parse '<part> str-to-be-parsed3)))
      result)))
