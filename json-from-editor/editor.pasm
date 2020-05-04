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

= diagramObject
  '{'
  STRING stringEqId
  ':'
  INTEGER
  ','
  STRING
  ':'
  @hashmap
  ',' 
  nameValuePair ','
  nameValuePair ','
  nameValuePair ','
  nameValuePair ','
  nameValuePair ','
  nameValuePair ','
  nameValuePair
  '}'

= commaSeparatedDiagramObjects
  @diagramObject
  {[ ?',' ',' @diagramObject
   | * >
  ]}

= rmSpaces
  [ ?SPACE | ?COMMENT | * . ]

= jsonFromEditor
  ~rmSpaces
  '{'
  STRING stringEqVersion
  ':'
  STRING
  ','
  STRING stringEqModuleName
  ':'
  STRING
  ','
  STRING stringEqCanvasItems
  ':'
  '['
  @commaSeparatedDiagramObjects
  ']'
  '}'
  
  