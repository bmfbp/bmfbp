;(eval-when (:compile-toplevel :load-toplevel :execute)
;  (peg:into-package "PROLOG"))
(eval-when (:compile-toplevel :load-toplevel :execute)
  (peg:into-package "PAIP"))

(defparameter *peg-rules-generic*
;; generic grammar, not PAIP specific
"
pPrimary <- pOpClause / pCut / pNumber / pVariable / pFunctor / pKWID / pIdentifier / pList / pParenthesizedExpr

pParenthesizedExpr <- pLpar pExpr pRpar
  { (:destructure (lp e rp) (declare (ignore lp rp)) e) }

pList <- pEmptyList / pCarOnlyList / pOrList
pEmptyList <- pLBrack pRBrack
  { (:lambda (x) (declare (ignore x)) `(prolog:pl-list)) }
pCarOnlyList <- pLBrack pCommaSeparatedListOfExpr pRBrack
  { (:destructure (lb lis rb)
     (declare (ignore lb rb))
     `(prolog:pl-list ,lis)) }
pOrList <- pLBrack pCommaSeparatedListOfExpr pOrBar pCommaSeparatedListOfExpr pRBrack
  { (:destructure (lb lis orb lis2 rb)
     (declare (ignore lb rb orb))
     `(prolog:pl-list ,lis ,@lis2)) }

pFunctor <- pIdentifier pLpar pCommaSeparatedListOfExpr pRpar
  { (:destructure (id lp lis rp)
     (declare (ignore lp rp))
     `(,id ,@lis)) }

pExpr <- pBooleanExpr

pCommaSeparatedListOfExpr <- (pExpr pComma)* pExpr
  { (:destructure (lis e)
     (if lis
         `(,@(mapcar #'(lambda (pair) (first pair)) lis)
           ,e)
       `(,e))) }

pBooleanExpr <- pSum ((pGreaterEqual / pLessEqual / pSame / pNotSame) pSum)*
  { (:destructure (s lis)
     #+nil(format *standard-output* \"booleanExpr s=~S lis=~S~%\" s lis)
     (assert (or (null lis)
                 (and (listp lis) (= 1 (length lis)) (listp (first lis)))))
     (if lis
         (let ((op (first (first lis)))
               (s2 (second (first lis))))
           `(,op ,s ,s2))
       s)) }

pSum <- pProduct ((pPlus / pMinus) pProduct)*
  { (:destructure (p lis)
     #+nil(format *standard-output* \"sum p=~S lis=~S~%\" p lis)
     (assert (or (null lis)
                 (and (listp lis) (= 1 (length lis)) (listp (first lis)))))
     (if lis
         (let ((op (first (first lis)))
               (p2 (second (first lis))))
           `(,op ,p ,p2))
       p)) }

pProduct <- pPrimary ((pAsterisk / pSlash) pPrimary)*
  { (:destructure (p lis)
     #+nil(format *standard-output* \"product p=~S lis=~S~%\" p lis)
     (assert (or (null lis)
                 (and (listp lis) (= 1 (length lis)) (listp (first lis)))))
     (if lis
         (let ((op (first (first lis)))
               (p2 (second (first lis))))
           `(,op ,p ,p2))
       p)) }


pOpClause <- pOpExpr / pUnifyExpr / pIsExpr / pExpr
pOpExpr <- pNot pExpr
  { (:destructure (n e) (declare (ignore n)) `(prolog:pl-not ,e)) }

pUnifyExpr <- pUnifyExprEQ / pUnifyExprNEQ
pUnifyExprEQ <- pPrimary pUnifySame pPrimary
pUnifyExprNEQ <- pPrimary pNotUnifySame pPrimary
pIsExpr <- pVariable pIs pExpr
  { (:destructure (v op e)
     #+nil(format *standard-output* \"~&pIsExpr v=~S e=~S~%\" v e)
     `(prolog:pl-is ,v ,e)) }

pBinaryOp <- pIs / pNotSame / pSame / pUnifySame / pNotUnifySame / pGreaterEqual / pLessEqual

pFact <- pFunctor Spacing pPeriod
  { (:destructure (f spc p)
     (declare (ignore spc p))
     f) }

pClause <- pPrimary

pCommaSeparatedClauses <- pClauseCommaUsedOnlyByCommaSeparatedClauses* pPrimary
  { (:destructure (lis p)
     (when (atom p) (setf p (list p)))
     (if lis
         `(,@lis ,p)
       (list p))) }

pClauseCommaUsedOnlyByCommaSeparatedClauses <- pClause pComma
 { (:destructure (p c)
    (declare (ignore c))
    (when (atom p) (setf p (list p)))
    p) }

pRule <- pPrimary pColonDash pCommaSeparatedClauses Spacing pPeriod
  { (:destructure (prim cd clause-list spc p)
     (declare (ignore cd spc p))
     `(prolog:colon-dash ,(if (listp prim) prim (list prim))
                         ,@clause-list)) }

pDirective <- pColonDash CommentStuff* EndOfLine
  { (:lambda (x) (declare (ignore x)) '(prolog:directive)) }
pTopLevel <- Spacing (pFact / pRule / pDirective)
  { (:destructure (spc thing)
     (declare (ignore spc))
     thing) }
pProgram <- pTopLevel+
  { (:lambda (x) `(progn ,@x)) }
"
)
