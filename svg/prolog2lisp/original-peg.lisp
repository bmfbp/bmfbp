(eval-when (:compile-toplevel :load-toplevel :execute)
  (cl-peg:into-package "ARROWGRAMS/PROLOG-PEG"))

;; this is the full grammar w/o code emission - when it succeeds parsing everything, then we can move on to code emission
;;  before refactoring
(defparameter *peg-rules-original*
"
pProgram <- pTopLevel+
pTopLevel <- Spacing (pFact / pRule / pDirective)
pDirective <- pColonDash CommentStuff* EndOfLine
pRule <- pPrimary pColonDash pCommaSeparatedClauses Spacing pPeriod
pFact <- (pPrimary / pFunctor) pPeriod
pClause <- Forall-Clause / Retract-Clause / IS-statement / pFunctor / pCut / pPrimary
pCommaSeparatedClauses <- (pClause pComma)* pClause
pBinaryOperator <- pIs / pPlus / pMinus / pAsterisk / pSlash / pMod / pEquality / pNotEquality
pPrefixOperator <- pNot
pPrimary <- pIdentifier / pVariable / pNumber / pTrue / pFail
pExpr <- pPrimary / pBinaryExpression / pUnaryExpression
pParenthesizedExpr <- pLpar pExpr pRpar
pBinaryExpression <- pExpr pBinaryOperator pExpr
pUnaryExpression <- pPrefixOperator pExpr
pFunctor <- pPrimary pLpar pCommaSeparatedArgs pRpar
pCommaSeparatedArgs <- pCommaSeparatedClauses
"
)

