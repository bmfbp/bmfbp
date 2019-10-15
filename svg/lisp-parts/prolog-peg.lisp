(eval-when (:compile-toplevel :load-toplevel :execute)
  (peg:into-package "PROLOG"))

(peg:rule prolog::pPrimary "pTrue / pFail / pCut / Number / pNonFunctorID / Variable / pFunctor / pKWID / pList / (pLpar pExpr pRpar)"
  (:lambda (x) x))

(peg:rule prolog::pList "pLBrack pCommaSeparatedListOfExpr? pRBrack"
  (:lambda (x) x))

(peg:rule prolog::pCommaSeparatedListOfExpr "(pExpr pComma)* pExpr"
  (:lambda (x) x))

(peg:rule prolog::pFunctor "Identifier pLpar pCommaSeparatedListOfExpr pRpar"
  (:lambda (x) x))

(peg:rule prolog::pNonFunctorID "Identifier !pLpar"
  (:lambda (x) x))

(peg:rule prolog::pExpr "pSum"
  (:lambda (x) x))

(peg:rule prolog::pSum "pProduct ((pPlus / pMinus) pProduct)*"
  (:lambda (x) x))

(peg:rule prolog::pProduct "pPrimary ((pAsterisk / pSlash) pPrimary)*"
  (:lambda (x) x))

(peg:rule prolog::pClause "Identifier (pLpar pCommaSeparatedListOfExpr pRpar)?"
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