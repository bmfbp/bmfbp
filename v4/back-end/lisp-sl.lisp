(in-package :arrowgrams/compiler)

#+nil (eval-when (:compile-toplevel)

;; this version assumes that there is only one part with a given kind
;; and uses the kind as the part-name (whereas it should use a GENSYM or invented symbol)


  (defparameter *lisp-rules*
    "
= <ir> 
  :lpar                   '(' inc
    <top-name>
    <kind>                
    <metadata>
    <inputs>               nl
    <outputs>              nl
    <react> 
    <first-time> 
    <part-declarations> 
    <wiring>
                          ')' dec
  :rpar

= <top-name>
  :string                 print-text-as-symbol

= <inputs> 
  [ ?symbol :symbol symbol-must-be-nil  ' ()' | ?lpar :lpar inc ' (' <pin-list> :rpar dec ')']

= <outputs> 
  [ ?symbol :symbol symbol-must-be-nil ' ()' | ?lpar :lpar inc ' (' <pin-list> :rpar dec ')']

= <part-declarations> 
  :lpar nl <part-decl-list> :rpar

= <wiring> 
  :lpar                '\"' inc nl
    <wire-list>
  :rpar                '\"' dec

= <pin-list> 
  <ident-list>

= <ident-list> 
  :string                 print-text-as-keyword-symbol
  [ ?string ' ' <ident-list>]

= <part-decl-list> 
  [ ?lpar <part-decl> [ ?lpar <part-decl-list> ] | ! ]

= <part-decl>
  :lpar                  '(:code ' inc
  <name>                 memo-symbol
  <kind>                 print-text-as-symbol associate-kind-name-with-memo
  <inputs> 
  <outputs> 
  <react> 
  <first-time> 
  :rpar                   dec ')' nl

= <name>
  :string                

= <metadata>
  :string                nl ':metadata ' print-text-as-string nl nl

= <kind>
  :string

= <react>
  :string

= <first-time>
  :string

= <wire-list>
  <wire> [ ?lpar <wire-list> ] 

= <wire>
  :lpar
    :integer
    :lpar <part-pin-list> :rpar
                                 ' -> '
    :lpar <part-pin-list> :rpar  
                                  nl
  :rpar

= <part-pin-list> 
  :lpar <part> <pin> :rpar 
  [ ?lpar ',' <part-pin-list> ]

= <part>
  :string                 print-kind-instead-of-symbol
= <pin>
  :string                 '.' print-text-as-symbol
"
    )

#+nil  (defmacro xxx () (sl:parse *lisp-rules* "-LISP")))

#+nil (xxx)

#+nil (sl:parse *lisp-rules* "-LISP")

