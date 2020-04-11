"
pClause <- pPredicate tDot / pPredict tColonDash tDot
pPredicateList <- pPredicate / pPredicate tComma pPredicateList
pPredicate <- pAtom / pStructure
pStructure <- pAtom tLpar tRpar / pAtom tLpar pTermList tRpar
pTermList <- pTerm / pTerm tComma pTermList
pTerm <- pConstant / tAtom / tVar / pStructure
pConstant <- tInt


tDot <- '.' tWS*
tLpar <- '(' tWS*
tRpar <- ')' tWS*
tInt <- [0-9]+ tWS*
tVar <- [A-Z_] [A-Za-z0-9]*
tAtom <- tLowerCaseIdent / tSingleQuotedAtom
tLowerCaseIdent <- [a-z][A-Za-z0-9_]*
tSingleQuotedAtom <- ['] .* [']
tWS <- ' '
