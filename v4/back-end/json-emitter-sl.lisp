(In-package :arrowgrams/compiler)

#+nil (eval-when (:compile-toplevel)
  
  (defparameter *json-emitter-rules*
    "
= <schematic>
                   '{' inc nl
  <top-name>       '\"name\" : ' print-text ',' nl
  <kind>           '\"kindName\" : ' print-text ',' nl
  <metadata>       '\"metadata\" : ' print-text ',' nl
  <top-level-inputs>
  <top-level-outputs>
  <react>
  <first-time>
  :integer '\"wireCount\" : ' print-integer ', ' nl
  '\"parts\" : {' inc nl
  <parts>
               dec nl '}'
dec nl
'}'

= <top-name>
  :string

= <metadata>
  :string

= <kind>
  :string

= <react>
  :string

= <first-time>
  :string

= <top-level-inputs>
  :inputs                     '\"inputs\" : ['
  <top-level-list-of-strings>
  :end                        '],' nl

= <top-level-outputs>
  :outputs                    '\"outputs\" : ['
  <top-level-list-of-strings>
  :end                        '],' nl

= <top-level-list-of-strings>
  [ ?string :string           '\"' print-text '\"' [ ?string ',' | ! ]
    <top-level-list-of-strings>
  | ! ]



= <inputs>
  :inputs
  <list-of-strings>
  :end

= <outputs>
  :outputs
  <list-of-strings>
  :end

= <list-of-strings>
  [ ?string :string <list-of-strings>
  | ! ]

= <parts>
  '{' inc nl
  :string '\"partName\" : \"' print-text '\", ' nl
  :string '\"kindName\" : \"' print-text '\", ' nl
  <incount>
  <inmap>
  :inputs '\"inPins\" : [' <multiple-pins-with-indices> '],' nl :end
  <outcount>
  <outmap>
  :outputs '\"outPins\" : [' <multiple-pins-with-indices> ']' :end
  [ ?string dec nl '},' nl <parts>
  | !
    dec nl 
    '}'
  ]

= <incount>
  :integer '\"inCount\" : ' print-text ',' nl

= <outcount>
  :integer '\"outCount\" : ' print-text ',' nl

= <inmap>
  :inmap                  '\"inMap\" : {' inc
    <mapping>
  :end
                           dec  '},' nl

= <outmap>
  :outmap                  '\"outMap\" : {' inc 
    <mapping>
  :end
                           dec '},' nl

= <mapping>
  [ ?string
    :string               '\"' print-text '\" : '
    :integer              print-text
    [ ?string             ', '
    | ! ]                
    <mapping>
  | ! ]                  

= <multiple-pins-with-indices>
  [ ?string
    <single-pin-with-indices>
    <multiple-pins-with-indices>
  | ?symbol
    :symbol <symbol-must-be-nil>
  | ! ]

= <single-pin-with-indices>
    :string                      '['                
      [ ?integer <wire-indices>
      | ! ]
    :end                         ']' [ ?string ',' | ! ]

= <wire-indices>
  [ ?integer :integer            print-integer [ ?integer ',' <wire-indices> | ! ]
  | ! ]

")

#+nil  (defmacro xxx () (sl:parse *json-emitter-rules* "-JSON-EMITTER")))

#+nil (xxx)
#+nil(sl:parse *json-emitter-rules* "-JSON-EMITTER")

(PROGN
 (DEFMETHOD SCHEMATIC-JSON-EMITTER ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'SCHEMATIC-JSON-EMITTER))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (OUTPUT P "{")
     (CALL-EXTERNAL P #'INC DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (CALL-RULE P #'TOP-NAME-JSON-EMITTER DEPTH CURRENT-METHOD)
     (OUTPUT P "\"name\" : ")
     (CALL-EXTERNAL P #'PRINT-TEXT DEPTH CURRENT-METHOD)
     (OUTPUT P ",")
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (CALL-RULE P #'KIND-JSON-EMITTER DEPTH CURRENT-METHOD)
     (OUTPUT P "\"kindName\" : ")
     (CALL-EXTERNAL P #'PRINT-TEXT DEPTH CURRENT-METHOD)
     (OUTPUT P ",")
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (CALL-RULE P #'METADATA-JSON-EMITTER DEPTH CURRENT-METHOD)
     (OUTPUT P "\"metadata\" : ")
     (CALL-EXTERNAL P #'PRINT-TEXT DEPTH CURRENT-METHOD)
     (OUTPUT P ",")
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (CALL-RULE P #'TOP-LEVEL-INPUTS-JSON-EMITTER DEPTH CURRENT-METHOD)
     (CALL-RULE P #'TOP-LEVEL-OUTPUTS-JSON-EMITTER DEPTH CURRENT-METHOD)
     (CALL-RULE P #'REACT-JSON-EMITTER DEPTH CURRENT-METHOD)
     (CALL-RULE P #'FIRST-TIME-JSON-EMITTER DEPTH CURRENT-METHOD)
     (MUST-SEE P :INTEGER)
     (OUTPUT P "\"wireCount\" : ")
     (CALL-EXTERNAL P #'PRINT-INTEGER DEPTH CURRENT-METHOD)
     (OUTPUT P ", ")
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (OUTPUT P "\"parts\" : {")
     (CALL-EXTERNAL P #'INC DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (CALL-RULE P #'PARTS-JSON-EMITTER DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'DEC DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (OUTPUT P "}")
     (CALL-EXTERNAL P #'DEC DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (OUTPUT P "}")))
 (DEFMETHOD TOP-NAME-JSON-EMITTER ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'TOP-NAME-JSON-EMITTER))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)))
 (DEFMETHOD METADATA-JSON-EMITTER ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'METADATA-JSON-EMITTER))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)))
 (DEFMETHOD KIND-JSON-EMITTER ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'KIND-JSON-EMITTER))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)))
 (DEFMETHOD REACT-JSON-EMITTER ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'REACT-JSON-EMITTER))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)))
 (DEFMETHOD FIRST-TIME-JSON-EMITTER ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'FIRST-TIME-JSON-EMITTER))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)))
 (DEFMETHOD TOP-LEVEL-INPUTS-JSON-EMITTER ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'TOP-LEVEL-INPUTS-JSON-EMITTER))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :INPUTS)
     (OUTPUT P "\"inputs\" : [")
     (CALL-RULE P #'TOP-LEVEL-LIST-OF-STRINGS-JSON-EMITTER DEPTH
                CURRENT-METHOD)
     (MUST-SEE P :END)
     (OUTPUT P "],")
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)))
 (DEFMETHOD TOP-LEVEL-OUTPUTS-JSON-EMITTER ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'TOP-LEVEL-OUTPUTS-JSON-EMITTER))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :OUTPUTS)
     (OUTPUT P "\"outputs\" : [")
     (CALL-RULE P #'TOP-LEVEL-LIST-OF-STRINGS-JSON-EMITTER DEPTH
                CURRENT-METHOD)
     (MUST-SEE P :END)
     (OUTPUT P "],")
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)))
 (DEFMETHOD TOP-LEVEL-LIST-OF-STRINGS-JSON-EMITTER
            ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'TOP-LEVEL-LIST-OF-STRINGS-JSON-EMITTER))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (COND
      ((LOOK-AHEAD P :STRING) (MUST-SEE P :STRING) (OUTPUT P "\"")
       (CALL-EXTERNAL P #'PRINT-TEXT DEPTH CURRENT-METHOD) (OUTPUT P "\"")
       (COND ((LOOK-AHEAD P :STRING) (OUTPUT P ",")) (T))
       (CALL-RULE P #'TOP-LEVEL-LIST-OF-STRINGS-JSON-EMITTER DEPTH
                  CURRENT-METHOD))
      (T))))
 (DEFMETHOD INPUTS-JSON-EMITTER ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'INPUTS-JSON-EMITTER))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :INPUTS)
     (CALL-RULE P #'LIST-OF-STRINGS-JSON-EMITTER DEPTH CURRENT-METHOD)
     (MUST-SEE P :END)))
 (DEFMETHOD OUTPUTS-JSON-EMITTER ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'OUTPUTS-JSON-EMITTER))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :OUTPUTS)
     (CALL-RULE P #'LIST-OF-STRINGS-JSON-EMITTER DEPTH CURRENT-METHOD)
     (MUST-SEE P :END)))
 (DEFMETHOD LIST-OF-STRINGS-JSON-EMITTER ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'LIST-OF-STRINGS-JSON-EMITTER))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (COND
      ((LOOK-AHEAD P :STRING) (MUST-SEE P :STRING)
       (CALL-RULE P #'LIST-OF-STRINGS-JSON-EMITTER DEPTH CURRENT-METHOD))
      (T))))
 (DEFMETHOD PARTS-JSON-EMITTER ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'PARTS-JSON-EMITTER))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (OUTPUT P "{")
     (CALL-EXTERNAL P #'INC DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)
     (OUTPUT P "\"partName\" : \"")
     (CALL-EXTERNAL P #'PRINT-TEXT DEPTH CURRENT-METHOD)
     (OUTPUT P "\", ")
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)
     (OUTPUT P "\"kindName\" : \"")
     (CALL-EXTERNAL P #'PRINT-TEXT DEPTH CURRENT-METHOD)
     (OUTPUT P "\", ")
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (CALL-RULE P #'INCOUNT-JSON-EMITTER DEPTH CURRENT-METHOD)
     (CALL-RULE P #'INMAP-JSON-EMITTER DEPTH CURRENT-METHOD)
     (MUST-SEE P :INPUTS)
     (OUTPUT P "\"inPins\" : [")
     (CALL-RULE P #'MULTIPLE-PINS-WITH-INDICES-JSON-EMITTER DEPTH
                CURRENT-METHOD)
     (OUTPUT P "],")
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
     (MUST-SEE P :END)
     (CALL-RULE P #'OUTCOUNT-JSON-EMITTER DEPTH CURRENT-METHOD)
     (CALL-RULE P #'OUTMAP-JSON-EMITTER DEPTH CURRENT-METHOD)
     (MUST-SEE P :OUTPUTS)
     (OUTPUT P "\"outPins\" : [")
     (CALL-RULE P #'MULTIPLE-PINS-WITH-INDICES-JSON-EMITTER DEPTH
                CURRENT-METHOD)
     (OUTPUT P "]")
     (MUST-SEE P :END)
     (COND
      ((LOOK-AHEAD P :STRING) (CALL-EXTERNAL P #'DEC DEPTH CURRENT-METHOD)
       (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD) (OUTPUT P "},")
       (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)
       (CALL-RULE P #'PARTS-JSON-EMITTER DEPTH CURRENT-METHOD))
      (T (CALL-EXTERNAL P #'DEC DEPTH CURRENT-METHOD)
       (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD) (OUTPUT P "}")))))
 (DEFMETHOD INCOUNT-JSON-EMITTER ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'INCOUNT-JSON-EMITTER))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :INTEGER)
     (OUTPUT P "\"inCount\" : ")
     (CALL-EXTERNAL P #'PRINT-TEXT DEPTH CURRENT-METHOD)
     (OUTPUT P ",")
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)))
 (DEFMETHOD OUTCOUNT-JSON-EMITTER ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'OUTCOUNT-JSON-EMITTER))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :INTEGER)
     (OUTPUT P "\"outCount\" : ")
     (CALL-EXTERNAL P #'PRINT-TEXT DEPTH CURRENT-METHOD)
     (OUTPUT P ",")
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)))
 (DEFMETHOD INMAP-JSON-EMITTER ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'INMAP-JSON-EMITTER))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :INMAP)
     (OUTPUT P "\"inMap\" : {")
     (CALL-EXTERNAL P #'INC DEPTH CURRENT-METHOD)
     (CALL-RULE P #'MAPPING-JSON-EMITTER DEPTH CURRENT-METHOD)
     (MUST-SEE P :END)
     (CALL-EXTERNAL P #'DEC DEPTH CURRENT-METHOD)
     (OUTPUT P "},")
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)))
 (DEFMETHOD OUTMAP-JSON-EMITTER ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'OUTMAP-JSON-EMITTER))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :OUTMAP)
     (OUTPUT P "\"outMap\" : {")
     (CALL-EXTERNAL P #'INC DEPTH CURRENT-METHOD)
     (CALL-RULE P #'MAPPING-JSON-EMITTER DEPTH CURRENT-METHOD)
     (MUST-SEE P :END)
     (CALL-EXTERNAL P #'DEC DEPTH CURRENT-METHOD)
     (OUTPUT P "},")
     (CALL-EXTERNAL P #'NL DEPTH CURRENT-METHOD)))
 (DEFMETHOD MAPPING-JSON-EMITTER ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'MAPPING-JSON-EMITTER))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (COND
      ((LOOK-AHEAD P :STRING) (MUST-SEE P :STRING) (OUTPUT P "\"")
       (CALL-EXTERNAL P #'PRINT-TEXT DEPTH CURRENT-METHOD) (OUTPUT P "\" : ")
       (MUST-SEE P :INTEGER)
       (CALL-EXTERNAL P #'PRINT-TEXT DEPTH CURRENT-METHOD)
       (COND ((LOOK-AHEAD P :STRING) (OUTPUT P ", ")) (T))
       (CALL-RULE P #'MAPPING-JSON-EMITTER DEPTH CURRENT-METHOD))
      (T))))
 (DEFMETHOD MULTIPLE-PINS-WITH-INDICES-JSON-EMITTER
            ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'MULTIPLE-PINS-WITH-INDICES-JSON-EMITTER))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (COND
      ((LOOK-AHEAD P :STRING)
       (CALL-RULE P #'SINGLE-PIN-WITH-INDICES-JSON-EMITTER DEPTH
                  CURRENT-METHOD)
       (CALL-RULE P #'MULTIPLE-PINS-WITH-INDICES-JSON-EMITTER DEPTH
                  CURRENT-METHOD))
      ((LOOK-AHEAD P :SYMBOL) (MUST-SEE P :SYMBOL)
       (CALL-RULE P #'SYMBOL-MUST-BE-NIL-JSON-EMITTER DEPTH CURRENT-METHOD))
      (T))))
 (DEFMETHOD SINGLE-PIN-WITH-INDICES-JSON-EMITTER
            ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'SINGLE-PIN-WITH-INDICES-JSON-EMITTER))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)
     (OUTPUT P "[")
     (COND
      ((LOOK-AHEAD P :INTEGER)
       (CALL-RULE P #'WIRE-INDICES-JSON-EMITTER DEPTH CURRENT-METHOD))
      (T))
     (MUST-SEE P :END)
     (OUTPUT P "]")
     (COND ((LOOK-AHEAD P :STRING) (OUTPUT P ",")) (T))))
 (DEFMETHOD WIRE-INDICES-JSON-EMITTER ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'WIRE-INDICES-JSON-EMITTER))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (COND
      ((LOOK-AHEAD P :INTEGER) (MUST-SEE P :INTEGER)
       (CALL-EXTERNAL P #'PRINT-INTEGER DEPTH CURRENT-METHOD)
       (COND
        ((LOOK-AHEAD P :INTEGER) (OUTPUT P ",")
         (CALL-RULE P #'WIRE-INDICES-JSON-EMITTER DEPTH CURRENT-METHOD))
        (T)))
      (T)))))
