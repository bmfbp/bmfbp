(eval-when (:compile-toplevel :load-toplevel :execute)
  (peg:into-package "PROLOG"))

(defparameter *first-time* t)

(defparameter *peg-rules*
  #|
"
pPrimary <- pOpClause / pCut / pNumber / pVariable / pFunctor / pKWID / pIdentifier / pList / pParenthesizedExpr
pParenthesizedExp <- pLpar pExpr pRpar
pList <- pEmptyList / pCarOnlyList / pOrList
pEmptyfList <- pLBrack pRBrack
pCarOnlyList <- pLBrack pCommaSeparatedListOfExpr pRBrack
pOrList <- pLBrack pCommaSeparatedListOfExpr pOrBar pCommaSeparatedListOfExpr pRBrack
pCommaSeparatedListOfExpr <- (pExpr pComma)* pExpr
pFunctor <- pIdentifier pLpar pCommaSeparatedListOfExpr pRpar
pExpr <- pBoolean
pBoolean <- pSum ((pGreaterEqual / pLessEqual / pSame / pNotSame) pSum)*
pSum <- pProduct ((pPlus / pMinus) pProduct)*
pProduct <- pPrimary ((pAsterisk / pSlash) pPrimary)*
pOpClause <- pOpExpr / pUnifyExpr / pIsExpr / pExpr
pOpExpr <- pNot pExpr
pUnifyExpr <- pUnifyExprEQ / pUnifyExprNEQ
pUnifyExprEQ <- pPrimary pUnifySame pPrimary
pUnifyExprNEQ <- pPrimary pNoUnifySame pPrimary
pIsExpr <- pVariable pIs pExpr
pBinaryOp <- pIs / pNotSame / pSame / pUnifySame / pNotUnifySame / pGreaterEqual / pLessEqual
pFact <- pFunctor Spacing pPeriod
pCommaSeparatedClauses <- pPrimaryComma* pPrimary
pPrimaryComma <- pPrimary pComma
pRule <- pPrimary pColonDash pCommaSeparatedClauses Spacing pPeriod
pDirective <- pColonDash CommentStuff* EndOfLine
pTopLevel <- Spacing (pFact / pRule / pDirective)
pProgram <- pTopLevel+

"
#|
"
pPrimary <- pOpClause / pCut / pNumber / pVariable / pFunctor / pKWID / pIdentifier / pList / pParenthesizedExpr
  { (:lambda (x) x) }

pParenthesizedExp <- pLpar pExpr pRpar
  { (:destructure (lp e rp)
     (declare (ignore lp rp))
     e) }

pList <- pLBrack pCommaSeparatedListOfExpr? (pOrBar pCommaSeparatedListOfExpr)? pRBrack
  { (:destructure (lb e or-e rb)
     (declare (ignore lb rb))
     (let ((e2 (second or-e)))
       (if e
           (cons e e2)
         e2))) }

pCommaSeparatedListOfExpr <- (pExpr pComma)* pExpr
  { (:desctructure (lis e)
     (let ((es (mapcar #'car lis)))
       `(,@es ,e))) }

pFunctor <- pIdentifier pLpar pCommaSeparatedListOfExpr pRpar
  { (:destructure (id lp lis rp)
     (declare (ignore lp rp))
     `(,id ,@lis)) }

pExpr <- pBoolean
  { (:lambda (x) x) }

pBoolean <- pSum ((pGreaterEqual / pLessEqual / pSame / pNotSame) pSum)*
  { (:lambda (x) (fixops x)) }

pSum <- pProduct ((pPlus / pMinus) pProduct)*
  { (:lambda (x) (prolog:fixops x)) }

pProduct <- pPrimary ((pAsterisk / pSlash) pPrimary)*
  { (:lambda (x) (prolog:fixops x)) }


pOpClause <- pOpExpr / pUnifyExpr / pIsExpr / pExpr
  { (:lambda (x) x) }

pOpExpr <- pNot pExpr
  { (:lambda (x) `(prolog:not ,x) }

pUnifyExpr <- pUnifyExprEQ / pUnifyExprNEQ
  { (:lambda (x) x) }

pUnifyExprEQ <- pPrimary pUnifySame pPrimary
  { (:destructure (v op e)
     (declare (ignore op))
     `(prolog:unify ,v ,e)) }

pUnifyExprNEQ <- pPrimary pNoUnifySame pPrimary
  { (:destructure (v op e)
     (declare (ignore op))
     `(prolog:not-unify ,v ,e)) }

pIsExpr <- pVariable pIs pExpr
  { (:destructure (v op e)
     (declare (ignore op))
     `(prolog:is ,v ,e)) }

pBinaryOp <- pIs / pNotSame / pSame / pUnifySame / pNotUnifySame / pGreaterEqual / pLessEqual
  { (:lambda (x) x) }

pFact <- pFunctor Spacing pPeriod
  { (:desctructure (f spc p)
     (declare (ignore spc p))
     f) }

pCommaSeparatedClauses <- pPrimaryComma* pPrimary
  { (:destructure (pc-list p)
     `(,@pc-list ,p)) }

pPrimaryComma <- pPrimary pComma
  { (:destructure (p c)
     (declare (ignore c))
     p) }

pRule <- pPrimary pColonDash pCommaSeparatedClauses Spacing pPeriod
  { (:destructure (prim cd clause-list spc p)
     (declare (ignore cd spc p))
     `(prolog:defrule ,prim ,@clause-list)) }

pDirective <- pColonDash CommentStuff* EndOfLine
  { (:lambda (x) (declare (ignore x)) nil) }

pTopLevel <- Spacing (pFact / pRule / pDirective)
  { (:lambda (x) (second x)) ;; discard Spacing (first x) }

pProgram <- pTopLevel+
  { (:lambda (x) x) }

"
|#
|#
;; this is the full grammar w/o code emission - when it succeeds parsing test13, then we can move on to code emission
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
")

(defun init ()
  (flet ((prinr ()
           (let ((r1 (gethash 'prolog::pFunctor esrap::*rules*))
                 (r2 (gethash 'prolog::pCommaSeparatedListOfExpr esrap::*rules*)))
             (format *standard-output* "~&pFunctor ~S~%pCommaSeparatedListOfExpr ~S~%" r1 r2))))
    (when *first-time*
      (setf *first-time* nil)
      (prinr)
      ;(peg:delete-rules "PROLOG") ;; TODO: don't call this, esrap==>undefined rule pCommaSeparatedListOfExpr
      (let ((g (peg:fullpeg *peg-rules*)))
        (mapc #'(lambda (r) (eval r)) (cdr g))
        (prinr)))))


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
