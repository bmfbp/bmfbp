(eval-when (:compile-toplevel :load-toplevel :execute)
  (cl-peg:into-package "ARROWGRAMS/PROLOG-PEG"))

;; this is the full grammar w/o code emission - when it succeeds parsing test13, then we can move on to code emission
;;  before refactoring
(defparameter *peg-rules-original*
"
pPrimary <- pOpClause / pCut / pNumber / pVariable / pFunctor / pKWID / pIdentifier / pList / (pLpar pExpr pRpar) / pForall
pForallClause <- pForall pLpar pExpr pComma pExpr pRpar
pList <- pLBrack pCommaSeparatedListOfExpr? (pOrBar pCommaSeparatedListOfExpr)? pRBrack
pCommaSeparatedListOfExpr <- (pExpr pComma)* pExpr
pFunctor <- pIdentifier pLpar pCommaSeparatedListOfExpr pRpar
pExpr <- pBoolean
pBoolean <- pSum ((pGreaterEqual / pLessEqual / pSame / pNotSame) pSum)*
pSum <- pProduct ((pPlus / pMinus) pProduct)*
pProduct <- pPrimary ((pAsterisk / pSlash) pPrimary)*
pOpClause <- pOpExpr / pUnifyExpr / pIsExpr / pExpr
pOpExpr <- pNot pExpr
pUnifyOp <- pUnifySame / pNotUnifySame 
pUnifyExpr <- pPrimary pUnifyOp pPrimary
pIsExpr <- pVariable pIs pExpr
pBinaryOp <- pIs / pNotSame / pSame / pUnifySame / pNotUnifySame / pGreaterEqual / pLessEqual
pFact <- pFunctor Spacing pPeriod
pClause <- pPrimary
pCommaSeparatedClauses <- (pClause pComma)* pClause
pRule <- pPrimary pColonDash pCommaSeparatedClauses Spacing pPeriod
pDirective <- pColonDash CommentStuff* EndOfLine
pTopLevel <- Spacing (pFact / pRule / pDirective)
pProgram <- pTopLevel+
"
)

