(eval-when (:compile-toplevel :load-toplevel :execute)
  (cl-peg:into-package "ARROWGRAMS/PROLOG-PEG"))

;; not all of these are Prolog keywords, some are just convenience matches for
;; the working code base
(cl-peg:rule arrowgrams/prolog-peg::pKeyword "pTrue / pFail / pIs / pColonDash / pNot / pNotSame / pSame / pNotUnifySame / pUnifySame / pGreaterEqual / pLessEqual / pCut / pPeriod / pComma / pLpar / pRpar / pLBRack / pRBrack / pUserError / pCurrentInput / pUserInput / pMinus / pPlus / pAsterisk / pSlash"
  (:lambda (x) x))

(cl-peg:rule prolog::pUserError "'user_error' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::user-error))

(cl-peg:rule prolog::pCurrentInput "'current_input' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::current-input))

(cl-peg:rule prolog::pUserInput "'user_input' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::user-input))

(cl-peg:rule prolog::pFail "'fail' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::pl-fail))

(cl-peg:rule prolog::pTrue "'true' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::pl-true))

(cl-peg:rule prolog::pKWID "pTrue / pFail / pUserError / pCurrentInput / pUserInput"
  (:lambda (x) x))

(cl-peg:rule prolog::pIs "'is' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::pl-is))

(cl-peg:rule prolog::pNot "'\\\\\+' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::pl-not))

(cl-peg:rule prolog::pNotSame "[\\\\] '==' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::not-same))

(cl-peg:rule prolog::pSame " '==' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::same))

(cl-peg:rule prolog::pNotUnifySame "! pNotSame '\\\\' '=' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::not-unify-same))

(cl-peg:rule prolog::pUnifySame "!pSame !pLessEqual '=' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::unify-same))

(cl-peg:rule prolog::pColonDash "':-' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::colon-dash))

(cl-peg:rule prolog::pGreaterEqual "'>=' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::greater-equal))

(cl-peg:rule prolog::pLessEqual "'=<' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::less-equal))

(cl-peg:rule prolog::pCut "'!' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::cut))

(cl-peg:rule prolog::pPeriod "[.] Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::dot))

(cl-peg:rule prolog::pComma "',' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::comma))

(cl-peg:rule prolog::pLpar "'(' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::lpar))

(cl-peg:rule prolog::pRpar "')' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::rpar))

(cl-peg:rule prolog::pLBrack "'[' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::l-bracket))

(cl-peg:rule prolog::pRBrack "']' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::r-bracket))

(cl-peg:rule prolog::pMinus "'-' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::minus))

(cl-peg:rule prolog::pPlus "'+' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::plus))

(cl-peg:rule prolog::pAsterisk "'*' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::mul))

(cl-peg:rule prolog::pSlash "'/' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::div))

(cl-peg:rule prolog::pOrBar "'|' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::or-bar))

