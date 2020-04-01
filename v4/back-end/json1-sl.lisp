(in-package :arrowgrams/compiler)

#+nil (eval-when (:compile-toplevel)

;; this version assumes that there is only one part with a given kind
;; and uses the kind as the part-name (whereas it should use a GENSYM or invented symbol)


  (defparameter *json1-rules*
    "
= <ir> 
  :lpar                   
                          '{' inc nl '\"name\" : '
    <top-name>
                          ',' nl
    <kind>                
    <metadata>
                          '\"inputs\" : ['
    <toplevel-inputs>
                          '],' nl
                          '\"outputs\" : ['
    <toplevel-outputs>
                          '],' nl
    <react> 
    <first-time>
    <part-declarations> 
    <wiring>
                          nl dec '}'
  :rpar

= <top-name>
  :string                 print-text

= <toplevel-inputs> 
  [ ?symbol :symbol symbol-must-be-nil | ?lpar :lpar inc <pin-list> :rpar dec]

= <toplevel-outputs> 
  [ ?symbol :symbol symbol-must-be-nil | ?lpar :lpar inc <pin-list> :rpar dec]

= <part-declarations> 
  :lpar
                       '\"parts\" :' nl '[' inc nl
  <part-decl-list>
  :rpar 
                       dec nl '],'

= <inputs> 
  [ ?symbol :symbol symbol-must-be-nil | ?lpar :lpar <pin-list> :rpar]

= <outputs> 
  [ ?symbol :symbol symbol-must-be-nil | ?lpar :lpar <pin-list> :rpar]

= <wiring> 
  :lpar                nl '\"wiring\" :' inc nl inc
                            '[' nl
    <wire-list>
  :rpar                dec nl ']' dec

= <pin-list> 
  <ident-list>

= <ident-list> 
  :string                 '\"' print-text-as-symbol '\"'
  [ ?string ', ' <ident-list>]

= <part-decl-list> 
  [ ?lpar <part-decl> [ ?lpar ',' nl <part-decl-list> ] | ! ]

= <part-decl>
  :lpar                  
                         '{ \"partName\" : '
  <name>                 memo-symbol
  <kind>
                         '\"' print-text-as-symbol '\",' associate-kind-name-with-memo
                         ' \"kindName\" : \"' print-text-as-symbol '\"}'
  <inputs-for-part-decl> 
  <outputs-for-part-decl> 
  <react> 
  <first-time> 
  :rpar                   

= <inputs-for-part-decl> 
  [ ?symbol :symbol symbol-must-be-nil | ?lpar :lpar <pin-list-for-part-decl> :rpar]

= <outputs-for-part-decl> 
  [ ?symbol :symbol symbol-must-be-nil | ?lpar :lpar <pin-list-for-part-decl> :rpar]

= <pin-list-for-part-decl> 
  <ident-list-for-part-decl>

= <ident-list-for-part-decl> 
  :string
  [ ?string <ident-list-for-part-decl>]

= <name>
  :string                

= <metadata>
  :string

= <kind>
  :string

= <react>
  :string

= <first-time>
  :string

= <wire-list>
  '{' <wire> '}'
  [ ?lpar ',' nl <wire-list> ]
  

= <wire>
  :lpar
    :integer  '\"wire-index\" : ' print-text 
    :lpar ', \"sources\" : [' <part-pin-list> :rpar ']'
                         
    :lpar ', \"receivers\" : [' <part-pin-list> :rpar ']'  
  :rpar

= <part-pin-list> 
  :lpar 
                       '{\"part\" : \"' 
  <part>
                       '\", \"pin\" : \"'
  <pin> 
  :rpar 
                       '\"}'
  [ ?lpar ',' <part-pin-list> ]

= <part>
  :string                 print-kind-instead-of-symbol
= <pin>
  :string                 print-text-as-symbol
"
    )

#+nil  (defmacro xxx4 () (sl:parse *json1-rules* "-JSON1")))

#+nil (xxx4)

#+nil (sl:parse *json1-rules* "-JSON1")

