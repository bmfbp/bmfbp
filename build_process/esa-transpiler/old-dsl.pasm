  
= object--fields
  @esaObjectSymbol
  {[ ?'.' '.'
     @fieldSymbol
     @object--





%  >> object
= object-with-fields
                                  $object__NewScope
                                     $fieldMap__NewScope
    {[ ?'.' '.'
                                       $field_NewScope
      @esa-field 
      @optional-actuals
                                       $fieldMap__append_from_field
     | * >
    ]}
                                     $object__setField_fieldMap_from_fieldMap
                                  $object__Output

= optional-actuals
 [ ?'(' '('
   {[ &non-keyword-symbol 
      @esa-expr
    | * > 
    ]}
    ')'
 | * 
 ]

% >> object
= esa-object-name
                                $object__NewScope
                                  $name__newScope
                                      $name__GetName
  @esa-field
                                  $name__output
                                  $object__setField_name_from_name
                                $object__output
				
= esa-field
  [ &non-keyword-symbol
    SYMBOL
              $name__combine
    @esa-field-follow
  | *
  ]

= esa-field-follow
  {[ ?'/' '/'
              $name__combine
     SYMBOL
              $name__combine
   | ?'-' '-' 
              $name__combine
     SYMBOL
              $name__combine
   | ?'?' '?'
              $name__combine
      >
   | ?CHARACTER/' CHARACTER/' 
              $name__combine
     >
   | * >
  ]}

