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

= gitLocation
  nameValuePair ','
  nameValuePair ','
  nameValuePair ','
  nameValuePair ','
  nameValuePair ','
  nameValuePair ','
  nameValuePair

= points
  STRING stringEqPoints
  ':'
  @jsonarray

= bounds
  STRING stringEqTopLeft
  ':'
  @object
  ','
  STRING stringEqBottomRight
  ','
  @object

= polylineShapeDescriptor
  STRING
  ','
  @points
  
= ellipseShapeDescriptor
  STRING
  ','
  @bounds
  
= rectShapeDescriptor
  STRING
  ','
  @bounds

= shape
  STRING
  ':'
   % isPolyline, isEllipse and isRect are defined as external predicates (see mechanisms.lisp)
   [ &isPolyline @polyLineShapeDescriptor
   | &isEllipse @ellipseShapeDescriptor
   | &isRect @rectShapeDescriptor
   ]

= shapeDescriptor
  '{'
   STRING stringEqTag
   ':'
   @shape
   '}'


= diagramObject
  '{'
  STRING stringEqId
  ':'
  INTEGER
  ','
  STRING stringEqShape
  ':'
  @hashmap
  ','
  @gitLocation
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
  
  