(eval-when (:compile-toplevel :load-toplevel :execute)
  (peg:into-package "PROLOG"))

;; not all of these are Prolog keywords, some are just convenience matches for
;; the working code base
(peg:rule prolog::pKeyword "pTrue / pFail / pIs / pColonDash / pNot / pNotSame / pSame / pNotUnifySame / pUnifySame / pGreaterEqual / pLessEqual / pCut / pPeriod / pComma / pLpar / pRpar / pLBRack / pRBrack / pUserError / pCurrentInput / pUserInput / pMinus / pPlus / pAsterisk / pSlash"
  (:lambda (x) x))

(peg:rule prolog::pUserError "'user_error' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog:user-error))

(peg:rule prolog::pCurrentInput "'current_input' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog:current-input))

(peg:rule prolog::pUserInput "'user_input' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog:user-input))

(peg:rule prolog::pFail "'fail' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog:pl-fail))

(peg:rule prolog::pTrue "'true' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog:pl-true))

(peg:rule prolog::pKWID "pTrue / pFail / pUserError / pCurrentInput / pUserInput"
  (:lambda (x) x))

(peg:rule prolog::pIs "'is' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog:pl-is))

(peg:rule prolog::pNot "'\\\\\+' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog:pl-not))

(peg:rule prolog::pNotSame "[\\\\] '==' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog:not-same))

(peg:rule prolog::pSame " '==' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog:same))

(peg:rule prolog::pNotUnifySame "! pNotSame '\\\\' '=' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog:not-unify-same))

(peg:rule prolog::pUnifySame "!pSame !pLessEqual '=' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog:unify-same))

(peg:rule prolog::pColonDash "':-' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog:colon-dash))

(peg:rule prolog::pGreaterEqual "'>=' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog:greater-equal))

(peg:rule prolog::pLessEqual "'=<' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog:less-equal))

(peg:rule prolog::pCut "'!' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog:cut))

(peg:rule prolog::pPeriod "[.] Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog:dot))

(peg:rule prolog::pComma "',' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog:comma))

(peg:rule prolog::pLpar "'(' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog:lpar))

(peg:rule prolog::pRpar "')' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog:rpar))

(peg:rule prolog::pLBrack "'[' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog:l-bracket))

(peg:rule prolog::pRBrack "']' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog:r-bracket))

(peg:rule prolog::pMinus "'-' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog:minus))

(peg:rule prolog::pPlus "'+' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog:plus))

(peg:rule prolog::pAsterisk "'*' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog:mul))

(peg:rule prolog::pSlash "'/' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog:div))

(peg:rule prolog::pOrBar "'|' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog:or-bar))

