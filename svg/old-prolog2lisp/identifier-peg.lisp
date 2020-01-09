(eval-when (:compile-toplevel :load-toplevel :execute)
  (cl-peg:into-package "ARROWGRAMS/PROLOG-PEG"))

(cl-peg:rule arrowgrams/prolog-peg::pIdentifier "(QuotedAtom / Identifier1) Spacing"
  (:destructure (id spc)
   (declare (ignore spc))
   (list :identifier id)))

(cl-peg:rule arrowgrams/prolog-peg::QuotedAtom "['] NoQuotes+ [']"
  (:destructure (q1 chars q2)
     (declare (ignore q1 q2))
     (esrap:text chars)))

(cl-peg:rule arrowgrams/prolog-peg::NoQuotes "! ['] ."
  (:destructure (nq ch)
     (declare (ignore nq))
     ch))

(cl-peg:rule arrowgrams/prolog-peg::Identifier1 "! pKeyword FirstIdentCharacter FollowingIdentCharacter*"
  (:destructure (nothing firstChar followChars)
   (declare (ignore nothing))
   (intern (string-upcase (esrap:text firstChar followChars)) "KEYWORD")))

(cl-peg:rule arrowgrams/prolog-peg::pVariable "(Variable1a / Variable1b) Spacing"
  (:destructure (id spc)
   (declare (ignore spc))
   (list :variable id)))

(cl-peg:rule arrowgrams/prolog-peg::Variable1a "! pKeyword FirstVariableCharacter FollowingIdentCharacter*"
  (:destructure (nothing firstChar followChars)
   (declare (ignore nothing))
   (multiple-value-bind (sym status)
       (intern (concatenate 'string 
                            (string-upcase (esrap:text firstChar followChars)))
               "KEYWORD")
     (declare (ignore status))
     sym)))

(cl-peg:rule arrowgrams/prolog-peg::Variable1b "'_'"
   (:lambda (c)
     (declare (ignore c))
     (multiple-value-bind (sym status)
         (intern "_" "KEYWORD")
       (declare (ignore status))
       sym)))
                

(cl-peg:rule arrowgrams/prolog-peg::FirstVariableCharacter "[A-Z]"
   (:lambda (c) c))

(cl-peg:rule arrowgrams/prolog-peg::FirstIdentCharacter "[a-z]"
 (:lambda (c)
   c))

(cl-peg:rule arrowgrams/prolog-peg::FollowingIdentCharacter "[_A-Za-z0-9]"
 (:lambda (c)
   c))

