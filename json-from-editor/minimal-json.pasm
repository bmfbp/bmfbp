= jsonarray
  '[' @commaSeparatedObjects ']'

= hashmap
  '{' @namedObjects '}'
  
= jsonatom
  [ ?STRING STRING
  | ?INTEGER INTEGER
  | ?SYMBOL/true SYMBOL/true
  | ?SYMBOL/false SYMBOL/false
  | ?SYMBOL/null SYMBOL/null
  ]

= nameValuePair
  @jsonatom
  ':'
  @object

= object
  [ ?'{' @hashmap
  | ?'[' @jsonarray
  | * @jsonatom
  ]

= namedObjects
  nameValuePair
  {[ ?',' ',' nameValuePair
   | * >
   ]}   

= commaSeparatedObjects
  @object
  {[ ?',' ',' @object
   | * >
   ]}

= rmSpaces
  [ ?SPACE | ?COMMENT | * . ]

= jsonFromEditor
  ~rmSpaces
  @object