(in-package :arrowgrams/parser)

(defconstant +low-level-grammar+
"

tDot <- '.' tWS*
tComma <- ',' tWS*
tLpar <- '(' tWS*
tRpar <- ')' tWS*
tInt <- [0-9]+ tWS*
tVar <- [A-Z_] [A-Za-z0-9]*
tAtom <- tLowerCaseIdent / tSingleQuotedAtom
tColonDash <- ':' '-' tWS*
tLowerCaseIdent <- [a-z][A-Za-z0-9_]*
tSingleQuotedAtom <- ['] .* [']

tWS <- tComment / tWhiteSpace / tEndOfLine
tComment <- '%' .* tEndOfLine
tWhiteSpace <- ' ' / '\\t'
tEndOfLine <- '\\r\\n' / '\\n' / '\\r'
"
)

(defrule tWS (or tComment tWhiteSpace tEndOfLine))
(defrule tComment (and #\% (* character) tEndOfLine))
(defrule tEndOfLine (or #\Newline #\Return))
(defrule tWhiteSpace (or #\Space #\Tab))

(defrule tDot (and "." (* tWS)))
(defrule tComma (and "," (* tWS)))
(defrule tLpar (and "(" (* tWS)))
(defrule tRpar (and ")" (* tWS)))

(defrule tInt (+ (character-ranges (#\0 #\9)))
  (:text t) (:function parse-integer))

(defrule tVar (or tDontCare tNamedVar))

(defrule tNamedVar (and tCapitalLetter (* tOtherLetter))
  (:text t))

(defrule tSingleQuotedAtom (and #\' (+ tNotSquote) #\')
  (:text t))

(defrule tNotSquote (and (! #\') character))

(defrule tIdent (and tLowerCaseLetter (* tOtherLetter))
  (:text t))

(defrule tDontCare "_" (:text t))

(defrule tCapitalLetter (character-ranges (#\A #\Z)))
(defrule tLowerCaseLetter (character-ranges (#\a #\z)))
(defrule tOtherLetter (or (character-ranges (#\A #\Z))
                          (character-ranges (#\a #\z))
                          (character-ranges (#\0 #\9))
                          "_"))

(defun ll-test ()
  (pprint (parse 'tDot "."))
  (pprint (parse 'tComma ","))
  (pprint (parse 'tLpar "("))
  (pprint (parse 'tRpar ")"))
  (pprint (parse 'tInt "0123456789"))
  (pprint (parse 'tVar "Abc"))
  (pprint (parse 'tVar "_"))
  (pprint (parse 'tIdent "aBCdef"))
  (pprint (parse 'tIdent "aBCdef"))
  (pprint (parse 'tSingleQuotedAtom "'gh i '")))
