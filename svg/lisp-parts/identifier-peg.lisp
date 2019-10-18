(eval-when (:compile-toplevel :load-toplevel :execute)
  (peg:into-package "PROLOG"))

(peg:rule prolog::Identifier "(QuotedAtom / Identifier1) Spacing"
  (:destructure (id spc)
   (declare (ignore spc))
   id))

(peg:rule prolog::QuotedAtom "['] NoQuotes+ [']"
  (:destructure (q1 chars q2)
     (declare (ignore q1 q2))
     chars))

(peg:rule prolog::NoQuotes "! ['] ."
  (:destructure (nq ch)
     (declare (ignore nq))
     ch))

(peg:rule prolog::Identifier1 "! pKeyword FirstIdentCharacter FollowingIdentCharacter*"
  (:destructure (nothing firstChar followChars)
   (declare (ignore nothing))
   (intern (string-upcase (esrap:text firstChar followChars)) "PROLOG")))

(peg:rule prolog::pVariable "(Variable1a / Variable1b) Spacing"
  (:destructure (id spc)
   (declare (ignore spc))
   id))

(peg:rule prolog::Variable1a "! pKeyword FirstVariableCharacter FollowingIdentCharacter*"
  (:destructure (nothing firstChar followChars)
   (declare (ignore nothing))
   (intern (concatenate 'string "?"
                        (string-upcase (esrap:text firstChar followChars)))
           "PROLOG")))

(peg:rule prolog::Variable1b "'_'"
   (:lambda (c)
     (declare (ignore c))
     (intern "?" "PROLOG")))

(peg:rule prolog::FirstVariableCharacter "[A-Z]"
   (:lambda (c) c))

(peg:rule prolog::FirstIdentCharacter "[a-z]"
 (:lambda (c)
   c))

(peg:rule prolog::FollowingIdentCharacter "[_A-Za-z0-9]"
 (:lambda (c)
   c))

