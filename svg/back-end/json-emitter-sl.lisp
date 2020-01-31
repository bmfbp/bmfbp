(in-package :arrowgrams/compiler/back-end)

(defparameter *json-emitter-rules*
"
= <schematic>
  <name>
  <kind>
  <inputs>
  <ouputs>
  <react>
  <first-time>
  <parts>

= <name>
  :string

= <kind>
  :string

= <react>
  :string

= <first-time>
  :string

= <inputs>
  :inputs
  <list-of-strings>
  :end

= <outputs>
  :outputs
  <list-of-strings>
  :end

= <list-of-strings>
  :string 
  [ ? :string <list-of-strings>
  | ! ]

= <parts>
  :inputs <inline-input-indices> :end
  :outputs <inline-ouput-indices> :end

= <inline-input-indices>
    :string <wire-indices> :end

= <wire-indices> 
   [ ?integer :integer <wire-indices>
   | ]

= <inline-ouput-indices>
    :string <wire-indices> :end
"
)

(eval (sl:parse *collector-rules* "-JSON-EMITTER"))
