(in-package :arrowgrams/compiler/back-end)

(defparameter *json-emitter-rules*
"
= <schematic>
                   '{' inc nl
  <name>               '\"name\" : ' print-text ',' nl
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

(eval (sl:parse arrowgrams/compiler/back-end::*json-emitter-rules* "-JSON-EMITTER"))
