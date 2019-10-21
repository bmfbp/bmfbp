(eval-when (:compile-toplevel :load-toplevel :execute)
  (peg:into-package "PROLOG"))

(defparameter *peg-rules-paip*
;; generic grammar, not PAIP specific
"
pPrimary <- pOpClause / pCut / pNumber / pVariable / pFunctor / pKWID / pIdentifier / pList / pParenthesizedExpr
  { (:lambda (x)
      (case x
        (prolog:cut 'paip::!)
        (prolog::true '(paip-extension::true))
        (prolog::halt '(paip-extension::halt))
        (otherwise x))) }

pParenthesizedExpr <- pLpar pExpr pRpar
  { (:destructure (lp e rp) (declare (ignore lp rp)) e) }

pList <- pEmptyList / pCarOnlyList / pOrList
pEmptyList <- pLBrack pRBrack
  { (:lambda (x) (declare (ignore x)) `(prolog:list)) }
pCarOnlyList <- pLBrack pCommaSeparatedListOfExpr pRBrack
  { (:destructure (lb lis rb)
     (declare (ignore lb rb))
     `(prolog:list ,lis)) }
pOrList <- pLBrack pCommaSeparatedListOfExpr pOrBar pCommaSeparatedListOfExpr pRBrack
  { (:destructure (lb lis orb lis2 rb)
     (declare (ignore lb rb orb))
     `(prolog:list ,lis ,@lis2)) }

pFunctor <- pIdentifier pLpar pCommaSeparatedListOfExpr pRpar
  { (:destructure (id lp lis rp)
     (declare (ignore lp rp))
     `(,id ,@lis)) }

pExpr <- pBoolean

pCommaSeparatedListOfExpr <- (pExpr pComma)* pExpr
  { (:destructure (lis e)
     (if lis
         `(,@(mapcar #'(lambda (pair) (first pair)) lis)
           ,e)
       `(,e))) }

pBoolean <- pSum ((pGreaterEqual / pLessEqual / pSame / pNotSame) pSum)*
  { (:destructure (s lis)
     (if lis
         (let ((op (first lis))
               (s2 (second lis)))
           `(,op ,s ,s2))
       s)) }

pSum <- pProduct ((pPlus / pMinus) pProduct)*
  { (:destructure (p lis)
     (if lis
         (let ((op (first lis))
               (p2 (second lis)))
           `(,op ,p ,p2))
       p)) }

pProduct <- pPrimary ((pAsterisk / pSlash) pPrimary)*
  { (:destructure (p lis)
     (if lis
         (let ((op (first lis))
               (p2 (second lis)))
           `(,op ,p ,p2))
       p)) }


pOpClause <- pOpExpr / pUnifyExpr / pIsExpr / pExpr
pOpExpr <- pNot pExpr
  { (:destructure (n e) (declare (ignore n)) `(prolog:not ,e)) }

pUnifyExpr <- pUnifyExprEQ / pUnifyExprNEQ
pUnifyExprEQ <- pPrimary pUnifySame pPrimary
pUnifyExprNEQ <- pPrimary pNotUnifySame pPrimary
pIsExpr <- pVariable pIs pExpr
pBinaryOp <- pIs / pNotSame / pSame / pUnifySame / pNotUnifySame / pGreaterEqual / pLessEqual

pFact <- pFunctor Spacing pPeriod
  { (:destructure (f spc p)
     (declare (ignore spc p))
     f) }

pCommaSeparatedClauses <- pPrimaryComma* pPrimary
  { (:destructure (lis p)
     (if lis
         `(,(first lis) ,p)
       (list p))) }

pPrimaryComma <- pPrimary pComma
 { (:destructure (p c)
    (declare (ignore c))
    p) }

pRule <- pPrimary pColonDash pCommaSeparatedClauses Spacing pPeriod
  { (:destructure (prim cd clause-list spc p)
     (declare (ignore cd spc p))
     `(paip::<- ,(if (listp prim) prim (list prim))
                         ,@clause-list)) }

pDirective <- pColonDash CommentStuff* EndOfLine
  { (:lambda (x) (declare (ignore x)) '(prolog:directive)) }
pTopLevel <- Spacing (pFact / pRule / pDirective)
  { (:destructure (spc thing)
     (declare (ignore spc))
     thing) }
pProgram <- pTopLevel+
  { (:lambda (x) x) }
"
)