(PROGN
 (DEFMETHOD IR-JSON1 ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'IR-JSON1))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :LPAR)
     (OUTPUT P "{")
     (CALL-EXTERNAL P #'INC DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (OUTPUT P "\"name\" : ")
     (CALL-RULE P #'TOP-NAME-JSON1 DEPTH CURRENT-METHOD)
     (OUTPUT P ",")
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (CALL-RULE P #'KIND-JSON1 DEPTH CURRENT-METHOD)
     (CALL-RULE P #'METADATA-JSON1 DEPTH CURRENT-METHOD)
     (OUTPUT P "\"inputs\" : [")
     (CALL-RULE P #'TOPLEVEL-INPUTS-JSON1 DEPTH CURRENT-METHOD)
     (OUTPUT P "],")
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (OUTPUT P "\"outputs\" : [")
     (CALL-RULE P #'TOPLEVEL-OUTPUTS-JSON1 DEPTH CURRENT-METHOD)
     (OUTPUT P "],")
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (CALL-RULE P #'REACT-JSON1 DEPTH CURRENT-METHOD)
     (CALL-RULE P #'FIRST-TIME-JSON1 DEPTH CURRENT-METHOD)
     (CALL-RULE P #'PART-DECLARATIONS-JSON1 DEPTH CURRENT-METHOD)
     (CALL-RULE P #'WIRING-JSON1 DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'DEC DEPTH CURRENT-METHOD)
     (OUTPUT P "}")
     (MUST-SEE P :RPAR)))
 (DEFMETHOD TOP-NAME-JSON1 ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'TOP-NAME-JSON1))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)
     (CALL-EXTERNAL P #'PRINT-TEXT DEPTH CURRENT-METHOD)))
 (DEFMETHOD TOPLEVEL-INPUTS-JSON1 ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'TOPLEVEL-INPUTS-JSON1))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (COND
      ((LOOK-AHEAD P :SYMBOL) (MUST-SEE P :SYMBOL)
       (CALL-EXTERNAL P #'SYMBOL-MUST-BE-NIL DEPTH CURRENT-METHOD))
      ((LOOK-AHEAD P :LPAR) (MUST-SEE P :LPAR)
       (CALL-EXTERNAL P #'INC DEPTH CURRENT-METHOD)
       (CALL-RULE P #'PIN-LIST-JSON1 DEPTH CURRENT-METHOD) (MUST-SEE P :RPAR)
       (CALL-EXTERNAL P #'DEC DEPTH CURRENT-METHOD)))))
 (DEFMETHOD TOPLEVEL-OUTPUTS-JSON1 ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'TOPLEVEL-OUTPUTS-JSON1))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (COND
      ((LOOK-AHEAD P :SYMBOL) (MUST-SEE P :SYMBOL)
       (CALL-EXTERNAL P #'SYMBOL-MUST-BE-NIL DEPTH CURRENT-METHOD))
      ((LOOK-AHEAD P :LPAR) (MUST-SEE P :LPAR)
       (CALL-EXTERNAL P #'INC DEPTH CURRENT-METHOD)
       (CALL-RULE P #'PIN-LIST-JSON1 DEPTH CURRENT-METHOD) (MUST-SEE P :RPAR)
       (CALL-EXTERNAL P #'DEC DEPTH CURRENT-METHOD)))))
 (DEFMETHOD PART-DECLARATIONS-JSON1 ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'PART-DECLARATIONS-JSON1))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :LPAR)
     (OUTPUT P "\"parts\" :")
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (OUTPUT P "[")
     (CALL-EXTERNAL P #'INC DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (CALL-RULE P #'PART-DECL-LIST-JSON1 DEPTH CURRENT-METHOD)
     (MUST-SEE P :RPAR)
     (CALL-EXTERNAL P #'DEC DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (OUTPUT P "],")))
 (DEFMETHOD INPUTS-JSON1 ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'INPUTS-JSON1))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (COND
      ((LOOK-AHEAD P :SYMBOL) (MUST-SEE P :SYMBOL)
       (CALL-EXTERNAL P #'SYMBOL-MUST-BE-NIL DEPTH CURRENT-METHOD))
      ((LOOK-AHEAD P :LPAR) (MUST-SEE P :LPAR)
       (CALL-RULE P #'PIN-LIST-JSON1 DEPTH CURRENT-METHOD)
       (MUST-SEE P :RPAR)))))
 (DEFMETHOD OUTPUTS-JSON1 ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'OUTPUTS-JSON1))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (COND
      ((LOOK-AHEAD P :SYMBOL) (MUST-SEE P :SYMBOL)
       (CALL-EXTERNAL P #'SYMBOL-MUST-BE-NIL DEPTH CURRENT-METHOD))
      ((LOOK-AHEAD P :LPAR) (MUST-SEE P :LPAR)
       (CALL-RULE P #'PIN-LIST-JSON1 DEPTH CURRENT-METHOD)
       (MUST-SEE P :RPAR)))))
 (DEFMETHOD WIRING-JSON1 ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'WIRING-JSON1))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :LPAR)
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (OUTPUT P "\"wiring\" :")
     (CALL-EXTERNAL P #'INC DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'INC DEPTH CURRENT-METHOD)
     (OUTPUT P "[")
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (CALL-RULE P #'WIRE-LIST-JSON1 DEPTH CURRENT-METHOD)
     (MUST-SEE P :RPAR)
     (CALL-EXTERNAL P #'DEC DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (OUTPUT P "]")
     (CALL-EXTERNAL P #'DEC DEPTH CURRENT-METHOD)))
 (DEFMETHOD PIN-LIST-JSON1 ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'PIN-LIST-JSON1))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (CALL-RULE P #'IDENT-LIST-JSON1 DEPTH CURRENT-METHOD)))
 (DEFMETHOD IDENT-LIST-JSON1 ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'IDENT-LIST-JSON1))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)
     (OUTPUT P "\"")
     (CALL-EXTERNAL P #'PRINT-TEXT-AS-SYMBOL DEPTH CURRENT-METHOD)
     (OUTPUT P "\"")
     (COND
      ((LOOK-AHEAD P :STRING) (OUTPUT P ", ")
       (CALL-RULE P #'IDENT-LIST-JSON1 DEPTH CURRENT-METHOD)))))
 (DEFMETHOD PART-DECL-LIST-JSON1 ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'PART-DECL-LIST-JSON1))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (COND
      ((LOOK-AHEAD P :LPAR)
       (CALL-RULE P #'PART-DECL-JSON1 DEPTH CURRENT-METHOD)
       (COND
        ((LOOK-AHEAD P :LPAR) (OUTPUT P ",")
         (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
         (CALL-RULE P #'PART-DECL-LIST-JSON1 DEPTH CURRENT-METHOD))))
      (T))))
 (DEFMETHOD PART-DECL-JSON1 ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'PART-DECL-JSON1))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :LPAR)
     (OUTPUT P "{ \"partName\" : ")
     (CALL-RULE P #'NAME-JSON1 DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'MEMO-SYMBOL DEPTH CURRENT-METHOD)
     (CALL-RULE P #'KIND-JSON1 DEPTH CURRENT-METHOD)
     (OUTPUT P "\"")
     (CALL-EXTERNAL P #'PRINT-TEXT-AS-SYMBOL DEPTH CURRENT-METHOD)
     (OUTPUT P "\",")
     (CALL-EXTERNAL P #'ASSOCIATE-KIND-NAME-WITH-MEMO DEPTH CURRENT-METHOD)
     (OUTPUT P " \"kindName\" : \"")
     (CALL-EXTERNAL P #'PRINT-TEXT-AS-SYMBOL DEPTH CURRENT-METHOD)
     (OUTPUT P "\"}")
     (CALL-RULE P #'INPUTS-FOR-PART-DECL-JSON1 DEPTH CURRENT-METHOD)
     (CALL-RULE P #'OUTPUTS-FOR-PART-DECL-JSON1 DEPTH CURRENT-METHOD)
     (CALL-RULE P #'REACT-JSON1 DEPTH CURRENT-METHOD)
     (CALL-RULE P #'FIRST-TIME-JSON1 DEPTH CURRENT-METHOD)
     (MUST-SEE P :RPAR)))
 (DEFMETHOD INPUTS-FOR-PART-DECL-JSON1 ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'INPUTS-FOR-PART-DECL-JSON1))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (COND
      ((LOOK-AHEAD P :SYMBOL) (MUST-SEE P :SYMBOL)
       (CALL-EXTERNAL P #'SYMBOL-MUST-BE-NIL DEPTH CURRENT-METHOD))
      ((LOOK-AHEAD P :LPAR) (MUST-SEE P :LPAR)
       (CALL-RULE P #'PIN-LIST-FOR-PART-DECL-JSON1 DEPTH CURRENT-METHOD)
       (MUST-SEE P :RPAR)))))
 (DEFMETHOD OUTPUTS-FOR-PART-DECL-JSON1 ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'OUTPUTS-FOR-PART-DECL-JSON1))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (COND
      ((LOOK-AHEAD P :SYMBOL) (MUST-SEE P :SYMBOL)
       (CALL-EXTERNAL P #'SYMBOL-MUST-BE-NIL DEPTH CURRENT-METHOD))
      ((LOOK-AHEAD P :LPAR) (MUST-SEE P :LPAR)
       (CALL-RULE P #'PIN-LIST-FOR-PART-DECL-JSON1 DEPTH CURRENT-METHOD)
       (MUST-SEE P :RPAR)))))
 (DEFMETHOD PIN-LIST-FOR-PART-DECL-JSON1 ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'PIN-LIST-FOR-PART-DECL-JSON1))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (CALL-RULE P #'IDENT-LIST-FOR-PART-DECL-JSON1 DEPTH CURRENT-METHOD)))
 (DEFMETHOD IDENT-LIST-FOR-PART-DECL-JSON1 ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'IDENT-LIST-FOR-PART-DECL-JSON1))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)
     (COND
      ((LOOK-AHEAD P :STRING)
       (CALL-RULE P #'IDENT-LIST-FOR-PART-DECL-JSON1 DEPTH CURRENT-METHOD)))))
 (DEFMETHOD NAME-JSON1 ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'NAME-JSON1))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)))
 (DEFMETHOD METADATA-JSON1 ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'METADATA-JSON1))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)))
 (DEFMETHOD KIND-JSON1 ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'KIND-JSON1))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)))
 (DEFMETHOD REACT-JSON1 ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'REACT-JSON1))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)))
 (DEFMETHOD FIRST-TIME-JSON1 ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'FIRST-TIME-JSON1))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)))
 (DEFMETHOD WIRE-LIST-JSON1 ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'WIRE-LIST-JSON1))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (OUTPUT P "{")
     (CALL-RULE P #'WIRE-JSON1 DEPTH CURRENT-METHOD)
     (OUTPUT P "}")
     (COND
      ((LOOK-AHEAD P :LPAR) (OUTPUT P ",")
       (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
       (CALL-RULE P #'WIRE-LIST-JSON1 DEPTH CURRENT-METHOD)))))
 (DEFMETHOD WIRE-JSON1 ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'WIRE-JSON1))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :LPAR)
     (MUST-SEE P :INTEGER)
     (OUTPUT P "\"wire-index\" : ")
     (CALL-EXTERNAL P #'PRINT-TEXT DEPTH CURRENT-METHOD)
     (MUST-SEE P :LPAR)
     (OUTPUT P ", \"sources\" : [")
     (CALL-RULE P #'PART-PIN-LIST-JSON1 DEPTH CURRENT-METHOD)
     (MUST-SEE P :RPAR)
     (OUTPUT P "]")
     (MUST-SEE P :LPAR)
     (OUTPUT P ", \"receivers\" : [")
     (CALL-RULE P #'PART-PIN-LIST-JSON1 DEPTH CURRENT-METHOD)
     (MUST-SEE P :RPAR)
     (OUTPUT P "]")
     (MUST-SEE P :RPAR)))
 (DEFMETHOD PART-PIN-LIST-JSON1 ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'PART-PIN-LIST-JSON1))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :LPAR)
     (OUTPUT P "{\"part\" : \"")
     (CALL-RULE P #'PART-JSON1 DEPTH CURRENT-METHOD)
     (OUTPUT P "\", \"pin\" : \"")
     (CALL-RULE P #'PIN-JSON1 DEPTH CURRENT-METHOD)
     (MUST-SEE P :RPAR)
     (OUTPUT P "\"}")
     (COND
      ((LOOK-AHEAD P :LPAR) (OUTPUT P ",")
       (CALL-RULE P #'PART-PIN-LIST-JSON1 DEPTH CURRENT-METHOD)))))
 (DEFMETHOD PART-JSON1 ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'PART-JSON1))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)
     (CALL-EXTERNAL P #'PRINT-KIND-INSTEAD-OF-SYMBOL DEPTH CURRENT-METHOD)))
 (DEFMETHOD PIN-JSON1 ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'PIN-JSON1))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)
     (CALL-EXTERNAL P #'PRINT-TEXT-AS-SYMBOL DEPTH CURRENT-METHOD))))
