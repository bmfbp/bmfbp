(in-package :arrowgrams/parser)

(defconstant +prolog-grammar+
"
pClause <- pPredicate tDot / pPredict tColonDash tDot
pPredicateList <- pPredicate / pPredicate tComma pPredicateList
pPredicate <- pAtom / pStructure
pStructure <- pAtom tLpar tRpar / pAtom tLpar pTermList tRpar
pTermList <- pTerm / pTerm tComma pTermList
pTerm <- pConstant / tAtom / tVar / pStructure
pConstant <- tInt
")

#|
(defrule pClause (or (and pPredicate tDot) (and pPredicate tColonDash tDot)))
(defrule pPredicateList (or pPredicate (and pPredicate tComma pPredicateList)))
(defrule pPredicate (or tAtom pStructure))
|#

(defrule pStructure (or (and tAtom tLpar tRpar)
                        (and tAtom tLpar pTermList tRpar)))
(defrule pTermList (or (and pTerm
                       (and pTerm tComma pTermList))))

(defrule pTermList (and (* pTermComma) pTerm))
       
(defrule pTermComma (and pTerm tComma))

(defrule pTerm (or
                pConstant
                ;(and tIdent (! #\())
                (and tAtom (! #\())
                tSingleQuotedAtom
                tVar
                pStructure))

(defrule tAtom tIdent)

(defrule pConstant tInt)

(defun test ()
  (pprint (parse 'tComma ","))
  (pprint (parse 'pTermList "d"))
  (pprint (parse 'pTermList "a,f"))
  (pprint (parse 'pTermList "port,floor"))
  (pprint (parse 'pTermList "port(id391),floor(id391,0)"))
  (pprint (parse 'pTermList "port(id391),floor(id391,Var)")))
