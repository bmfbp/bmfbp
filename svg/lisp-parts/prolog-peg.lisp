(eval-when (:compile-toplevel :load-toplevel :execute)
  (peg:into-package "PROLOG"))

(defparameter *first-time* t)

(defun init ()
  (when *first-time*
    (setf *first-time* nil)
    ;(peg:delete-rules "PROLOG")
    (let ((g (peg:fullpeg
"
pPrimary <- pOpClause / pCut / pNumber / pVariable / pFunctor / pKWID / pIdentifier / pList / (pLpar pExpr pRpar)
  { (:lambda (x) x) }

pList <- pLBrack pCommaSeparatedListOfExpr? (pOrBar pCommaSeparatedListOfExpr)? pRBrack
  { (:lambda (x) x) }

pCommaSeparatedListOfExpr <- (pExpr pComma)* pExpr
  { (:lambda (x) x) }

pFunctor <- pIdentifier pLpar pCommaSeparatedListOfExpr pRpar
  { (:lambda (x) x) }

pExpr <- pBoolean
  { (:lambda (x) x) }

pBoolean <- pSum ((pGreaterEqual / pLessEqual / pSame / pNotSame) pSum)*
  { (:lambda (x) x) }

pSum <- pProduct ((pPlus / pMinus) pProduct)*
  { (:lambda (x) x) }

pProduct <- pPrimary ((pAsterisk / pSlash) pPrimary)*
  { (:lambda (x) x) }

pOpClause <- pOpExpr / pUnifyExpr / pIsExpr / pExpr
  { (:lambda (x) x) }

pOpExpr <- pNot pExpr
  { (:lambda (x) x) }

pUnifyOp <- pUnifySame / pNotUnifySame 
  { (:lambda (x) x) }

pUnifyExpr <- pPrimary pUnifyOp pPrimary
  { (:lambda (x) x) }

pIsExpr <- pVariable pIs pExpr
  { (:lambda (x) x) }

pBinaryOp <- pIs / pNotSame / pSame / pUnifySame / pNotUnifySame / pGreaterEqual / pLessEqual
  { (:lambda (x) x) }

pFact <- pFunctor Spacing pPeriod
  { (:lambda (x) x) }

pCommaSeparatedClauses <- (pPrimary pComma)* pPrimary
  { (:lambda (x) x) }

pRule <- pPrimary pColonDash pCommaSeparatedClauses Spacing pPeriod
  { (:lambda (x) x) }

pDirective <- pColonDash CommentStuff* EndOfLine
  { (:lambda (x) x) }

pTopLevel <- Spacing (pFact / pRule / pDirective)
  { (:lambda (x) x) }

pProgram <- pTopLevel+
  { (:lambda (x) x) }

"
#|
"
pPrimary <- pOpClause / pCut / pNumber / pVariable / pFunctor / pKWID / pIdentifier / pList / (pLpar pExpr pRpar)
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
pCommaSeparatedClauses <- (pPrimary pComma)* pPrimary
pRule <- pPrimary pColonDash pCommaSeparatedClauses Spacing pPeriod
pDirective <- pColonDash CommentStuff* EndOfLine
pTopLevel <- Spacing (pFact / pRule / pDirective)
pProgram <- pTopLevel+
"
|#
)))
    (mapc #'(lambda (r) (eval r)) (cdr g)))))


#|
(peg:rule prolog::pPrimary "pCut / Number / pNonFunctorID / pVariable / pFunctor / pKWID / pList / (pLpar pExpr pRpar)"
  (:lambda (x) x))

(peg:rule prolog::pList "pLBrack pCommaSeparatedListOfExpr? pRBrack"
  (:lambda (x) x))

(peg:rule prolog::pCommaSeparatedListOfExpr "(pExpr pComma)* pExpr"
  (:lambda (x) x))

(peg:rule prolog::pFunctor "Identifier pLpar pCommaSeparatedListOfExpr pRpar"
  (:lambda (x) x))

(peg:rule prolog::pNonFunctorID "Identifier !pLpar"
  (:lambda (x) x))

(peg:rule prolog::pExpr "pBoolean"
  (:lambda (x) x))

(peg:rule prolog::pBoolean "pSum ((pGreaterEqual / pLessEqual / pSame / pNotSame) pSum)*"
  (:lambda (x) x))

(peg:rule prolog::pSum "pProduct ((pPlus / pMinus) pProduct)*"
  (:lambda (x) x))

(peg:rule prolog::pProduct "pPrimary ((pAsterisk / pSlash) pPrimary)*"
  (:lambda (x) x))

(peg:rule prolog::pClause "pFunctor / pPrimary / pOpExpr / pUnifyExpr / pIsExpr / pExpr"
  (:lambda (x) x))

(peg:rule prolog::pOpExpr "pNot pExpr"
  (:lambda (x) x))

(peg:rule prolog::pUnifyOp "pUnifySame / pNotUnifySame "
  (:lambda (x) x))

(peg:rule prolog::pUnifyExpr "pPrimary pUnifyOp pPrimary"
  (:lambda (x) x))

(peg:rule prolog::pIsExpr "Variable pIs pExpr"
  (:lambda (x) x))

(peg:rule prolog::pBinaryOp "pIs / pNotSame / pSame / pUnifySame / pNotUnifySame / pGreaterEqual / pLessEqual"
  (:lambda (x) x))

(peg:rule prolog::pVariable "Variable"
  (:lambda (x) x))

(peg:rule prolog::pFact "pClause !pColonDash Spacing pPeriod"
  (:lambda (x) x))

(peg:rule prolog::pCommaSeparatedClauses "(pClause pComma)* pClause"
  (:lambda (x) x))

(peg:rule prolog::pRule "pClause pColonDash pCommaSeparatedClauses Spacing pPeriod"
  (:lambda (x) x))

(peg:rule prolog::pDirective "pColonDash CommentStuff* EndOfLine"
 (:lambda (list) (declare (ignore list))
   (values)))

(peg:rule prolog::pTopLevel "Spacing (pFact / pRule / pDirective)"
  (:lambda (x) x))

(peg:rule prolog::pProgram "pTopLevel+"
  (:lambda (x) x))
|#
