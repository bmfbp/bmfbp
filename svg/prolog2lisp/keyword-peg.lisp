(eval-when (:compile-toplevel :load-toplevel :execute)
  (cl-peg:into-package "ARROWGRAMS/PROLOG-PEG"))

;; not all of these are Prolog keywords, some are just convenience matches for
;; the working code base
(cl-peg:rule arrowgrams/prolog-peg::pKeyword "pTrue / pFail / pIs / pColonDash / pNot / pNotSame / pSame / pNotUnifySame / pUnifySame / pGreaterEqual / pLessEqual / pCut / pPeriod / pComma / pLpar / pRpar / pLBRack / pRBrack / pUserError / pCurrentInput / pUserInput / pMinus / pPlus / pAsterisk / pSlash"
  (:lambda (x) x))

#|

(cl-peg:rule arrowgrams/prolog-peg::pAssert "'assert' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::assert))

(cl-peg:rule arrowgrams/prolog-peg::pRetract "'retract' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::retract))

(cl-peg:rule arrowgrams/prolog-peg::pForall "'forall' Spacing"
  (:lambda (x) (declare (ignore x)) 'prolog::forall))

|#


(cl-peg:rule arrowgrams/prolog-peg::pUserError "'user_error' Spacing"
  (:lambda (x) (declare (ignore x)) (list :keyword 'prolog::user-error)))

(cl-peg:rule arrowgrams/prolog-peg::pCurrentInput "'current_input' Spacing"
  (:lambda (x) (declare (ignore x)) (list :keyword 'prolog::current-input))

(cl-peg:rule arrowgrams/prolog-peg::pUserInput "'user_input' Spacing"
  (:lambda (x) (declare (ignore x)) (list :keyword 'prolog::user-input))

(cl-peg:rule arrowgrams/prolog-peg::pFail "'fail' Spacing"
  (:lambda (x) (declare (ignore x)) (list :keyword 'prolog::pl-fail))

(cl-peg:rule arrowgrams/prolog-peg::pTrue "'true' Spacing"
  (:lambda (x) (declare (ignore x)) (list :keyword 'prolog::pl-true))

(cl-peg:rule arrowgrams/prolog-peg::pKWID "pTrue / pFail / pUserError / pCurrentInput / pUserInput"
  (:lambda (x) x))

(cl-peg:rule arrowgrams/prolog-peg::pIs "'is' Spacing"
  (:lambda (x) (declare (ignore x)) (list :keyword 'prolog::pl-is))

(cl-peg:rule arrowgrams/prolog-peg::pNot "'\\\\\+' Spacing"
  (:lambda (x) (declare (ignore x)) (list :keyword 'prolog::pl-not))

(cl-peg:rule arrowgrams/prolog-peg::pNotSame "[\\\\] '==' Spacing"
  (:lambda (x) (declare (ignore x)) (list :keyword 'prolog::not-same))

(cl-peg:rule arrowgrams/prolog-peg::pSame " '==' Spacing"
  (:lambda (x) (declare (ignore x)) (list :keyword 'prolog::same))

(cl-peg:rule arrowgrams/prolog-peg::pNotUnifySame "! pNotSame '\\\\' '=' Spacing"
  (:lambda (x) (declare (ignore x)) (list :keyword 'prolog::not-unify-same))

(cl-peg:rule arrowgrams/prolog-peg::pUnifySame "!pSame !pLessEqual '=' Spacing"
  (:lambda (x) (declare (ignore x)) (list :keyword 'prolog::unify-same))

(cl-peg:rule arrowgrams/prolog-peg::pColonDash "':-' Spacing"
  (:lambda (x) (declare (ignore x)) (list :keyword 'prolog::colon-dash))

(cl-peg:rule arrowgrams/prolog-peg::pGreaterEqual "'>=' Spacing"
  (:lambda (x) (declare (ignore x)) (list :keyword 'prolog::greater-equal))

(cl-peg:rule arrowgrams/prolog-peg::pLessEqual "'=<' Spacing"
  (:lambda (x) (declare (ignore x)) (list :keyword 'prolog::less-equal))

(cl-peg:rule arrowgrams/prolog-peg::pCut "'!' Spacing"
  (:lambda (x) (declare (ignore x)) (list :keyword 'prolog::cut))

(cl-peg:rule arrowgrams/prolog-peg::pPeriod "[.] Spacing"
  (:lambda (x) (declare (ignore x)) (list :keyword 'prolog::dot))

(cl-peg:rule arrowgrams/prolog-peg::pComma "',' Spacing"
  (:lambda (x) (declare (ignore x)) (list :keyword 'prolog::comma))

(cl-peg:rule arrowgrams/prolog-peg::pLpar "'(' Spacing"
  (:lambda (x) (declare (ignore x)) (list :keyword 'prolog::lpar))

(cl-peg:rule arrowgrams/prolog-peg::pRpar "')' Spacing"
  (:lambda (x) (declare (ignore x)) (list :keyword 'prolog::rpar))

(cl-peg:rule arrowgrams/prolog-peg::pLBrack "'[' Spacing"
  (:lambda (x) (declare (ignore x)) (list :keyword 'prolog::l-bracket))

(cl-peg:rule arrowgrams/prolog-peg::pRBrack "']' Spacing"
  (:lambda (x) (declare (ignore x)) (list :keyword 'prolog::r-bracket))

(cl-peg:rule arrowgrams/prolog-peg::pMinus "'-' Spacing"
  (:lambda (x) (declare (ignore x)) (list :keyword 'prolog::minus))

(cl-peg:rule arrowgrams/prolog-peg::pPlus "'+' Spacing"
  (:lambda (x) (declare (ignore x)) (list :keyword 'prolog::plus))

(cl-peg:rule arrowgrams/prolog-peg::pAsterisk "'*' Spacing"
  (:lambda (x) (declare (ignore x)) (list :keyword 'prolog::mul))

(cl-peg:rule arrowgrams/prolog-peg::pSlash "'/' Spacing"
  (:lambda (x) (declare (ignore x)) (list :keyword 'prolog::div))

(cl-peg:rule arrowgrams/prolog-peg::pOrBar "'|' Spacing"
  (:lambda (x) (declare (ignore x)) (list :keyword 'prolog::or-bar))

