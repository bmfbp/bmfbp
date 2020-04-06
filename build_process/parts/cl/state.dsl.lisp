#|

Keyword <- 'inputs' / 'outputs' / 'vars' / 'initially' / 'end' / 'react' / 'machine' / 'on' / 'method' / '$data' / '$pin' / 'if' / 'else' / 'then'

ArrowgramsProgram < - InputDef OutputDef VarDef InitiallyDef ReactDef MethodDef*

InputList <- LBRACKET Ident* RBRACKET
OutputList <- LBRACKET Ident* RBRACKET
VarList <- LBRACKET Ident* RBRACKET

InitiallyDef <- 'initially' Statement* 'end' 'initially'
ReactDef <- 'react' MachineDef 'end' 'react'

MachineDef <- 'machine' StateDef+ 'end' 'machine'

StateDef <- StateName COLON EventHandler+

EventHandler <- 'on' EventName COLON MethodCall+

MethodCall <- Ident Params?

Params <- LPAR Param+ RPAR
Param <- ('$pin' / '$data' / Ident) ws*

Statement <- LBRACE .* RBRACE
MethodDef <- 'method' Statement 'end' 'method'

StateName <- Ident ws*
EventName <- ( Ident / '*') ws*

Ident <- !Keyword [A-Za-z][-A-Za-z0-9]*

LBRACKET <- '[' ws*
RBRACKET <- ']' ws*
LBRACE <- '{' ws*
RBRACE <- '}' ws*
COLON <- ':' ws*

num <- integer ws*
integer <- [0-9]+
ws <- whitespace
whitespace <- (' ' / '\t' / '\n' / '&' / ',' / ';')+


"
inputs: [eof token]
outputs: [out]
vars: []

initially
    state = idle
end initially

react
  machine
    idle : on * : filter-eof($.data)
    wrapping-up : 
      on token : send-token send-eof
  end machine
end react

method filter-eof (token)
  if token.kind == EOF
    -> wrapping-up
  else
    token-to-peer <- token
  end if
end method
"

|#

