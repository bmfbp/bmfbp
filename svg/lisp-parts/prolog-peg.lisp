(eval-when (:compile-toplevel :load-toplevel :execute)
  (peg:into-package "PROLOG"))

(peg:rule prolog::PrologProgram "Spacing (pDirective / pFact / pRule)+"
  (:destructure (spc lis)
   (declare (ignore spc))
   lis))

(peg:rule prolog::pDirective "pColonDash (pInitialization / pInclude) pLpar Identifier pRpar pPeriod"
  (:lambda (lis)
    (declare (ignore lis))
    nil))

(peg:rule prolog::pFact "pRuleHead pPeriod Spacing"
  (:destructure (head p spc)
    (declare (ignore p spc))
    `(prolog::<- ,head)))

(peg:rule prolog::pRule "pRuleHead pColonDash pRuleBody Spacing"
  (:destructure (head cdash pBody spc)
    (declare (ignore cdash spc))
    `(prolog::<- ,head ,@pBody)))

(peg:rule prolog::pRuleHead "Identifier pFormals? Spacing"
  (:destructure (id formals spc)
   (declare (ignore spc))
   `(,id ,@formals)))

(peg:rule prolog::pFormals "pLpar pFormalComma+ pRpar"
  (:destructure (lp lis rp)
    (declare (ignore lp rp))
    lis))

(peg:rule prolog::pFormalComma "IdentifierOrVariableOrNumber pComma?"
  (:destructure (id comma)
    (declare (ignore comma))
    id))

(peg:rule prolog::pRuleBody "pClauseComma+ Spacing pPeriod"
  (:destructure (clause-list spc p)
    (declare (ignore sp p))
    clause-list))

(peg:rule prolog::pClauseComma "pClause pComma?"
  (:destructure (clause comma)
   (declare (ignore comma))
   clause))

(peg:rule prolog::pClause "pCall / pTrue / pFail / pCut / pHalt /pAssertaClause / pRetractClause / pNotClause / pAssignClause / pReadFBClause / pWriteFBClause / pForallClause / pExpr / Number"
  (:lambda (x) x))

(peg:rule prolog::pCall "Identifier pActuals?"
  (:destructure (id actual-list)
   `(,id ,@actual-list)))

(peg:rule prolog::pActuals "pLpar pActualComma+ pRpar"
  (:destructure (lp a rp)
    (declare (ignore lp rp))
    a))

(peg:rule prolog::pActualComma "IdentifierOrVariableOrNumber pComma?"
  (:destructure (id-or-var comma)
     (declare (ignore comma))
     id-or-var))

(peg:rule prolog::pExpr "pIsExpr / pEqExpr / pRelationalExpr / pMathExpr"
  (:lambda (x) x))

(peg:rule prolog::pPrimary "Number / Identifier / Variable"
  (:lambda (x) x))

(peg:rule prolog::pRelationalExpr "pRelationalExpr1 / pRelationalExpr2"
  (:lambda (x) x))

(peg:rule prolog::pRelationalExpr1 "Variable pLessEqual pPrimary"
  (:destructure (v op p)
   (declare (ignore op))
   `(prolog::less-equal ,v ,p)))

(peg:rule prolog::pRelationalExpr2 "Variable pGreaterEqual pPrimary"
  (:destructure (v op p)
   (declare (ignore op))
   `(prolog::greater-equal ,v ,p)))

(peg:rule prolog::pIsExpr "pIsExpr1 / pIsExpr2"
  (:lambda (x) x))

(peg:rule prolog::pIsExpr1 "Variable pIs pPrimary ! pMathFollow"
  (:lambda (x) x))

(peg:rule prolog::pIsExpr2 "Variable pIs pMathExpr"
  (:lambda (x) x))

(peg:rule prolog::pMathFollow "pPlus / pMinus / pAsterisk / pSlash / pLpar"
  (:lambda (x) x))

(peg:rule prolog::pMathExpr "pPlusExpr / pMinusExpr / pMulExpr / pDivExpr / pFunctionExpr / pNestedExpr"
  (:lambda (x) x))

