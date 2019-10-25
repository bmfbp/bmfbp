;(eval-when (:compile-toplevel :load-toplevel :execute)
;  (peg:into-package "PROLOG"))
(eval-when (:compile-toplevel :load-toplevel :execute)
  (peg:into-package "PAIP"))



;; refactored grammar
(defparameter *peg-rules-refactored*
"
pPrimary <- pOpClause / pCut / pNumber / pVariable / pFunctor / pKWID / pIdentifier / pList / pParenthesizedExpr
pParenthesizedExpr <- pLpar pExpr pRpar
pList <- pEmptyList / pCarOnlyList / pOrList
pEmptyList <- pLBrack pRBrack
pCarOnlyList <- pLBrack pCommaSeparatedListOfExpr pRBrack
pOrList <- pLBrack pCommaSeparatedListOfExpr pOrBar pCommaSeparatedListOfExpr pRBrack
pFunctor <- pIdentifier pLpar pCommaSeparatedListOfExpr pRpar
pExpr <- pBoolean
pCommaSeparatedListOfExpr <- (pExpr pComma)* pExpr
pBoolean <- pSum ((pGreaterEqual / pLessEqual / pSame / pNotSame) pSum)*
pSum <- pProduct ((pPlus / pMinus) pProduct)*
pProduct <- pPrimary ((pAsterisk / pSlash) pPrimary)*
pOpClause <- pOpExpr / pUnifyExpr / pIsExpr / pExpr
pOpExpr <- pNot pExpr
pUnifyExpr <- pUnifyExprEQ / pUnifyExprNEQ
pUnifyExprEQ <- pPrimary pUnifySame pPrimary
pUnifyExprNEQ <- pPrimary pNotUnifySame pPrimary
pIsExpr <- pVariable pIs pExpr
pBinaryOp <- pIs / pNotSame / pSame / pUnifySame / pNotUnifySame / pGreaterEqual / pLessEqual
pFact <- pFunctor Spacing pPeriod
pClause <- pPrimary
pCommaSeparatedClauses <- pClauseComma* pPrimary
pClauseComma <- pClause pComma
pRule <- pPrimary pColonDash pCommaSeparatedClauses Spacing pPeriod
pDirective <- pColonDash CommentStuff* EndOfLine
pTopLevel <- Spacing (pFact / pRule / pDirective)
pProgram <- pTopLevel+
"
)