(PROGN
 (DEFMETHOD IR-LISP ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'IR-LISP))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :LPAR)
     (OUTPUT P "(")
     (CALL-EXTERNAL P #'INC DEPTH CURRENT-METHOD)
     (CALL-RULE P #'TOP-NAME-LISP DEPTH CURRENT-METHOD)
     (CALL-RULE P #'KIND-LISP DEPTH CURRENT-METHOD)
     (CALL-RULE P #'METADATA-LISP DEPTH CURRENT-METHOD)
     (CALL-RULE P #'INPUTS-LISP DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (CALL-RULE P #'OUTPUTS-LISP DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (CALL-RULE P #'REACT-LISP DEPTH CURRENT-METHOD)
     (CALL-RULE P #'FIRST-TIME-LISP DEPTH CURRENT-METHOD)
     (CALL-RULE P #'PART-DECLARATIONS-LISP DEPTH CURRENT-METHOD)
     (CALL-RULE P #'WIRING-LISP DEPTH CURRENT-METHOD)
     (OUTPUT P ")")
     (CALL-EXTERNAL P #'DEC DEPTH CURRENT-METHOD)
     (MUST-SEE P :RPAR)))
 (DEFMETHOD TOP-NAME-LISP ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'TOP-NAME-LISP))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)
     (CALL-EXTERNAL P #'PRINT-TEXT-AS-SYMBOL DEPTH CURRENT-METHOD)))
 (DEFMETHOD INPUTS-LISP ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'INPUTS-LISP))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (COND
      ((LOOK-AHEAD P :SYMBOL) (MUST-SEE P :SYMBOL)
       (CALL-EXTERNAL P #'SYMBOL-MUST-BE-NIL DEPTH CURRENT-METHOD)
       (OUTPUT P " ()"))
      ((LOOK-AHEAD P :LPAR) (MUST-SEE P :LPAR)
       (CALL-EXTERNAL P #'INC DEPTH CURRENT-METHOD) (OUTPUT P " (")
       (CALL-RULE P #'PIN-LIST-LISP DEPTH CURRENT-METHOD) (MUST-SEE P :RPAR)
       (CALL-EXTERNAL P #'DEC DEPTH CURRENT-METHOD) (OUTPUT P ")")))))
 (DEFMETHOD OUTPUTS-LISP ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'OUTPUTS-LISP))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (COND
      ((LOOK-AHEAD P :SYMBOL) (MUST-SEE P :SYMBOL)
       (CALL-EXTERNAL P #'SYMBOL-MUST-BE-NIL DEPTH CURRENT-METHOD)
       (OUTPUT P " ()"))
      ((LOOK-AHEAD P :LPAR) (MUST-SEE P :LPAR)
       (CALL-EXTERNAL P #'INC DEPTH CURRENT-METHOD) (OUTPUT P " (")
       (CALL-RULE P #'PIN-LIST-LISP DEPTH CURRENT-METHOD) (MUST-SEE P :RPAR)
       (CALL-EXTERNAL P #'DEC DEPTH CURRENT-METHOD) (OUTPUT P ")")))))
 (DEFMETHOD PART-DECLARATIONS-LISP ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'PART-DECLARATIONS-LISP))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :LPAR)
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (CALL-RULE P #'PART-DECL-LIST-LISP DEPTH CURRENT-METHOD)
     (MUST-SEE P :RPAR)))
 (DEFMETHOD WIRING-LISP ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'WIRING-LISP))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :LPAR)
     (OUTPUT P "\"")
     (CALL-EXTERNAL P #'INC DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (CALL-RULE P #'WIRE-LIST-LISP DEPTH CURRENT-METHOD)
     (MUST-SEE P :RPAR)
     (OUTPUT P "\"")
     (CALL-EXTERNAL P #'DEC DEPTH CURRENT-METHOD)))
 (DEFMETHOD PIN-LIST-LISP ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'PIN-LIST-LISP))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (CALL-RULE P #'IDENT-LIST-LISP DEPTH CURRENT-METHOD)))
 (DEFMETHOD IDENT-LIST-LISP ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'IDENT-LIST-LISP))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)
     (CALL-EXTERNAL P #'PRINT-TEXT-AS-KEYWORD-SYMBOL DEPTH CURRENT-METHOD)
     (COND
      ((LOOK-AHEAD P :STRING) (OUTPUT P " ")
       (CALL-RULE P #'IDENT-LIST-LISP DEPTH CURRENT-METHOD)))))
 (DEFMETHOD PART-DECL-LIST-LISP ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'PART-DECL-LIST-LISP))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (COND
      ((LOOK-AHEAD P :LPAR) (CALL-RULE P #'PART-DECL-LISP DEPTH CURRENT-METHOD)
       (COND
        ((LOOK-AHEAD P :LPAR)
         (CALL-RULE P #'PART-DECL-LIST-LISP DEPTH CURRENT-METHOD))))
      (T))))
 (DEFMETHOD PART-DECL-LISP ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'PART-DECL-LISP))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :LPAR)
     (OUTPUT P "(:code ")
     (CALL-EXTERNAL P #'INC DEPTH CURRENT-METHOD)
     (CALL-RULE P #'NAME-LISP DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'MEMO-SYMBOL DEPTH CURRENT-METHOD)
     (CALL-RULE P #'KIND-LISP DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'PRINT-TEXT-AS-SYMBOL DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'ASSOCIATE-KIND-NAME-WITH-MEMO DEPTH CURRENT-METHOD)
     (CALL-RULE P #'INPUTS-LISP DEPTH CURRENT-METHOD)
     (CALL-RULE P #'OUTPUTS-LISP DEPTH CURRENT-METHOD)
     (CALL-RULE P #'REACT-LISP DEPTH CURRENT-METHOD)
     (CALL-RULE P #'FIRST-TIME-LISP DEPTH CURRENT-METHOD)
     (MUST-SEE P :RPAR)
     (CALL-EXTERNAL P #'DEC DEPTH CURRENT-METHOD)
     (OUTPUT P ")")
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)))
 (DEFMETHOD NAME-LISP ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'NAME-LISP))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)))
 (DEFMETHOD METADATA-LISP ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'METADATA-LISP))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (OUTPUT P ":metadata ")
     (CALL-EXTERNAL P #'PRINT-TEXT-AS-STRING DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)))
 (DEFMETHOD KIND-LISP ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'KIND-LISP))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)))
 (DEFMETHOD REACT-LISP ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'REACT-LISP))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)))
 (DEFMETHOD FIRST-TIME-LISP ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'FIRST-TIME-LISP))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)))
 (DEFMETHOD WIRE-LIST-LISP ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'WIRE-LIST-LISP))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (CALL-RULE P #'WIRE-LISP DEPTH CURRENT-METHOD)
     (COND
      ((LOOK-AHEAD P :LPAR)
       (CALL-RULE P #'WIRE-LIST-LISP DEPTH CURRENT-METHOD)))))
 (DEFMETHOD WIRE-LISP ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'WIRE-LISP))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :LPAR)
     (MUST-SEE P :INTEGER)
     (MUST-SEE P :LPAR)
     (CALL-RULE P #'PART-PIN-LIST-LISP DEPTH CURRENT-METHOD)
     (MUST-SEE P :RPAR)
     (OUTPUT P " -> ")
     (MUST-SEE P :LPAR)
     (CALL-RULE P #'PART-PIN-LIST-LISP DEPTH CURRENT-METHOD)
     (MUST-SEE P :RPAR)
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (MUST-SEE P :RPAR)))
 (DEFMETHOD PART-PIN-LIST-LISP ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'PART-PIN-LIST-LISP))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :LPAR)
     (CALL-RULE P #'PART-LISP DEPTH CURRENT-METHOD)
     (CALL-RULE P #'PIN-LISP DEPTH CURRENT-METHOD)
     (MUST-SEE P :RPAR)
     (COND
      ((LOOK-AHEAD P :LPAR) (OUTPUT P ",")
       (CALL-RULE P #'PART-PIN-LIST-LISP DEPTH CURRENT-METHOD)))))
 (DEFMETHOD PART-LISP ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'PART-LISP))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)
     (CALL-EXTERNAL P #'PRINT-KIND-INSTEAD-OF-SYMBOL DEPTH CURRENT-METHOD)))
 (DEFMETHOD PIN-LISP ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'PIN-LISP))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)
     (OUTPUT P ".")
     (CALL-EXTERNAL P #'PRINT-TEXT-AS-SYMBOL DEPTH CURRENT-METHOD))))
