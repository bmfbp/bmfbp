(eval-when (:compile-toplevel :load-toplevel :execute)
  (peg:into-package "PROLOG"))

;; not all of these are Prolog keywords, some are just convenience matches for
;; the working code base
(peg:rule prolog::Keyword "pTrue / pFail / pHalt / pIs / pAsserta / pRetract / pReadFB / pWriteFB / pInclude / pInitialization / pGAssign / pForall / pColonDash / pNotSame / pNot / pNotSame / pSame / pNotUnifySame / pUnifySame / pGreaterEqual / pLessEqual / pCut / pPeriod / pComma / pLpar / pRpar / pWriteterm / pWrite / pNl / pUserError / pCurrentInput / pGRead / pMinus / pPlus / pAsterisk / pSlash"
  (:lambda (x) x))

(peg:rule prolog::pUserError "'user_error' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pCurrentInput "'current_input' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pGRead "'g_read' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pWrite "'write' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pNl "'nl' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pFail "'fail' Spacing"
  (:lambda (x) (declare (ignore x)) prolog::op-fail))

(peg:rule prolog::pTrue "'true' Spacing"
  (:lambda (x) (declare (ignore x)) prolog::op-true))

(peg:rule prolog::pHalt "'halt' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pIs "'is' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pAsserta "'asserta' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pRetract "'retract' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pReadFB "'readFB' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pWriteFB "'writeFB' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pInclude "'pInclude' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pInitialization "'initialization' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pGAssign "'g_assign' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pForall "'forall' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pWriteTerm "'writeterm' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pWrite "'write' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pNl "'nl' Spacing"
  (:lambda (x) (declare (ignore x))))


(peg:rule prolog::pNot "'\+' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pNotSame "'\==' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pSame "'==' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pNotUnifySame "'\=' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pUnifySame "'=' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pColonDash "':-' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pGreaterEqual "'>=' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pLessEqual "'=<' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pCut "'!' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pPeriod "'\.' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pComma "'\,' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pLpar "'(' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pRpar "')' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pMinus "'-' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pPlus "'+' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pAsterisk "'*' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pSlash "'/' Spacing"
  (:lambda (x) (declare (ignore x))))
