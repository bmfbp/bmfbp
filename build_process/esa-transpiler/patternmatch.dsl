exprdsl : 
  id = @id
  '='
  [ ?'{'  r = @classWithFields
  | ?:    r = @builtinType
  | ?'\'' r = @enumList
  | ?'|'  r = @compositeTypeList
  ]
  >> list id r

classWithFields :
  '{' list = @idList '}'
   >> list

builtinType :
  ':' [ /map/     >> "map"
      | /bag/     >> "bag"
      | /string/  >> "string"
      ]
      
enumList :
  [ ?'|' '|' >> cons @enumConstant @enumList
  | *        >> nil
  ]

compositeTypeList :
  [ &id? ty = @id '|'
         >> cons ty @compositeTypeList
  | *    >> nil
  ]

enumConstant:
 '\'' (>> @id) '\''

idList :
  [ ?/\w/ >> cons @id @idList
  | *     >> nil
  ]


id :
  r = /(\w)+/)
  @ws
  >> r

ws :
  /[ \t\n\r]+/
  >> nil