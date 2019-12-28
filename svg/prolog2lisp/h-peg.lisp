(in-package :arrowgrams/prolog-peg)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (cl-peg:into-package "ARROWGRAMS/PROLOG-PEG"))

(defparameter *peg-rules-hprolog*
;;  grammar for emitting holm prolog
"
pPrimary <- pOpClause / hCut / pNumber / hVariable / pFunctor / hKWID / hIdentifier / pList / pParenthesizedExpr

hKWID <- pKWID
  { (:lambda (id)
     (unless (eq id 'arrowgrams/prolog-peg::pl-true)
       id)) }
  
hIdentifier <- pIdentifier
  { (:lambda (id)
     (unless (or (eq :writefb id) (eq :halt id) (eq 'pl-true id))
       id)) }

hVariable <- pVariable
  { (:lambda (x)
      (let ((str (symbol-name x)))
        (if (dont-care-p x)
            `(:? ,(intern (symbol-name (gensym \"DONTCARE-\"))))
          `(:? ,(intern str))))) }

hCut <- pCut
  { (:lambda (x) (declare (ignore x)) :!) }

pParenthesizedExpr <- pLpar pExpr pRpar
  { (:destructure (lp e rp)
     (declare (ignore lp rp))
     (unless (or (eq :writefb e) (eq :halt e) (eq 'pl-true e))
       e)) }

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
     (if (eq :readfb id)
         nil
       (if (eq :asserta id)
           `(:lisp (asserta ,@lis))
         (if (eq :retract id)
             `(:lisp (retract ,@lis))
           `(,id ,@lis))))) }

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
           (if (eq op 'prolog:greater-equal)
               `(prolog:>= ,s ,s2)
             (if (eq op 'prolog:less-equal)
                 `(prolog:<= ,s ,s2)
               `(,op ,s ,s2))))
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
  { (:destructure (n e) (declare (ignore n)) `(:plisp (not ,e))) }

pUnifyExpr <- pUnifyExprEQ / pUnifyExprNEQ
pUnifyExprEQ <- pPrimary pUnifySame pPrimary
pUnifyExprNEQ <- pPrimary pNotUnifySame pPrimary
pIsExpr <- pVariable pIs pExpr
  { (:destructure (v op e)
     (declare (ignore op))
     #+nil(format *standard-output* \"~&pIsExpr v=~S e=~S~%\" v e)
     `(:is ,v ,e)) }

pBinaryOp <- pIs / pNotSame / pSame / pUnifySame / pNotUnifySame / pGreaterEqual / pLessEqual

pFact <- pFunctor Spacing pPeriod
  { (:destructure (f spc p)
     (declare (ignore spc p))
     f) }

pClause <- pPrimary
  { (:lambda (x)
      (memo-clause x)
      (if (eq :nl x)
          `(format *standard-error* \"~%\")
        x)) }

pCommaSeparatedClauses <- pCommaSeparatedClauses1

pCommaSeparatedClauses1 <- pClauseCommaUsedOnlyByCommaSeparatedClauses* pClause
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
     (memo-rule-definition prim)
     `(:rule ,(if (listp prim) prim (list prim))
                         ,@clause-list)) }

pDirective <- pColonDash CommentStuff* EndOfLine
  { (:lambda (x) (declare (ignore x)) nil) }

pTopLevel <- Spacing (pFact / pRule / pDirective)
  { (:destructure (spc thing)
     (declare (ignore spc))
     thing) }

pProgram <- pTopLevel+
  { (:lambda (x) `(progn ,@x)) }
"
)