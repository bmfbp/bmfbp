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

(defrule tWS (or tComment tWhiteSpace tEndOfLine) (:constant :ws))
(defrule tJunk-to-eol (and (* character) (or tEndOfLine tEOF)) (:constant :junk))
(defrule tComment (and #\% (* character) (or tEndOfLine tEOF)))
(defrule tEOF (! character))
(defrule tEndOfLine (or #\Newline #\Return))
(defrule tWhiteSpace (or #\Space #\Tab))

(defrule tColonDash (and #\: #\- (* tWS)) (:constant 'ColonDash))
(defrule tDot (and "." (* tWS)) (:constant #\.))
(defrule tComma (and "," (* tWS)) (:constant #\,))
(defrule tLpar (and "(" (* tWS)) (:constant #\())
(defrule tRpar (and ")" (* tWS)) (:constant #\)))
(defrule tPlus (and "+" (* tWS)) (:constant '+))
(defrule tMinus (and "-" (* tWS)) (:constant '-))
(defrule tMul (and "*" (* tWS)) (:constant '*))
(defrule tDiv (and "/" (* tWS)) (:constant '/))

(defrule tCut (and "!" (* tWS)) (:constant 'cut))
(defrule tTrue (and "true" (* tWS)) (:constant 'true))
(defrule tFail (and "fail" (* tWS)) (:constant 'fail))

(defrule tIs (and "is" (* tWS)) (:constant 'is))



(defrule tNamedVar (and tCapitalLetter (* tOtherLetter))
  (:text t))

(defrule tSingleQuotedAtom (and #\' (+ tNotSquote) #\')
  (:text t))

(defrule tNotSquote (and (! #\') character))

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