(defparameter *test-string*
  "
inputs: [eof token]
outputs: [out]
vars: []

initially
    state = idle
end initially

react
  machine
    idle : on * : filter-eof($data)
    wrapping-up : 
      on token : send-token send-eof
  end machine
end react

method filter-eof (token)
  if token.kind == EOF
    -> wrapping-up
  else
    token-to-peer <- token
  end if end method ")

#|

Prog <- .* 'method' Ident Params? Statement+ 'end' 'method' .*

Params <- LPAR Param+ RPAR
Param <- ('$pin' / '$data' / Ident) WhiteSpace*

Statement <- !'end' .*

Ident <- !Keyword [A-Za-z][-A-Za-z0-9]*

LBRACKET <- '[' WhiteSpace*
RBRACKET <- ']' WhiteSpace*
LBRACE <- '{' WhiteSpace*
RBRACE <- '}' WhiteSpace*
COLON <- ':' WhiteSpace*
SAME <- '==' WhiteSpace*

whitespace <- (' ' / '\t' / '\n' / '&' / ',' / ';')+
ENDOFFILE <- !.

|#

#|
(esrap:defrule Prog 
    (and (* Anything) "method" Ident (esrap:? Params) (+ Statement) "end" "method" (* esrap::character) ENDOFFILE))
(esrap:defrule Params (and LPAR (+ Param) RPAR))
(esrap:defrule Param (and (or "$pin" "$data" Ident) (* WhiteSpace)))
(esrap:defrule Statement (and (esrap:! "end") (* esrap::character)))
(esrap:defrule Ident (and (esrap:! Keyword) (esrap::character-ranges #\- (#\A #\Z) (#\a #\z) (#\0 #\9))))
(esrap:defrule Keyword (or "inputs" "outputs" "vars" "initially" "end" "react" "machine" "on" "method" "$data" "$pin" "if" "else" "then"))
(esrap:defrule LBRACKET (and #\[ (* WhiteSpace)))
(esrap:defrule RBRACKET (and #\] (* WhiteSpace)))
(esrap:defrule LBRACE (and #\{ (* WhiteSpace)))
(esrap:defrule RBRACE (and #\} (* WhiteSpace)))
(esrap:defrule COLON (and #\: (* WhiteSpace)))
(esrap:defrule SAME (and "==" (* WhiteSpace)))
(esrap:defrule WhiteSpace (or #\Space #\Tab #\Newline #\& #\, #\;))
(esrap:defrule ENDOFFILE (esrap:! esrap::character))
  
(esrap:defrule Anything (or keyword WhiteSpace esrap::character))

(defun test ()
					;(esrap::clear-rules)
					;(define-rules)
  (esrap:trace-rule 'Prog :recursive t)
  (esrap:parse 'Prog *test-string* :junk-allowed t))
|#

#|
Parens <- '(' Parens ')' / identifier
|#

#|
(esrap:defrule Parens (or (and #\( Parens #\) ) Thing))
(esrap:defrule Thing #\a)

(defun test ()
  ;(esrap:parse 'Parens "a"))
  ;(esrap:parse 'Parens "(a)"))
  ;(esrap:parse 'Parens "((a)")) ;; should fail
  (esrap:parse 'Parens "((a))"))
|#

#|
(esrap:defrule Parens (or (and LPAR Parens RPAR ) Ident))
(esrap:defrule Ident (and IdentFirst (* IdentFollow))) 
(esrap:defrule IdentFirst (and (esrap:! Keyword) (esrap::character-ranges #\- (#\A #\Z) (#\a #\z) (#\0 #\9))))
(esrap:defrule IdentFollow (esrap::character-ranges #\- (#\A #\Z) (#\a #\z) (#\0 #\9)))
(esrap:defrule Keyword (or "inputs" "outputs" "vars" "initially" "end" "react" "machine" "on" "method" "$data" "$pin" "if" "else" "then"))
(esrap:defrule LPAR (and #\( (* WhiteSpace)))
(esrap:defrule RPAR (and #\) (* WhiteSpace)))
(esrap:defrule LBRACKET (and #\[ (* WhiteSpace)))
(esrap:defrule RBRACKET (and #\] (* WhiteSpace)))
(esrap:defrule LBRACE (and #\{ (* WhiteSpace)))
(esrap:defrule RBRACE (and #\} (* WhiteSpace)))
(esrap:defrule COLON (and #\: (* WhiteSpace)))
(esrap:defrule SAME (and "==" (* WhiteSpace)))
(esrap:defrule WhiteSpace (or #\Space #\Tab #\Newline #\& #\, #\;))

(defun test ()
  ;(esrap:parse 'Parens "((aaa))"))
  ;(esrap:parse 'Parens "( ( aaa) ) "))

|#

#|
(esrap:defrule Parens (or (and LPAR Parens RPAR ) Ident))
(esrap:defrule Ident (and IdentFirst (* IdentFollow) (* WhiteSpace)))
(esrap:defrule IdentFirst (and (esrap:! Keyword) (esrap::character-ranges #\- (#\A #\Z) (#\a #\z) (#\0 #\9))))
(esrap:defrule IdentFollow (esrap::character-ranges #\- (#\A #\Z) (#\a #\z) (#\0 #\9)))
(esrap:defrule Keyword (or "inputs" "outputs" "vars" "initially" "end" "react" "machine" "on" "method" "$data" "$pin" "if" "else" "then"))
(esrap:defrule LPAR (and #\( (* WhiteSpace)))
(esrap:defrule RPAR (and #\) (* WhiteSpace)))
(esrap:defrule LBRACKET (and #\[ (* WhiteSpace)))
(esrap:defrule RBRACKET (and #\] (* WhiteSpace)))
(esrap:defrule LBRACE (and #\{ (* WhiteSpace)))
(esrap:defrule RBRACE (and #\} (* WhiteSpace)))
(esrap:defrule COLON (and #\: (* WhiteSpace)))
(esrap:defrule SAME (and "==" (* WhiteSpace)))
(esrap:defrule WhiteSpace (or #\Space #\Tab #\Newline #\& #\, #\;))

(defun test ()
  ;(esrap:parse 'Parens "((aaa))"))
  ;(esrap:parse 'Parens "( ( aaa) ) "))
  ;(esrap:parse 'Parens "( ( aaa ) ) "))
  ;(esrap:parse 'Parens "(;(;aaa;););"))
  (esrap:parse 'Parens "{;{;aaa;};};"))
|#

#|
(esrap:defrule Parens (or (and LBRACE Parens RBRACE ) Ident))
(esrap:defrule Ident (and IdentFirst (* IdentFollow) (* WhiteSpace)))
(esrap:defrule IdentFirst (and (esrap:! Keyword) (esrap::character-ranges #\- (#\A #\Z) (#\a #\z) (#\0 #\9))))
(esrap:defrule IdentFollow (esrap::character-ranges #\- (#\A #\Z) (#\a #\z) (#\0 #\9)))
(esrap:defrule Keyword (or "inputs" "outputs" "vars" "initially" "end" "react" "machine" "on" "method" "$data" "$pin" "if" "else" "then"))
(esrap:defrule LPAR (and #\( (* WhiteSpace)))
(esrap:defrule RPAR (and #\) (* WhiteSpace)))
(esrap:defrule LBRACKET (and #\[ (* WhiteSpace)))
(esrap:defrule RBRACKET (and #\] (* WhiteSpace)))
(esrap:defrule LBRACE (and #\{ (* WhiteSpace)))
(esrap:defrule RBRACE (and #\} (* WhiteSpace)))
(esrap:defrule COLON (and #\: (* WhiteSpace)))
(esrap:defrule SAME (and "==" (* WhiteSpace)))
(esrap:defrule WhiteSpace (or #\Space #\Tab #\Newline #\& #\, #\;))

(defun test ()
  ;(esrap:parse 'Parens "((aaa))"))
  ;(esrap:parse 'Parens "( ( aaa) ) "))
  ;(esrap:parse 'Parens "( ( aaa ) ) "))
  ;(esrap:parse 'Parens "(;(;aaa;););"))
  (esrap:parse 'Parens "{;{;aaa;};};"))
|#

(esrap:defrule Parens (or (and "end" Parens "end" ) Ident))
(esrap:defrule Ident (and IdentFirst (* IdentFollow) (* WhiteSpace)))
(esrap:defrule IdentFirst (and (esrap:! Keyword) (esrap::character-ranges #\- (#\A #\Z) (#\a #\z) (#\0 #\9))))
(esrap:defrule IdentFollow (esrap::character-ranges #\- (#\A #\Z) (#\a #\z) (#\0 #\9)))
(esrap:defrule Keyword (or "inputs" "outputs" "vars" "initially" "end" "react" "machine" "on" "method" "$data" "$pin" "if" "else" "then"))
(esrap:defrule LPAR (and #\( (* WhiteSpace)))
(esrap:defrule RPAR (and #\) (* WhiteSpace)))
(esrap:defrule LBRACKET (and #\[ (* WhiteSpace)))
(esrap:defrule RBRACKET (and #\] (* WhiteSpace)))
(esrap:defrule LBRACE (and #\{ (* WhiteSpace)))
(esrap:defrule RBRACE (and #\} (* WhiteSpace)))
(esrap:defrule COLON (and #\: (* WhiteSpace)))
(esrap:defrule SAME (and "==" (* WhiteSpace)))
(esrap:defrule WhiteSpace (or #\Space #\Tab #\Newline #\& #\, #\;))

(defun test ()
  ;(esrap:parse 'Parens "((aaa))"))
  ;(esrap:parse 'Parens "( ( aaa) ) "))
  ;(esrap:parse 'Parens "( ( aaa ) ) "))
  ;(esrap:parse 'Parens "(;(;aaa;););"))
  (esrap:parse 'Parens "endaaaend")) <--- non-terminal doesn't work

