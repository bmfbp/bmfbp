(eval-when (:compile-toplevel :load-toplevel :execute)
  (peg:into-package "PROLOG"))

;; not all of these are Prolog keywords, some are just convenience matches for
;; the working code base
(peg:rule prolog::pKeyword "pTrue / pFail / pIs / pColonDash / pNot / pNotSame / pSame / pNotUnifySame / pUnifySame / pGreaterEqual / pLessEqual / pCut / pPeriod / pComma / pLpar / pRpar / pLBRack / pRBrack / pUserError / pCurrentInput / pUserInput / pMinus / pPlus / pAsterisk / pSlash"
  (:lambda (x) x))

(peg:rule prolog::pUserError "'user_error' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pCurrentInput "'current_input' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pUserInput "'user_input' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pFail "'fail' Spacing"
  (:lambda (x) (declare (ignore x)) '(prolog::lisp (prolog::op-fail))))

(peg:rule prolog::pTrue "'true' Spacing"
  (:lambda (x) (declare (ignore x)) '(prolog::lisp (prolog::op-true))))

(peg:rule prolog::pKWID "pTrue / pFail / pUserError / pCurrentInput / pUserInput"
  (:lambda (x) x))

(peg:rule prolog::pIs "'is' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pNot "'\\\\\+' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pNotSame "[\\\\] '==' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pSame " '==' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pNotUnifySame "! pNotSame '\\\\' '=' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pUnifySame "!pSame !pLessEqual '=' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pColonDash "':-' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pGreaterEqual "'>=' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pLessEqual "'=<' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pCut "'!' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pPeriod "[.] Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pComma "',' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pLpar "'(' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pRpar "')' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pLBrack "'[' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pRBrack "']' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pMinus "'-' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pPlus "'+' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pAsterisk "'*' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pSlash "'/' Spacing"
  (:lambda (x) (declare (ignore x))))

(peg:rule prolog::pOrBar "'|' Spacing"
  (:lambda (x) (declare (ignore x))))

