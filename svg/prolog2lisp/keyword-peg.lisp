(eval-when (:compile-toplevel :load-toplevel :execute)
  (cl-peg:into-package "ARROWGRAMS/PROLOG-PEG"))

;; not all of these are Prolog keywords, some are just convenience matches for
;; the working code base
(cl-peg:rule arrowgrams/prolog-peg::pKeyword "pTrue / pFail / pIs / pColonDash / pNot / pNotSame / pSame / pNotUnifySame / pUnifySame / pGreaterEqual / pLessEqual / pCut / pPeriod / pComma / pLpar / pRpar / pLBRack / pRBrack / pUserError / pCurrentInput / pUserInput / pMinus / pPlus / pAsterisk / pSlash"
  (:lambda (x) x))

(cl-peg:rule arrowgrams/prolog-peg::pUserError "'user_error' Spacing"
  (:lambda (x) (declare (ignore x)) 'arrowgrams/prolog-peg::user-error))

(cl-peg:rule arrowgrams/prolog-peg::pCurrentInput "'current_input' Spacing"
  (:lambda (x) (declare (ignore x)) 'arrowgrams/prolog-peg::current-input))

(cl-peg:rule arrowgrams/prolog-peg::pUserInput "'user_input' Spacing"
  (:lambda (x) (declare (ignore x)) 'arrowgrams/prolog-peg::user-input))

(cl-peg:rule arrowgrams/prolog-peg::pFail "'fail' Spacing"
  (:lambda (x) (declare (ignore x)) 'arrowgrams/prolog-peg::pl-fail))

(cl-peg:rule arrowgrams/prolog-peg::pTrue "'true' Spacing"
  (:lambda (x) (declare (ignore x)) 'arrowgrams/prolog-peg::pl-true))

(cl-peg:rule arrowgrams/prolog-peg::pKWID "pTrue / pFail / pUserError / pCurrentInput / pUserInput"
  (:lambda (x) x))

(cl-peg:rule arrowgrams/prolog-peg::pIs "'is' Spacing"
  (:lambda (x) (declare (ignore x)) 'arrowgrams/prolog-peg::pl-is))

(cl-peg:rule arrowgrams/prolog-peg::pNot "'\\\\\+' Spacing"
  (:lambda (x) (declare (ignore x)) 'arrowgrams/prolog-peg::pl-not))

(cl-peg:rule arrowgrams/prolog-peg::pNotSame "[\\\\] '==' Spacing"
  (:lambda (x) (declare (ignore x)) 'arrowgrams/prolog-peg::not-same))

(cl-peg:rule arrowgrams/prolog-peg::pSame " '==' Spacing"
  (:lambda (x) (declare (ignore x)) 'arrowgrams/prolog-peg::same))

(cl-peg:rule arrowgrams/prolog-peg::pNotUnifySame "! pNotSame '\\\\' '=' Spacing"
  (:lambda (x) (declare (ignore x)) 'arrowgrams/prolog-peg::not-unify-same))

(cl-peg:rule arrowgrams/prolog-peg::pUnifySame "!pSame !pLessEqual '=' Spacing"
  (:lambda (x) (declare (ignore x)) 'arrowgrams/prolog-peg::unify-same))

(cl-peg:rule arrowgrams/prolog-peg::pColonDash "':-' Spacing"
  (:lambda (x) (declare (ignore x)) 'arrowgrams/prolog-peg::colon-dash))

(cl-peg:rule arrowgrams/prolog-peg::pGreaterEqual "'>=' Spacing"
  (:lambda (x) (declare (ignore x)) 'arrowgrams/prolog-peg::greater-equal))

(cl-peg:rule arrowgrams/prolog-peg::pLessEqual "'=<' Spacing"
  (:lambda (x) (declare (ignore x)) 'arrowgrams/prolog-peg::less-equal))

(cl-peg:rule arrowgrams/prolog-peg::pCut "'!' Spacing"
  (:lambda (x) (declare (ignore x)) 'arrowgrams/prolog-peg::cut))

(cl-peg:rule arrowgrams/prolog-peg::pPeriod "[.] Spacing"
  (:lambda (x) (declare (ignore x)) 'arrowgrams/prolog-peg::dot))

(cl-peg:rule arrowgrams/prolog-peg::pComma "',' Spacing"
  (:lambda (x) (declare (ignore x)) 'arrowgrams/prolog-peg::comma))

(cl-peg:rule arrowgrams/prolog-peg::pLpar "'(' Spacing"
  (:lambda (x) (declare (ignore x)) 'arrowgrams/prolog-peg::lpar))

(cl-peg:rule arrowgrams/prolog-peg::pRpar "')' Spacing"
  (:lambda (x) (declare (ignore x)) 'arrowgrams/prolog-peg::rpar))

(cl-peg:rule arrowgrams/prolog-peg::pLBrack "'[' Spacing"
  (:lambda (x) (declare (ignore x)) 'arrowgrams/prolog-peg::l-bracket))

(cl-peg:rule arrowgrams/prolog-peg::pRBrack "']' Spacing"
  (:lambda (x) (declare (ignore x)) 'arrowgrams/prolog-peg::r-bracket))

(cl-peg:rule arrowgrams/prolog-peg::pMinus "'-' Spacing"
  (:lambda (x) (declare (ignore x)) 'arrowgrams/prolog-peg::minus))

(cl-peg:rule arrowgrams/prolog-peg::pPlus "'+' Spacing"
  (:lambda (x) (declare (ignore x)) 'arrowgrams/prolog-peg::plus))

(cl-peg:rule arrowgrams/prolog-peg::pAsterisk "'*' Spacing"
  (:lambda (x) (declare (ignore x)) 'arrowgrams/prolog-peg::mul))

(cl-peg:rule arrowgrams/prolog-peg::pSlash "'/' Spacing"
  (:lambda (x) (declare (ignore x)) 'arrowgrams/prolog-peg::div))

(cl-peg:rule arrowgrams/prolog-peg::pOrBar "'|' Spacing"
  (:lambda (x) (declare (ignore x)) 'arrowgrams/prolog-peg::or-bar))