(peg:rule prolog::pNestedExpr "pLpar pMathExpr pRpar"
  (:destructure (lp e rp)
   (declare (ignore lp rp))
   e))

(peg:rule prolog::pFunctionExpr "Identifier pLpar pActualComma+ pRpar"
  (:destructure (id lp actual-list rp)
   (declare (ignore lp rp))
   `(prolog::op-funcall ,id ,@actual-list)))

(peg:rule prolog::pMulExpr "Variable pAsterisk pPrimary"
  (:destructure (v1 p v2)
     `(prolog::op-multiply ,v1 ,v2)))

(peg:rule prolog::pDivExpr "Variable pSlash pPrimary"
  (:destructure (v1 p v2)
     `(prolog::op-divide ,v1 ,v2)))

(peg:rule prolog::pPlusExpr "Variable pPlus pPrimary"
  (:destructure (v1 p v2)
     `(prolog::op-plus ,v1 ,v2)))

(peg:rule prolog::pMinusExpr "Variable pMinus pPrimary"
  (:destructure (v1 p v2)
     `(prolog::op-minus ,v1 ,v2)))

(peg:rule prolog::pEqExpr "pEqExpr1 / pEqExpr2 / pEqExpr3 / pEqExpr4"
  (:lambda (x) x))
	  
(peg:rule prolog::pEqExpr1 "Variable pNotUnifySame Variable"
  (:destructure (v1 op v2)
    (declare (ignore op))
      `(prolog::op-not-unify-same ,v1 ,v2)))

(peg:rule prolog::pEqExpr4 "Variable pUnifySame Variable"
  (:destructure (v1 op v2)
    (declare (ignore op))
      `(prolog::op-unify-same ,v1 ,v2)))

(peg:rule prolog::pEqExpr2 "Variable pSame Variable"
  (:destructure (v1 op v2)
    (declare (ignore op))
      `(prolog::op-same ,v1 ,v2)))

(peg:rule prolog::pEqExpr3 "Variable pNotSame Variable"
  (:destructure (v1 op v2)
    (declare (ignore op))
      `(prolog::op-not-same ,v1 ,v2)))


(peg:rule prolog::pAssignClause "pGAssign pLpar Identifier pComma Number pRpar"
  (:destructure (a lp id comma n rp)
    (declare (ignore lp comma rp))
    `(prolog::global-assign ,a ,n)))
			 
(peg:rule prolog::pReadClause "pGRead pLpar Identifier pComma Variable pRpar"
  (:destructure (r lp id comma v rp)
    (declare (ignore r lp comma rp))
    `(prolog::global-read ,id ,v)))
			 
(peg:rule prolog::pAssertaClause "pAsserta pLpar pSimpleClause pRpar"
  (:destructure (op lp clause rp)
    (declare (ignore op lp rp))
    `(prolog::asserta ,clause)))

(peg:rule prolog::pRetractClause "pRetract pLpar pSimpleClause pRpar"
  (:destructure (op lp clause rp)
    (declare (ignore op lp rp))
    `(prolog::retract ,clause)))

(peg:rule prolog::pReadFBClause "pReadFB pLpar pUserInput pRpar"
  ;; delete completely
  (:lambda (x) (declare (ignore x)) nil))
	  
(peg:rule prolog::pWriteFBClause "pWriteFB"
  ;; delete completely
  (:lambda (x) (declare (ignore x)) nil))

(peg:rule prolog::pForallClause "pForall pLpar pSimpleClause pComma pSimpleClause pRpar"
  (:destructure (fa lp cl1 comma cl2 rp)
    (declare (ignore fa lp comma rp))
    `(prolog::forall ,cl1 ,cl2)))

(peg:rule prolog::pSimpleClause "pClause"
  (:lambda (x) x))

(peg:rule prolog::pNotClause "pNot pSimpleClause"
  (:destructure (op clause)
    (declare (ignore op))
    `(prolog::op-not ,clause)))

(peg:rule prolog::IdentifierOrVariable "Identifier / Variable"
  (:lambda (x) x))

(peg:rule prolog::IdentifierOrVariableOrNumber "Identifier / Variable / Number"
  (:lambda (x) x))

