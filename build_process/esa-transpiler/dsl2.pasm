%
% in pass2, we deal with creating a data structure for scripts
% if we get here, the we can assume that all class and method (and script) definitions are OK and we don't need to check them
%

= rmSpaces
  [ ?SPACE | ?COMMENT | * . ]

= esa-dsl
                             $pass2__NewScope
  ~rmSpaces
  @type-decls
  @situations
  @classes
                                $pass2__SetField_classTable_from_classTable
  @parse-whens-and-scripts
  EOF
                              $pass2__Output

- keyword-symbol
  [ ?SYMBOL
    [ ?SYMBOL/type ^ok
    | ?SYMBOL/class ^ok
    | ?SYMBOL/create ^ok
    | ?SYMBOL/end ^ok
    | ?SYMBOL/method ^ok
    | ?SYMBOL/script ^ok
    | ?SYMBOL/let ^ok
    | ?SYMBOL/set ^ok
    | ?SYMBOL/map ^ok
    | ?SYMBOL/in ^ok
    | ?SYMBOL/loop ^ok
    | ?SYMBOL/if ^ok
    | ?SYMBOL/then ^ok
    | ?SYMBOL/else ^ok
    | ?SYMBOL/when ^ok
    | ?SYMBOL/situation ^ok
    | ?SYMBOL/or ^ok
    | ?SYMBOL/true ^ok
    | ?SYMBOL/false ^ok
    | ?SYMBOL/exit-map ^ok
    | * ^fail
    ]
  | * ^fail
  ]

- non-keyword-symbol
  [ ?SYMBOL
    [ &keyword-symbol ^fail
    | * ^ok
    ]
  | * ^fail
  ]

= type-decls
  {[ ?SYMBOL/type
    @type-decl
   | * >
  ]}

= type-decl
  SYMBOL/type
  @esaSymbol

= situations
  {[ ?SYMBOL/situation @parse-situation-def 
   | * > ]}

= parse-situation-def
  SYMBOL/situation 
  @esaSymbol

% in pass2, parsing of class definitions simply puts empty entries into a class table
= classes
                                $classTable__NewScope
  {[ ?SYMBOL/class @class-def
                                   $classTable__AppendFrom_namedClass
   | * >
  ]}
                                $classTable__Output

= parse-whens-and-scripts
  {[ ?SYMBOL/when @when-declaration
   |?SYMBOL/script @script-implementation
   | * >
  ]}

= class-def
  SYMBOL/class
                                $namedClass__NewScope
  @esaSymbol
                                  $namedClass__SetField_name_from_name
  @field-decl
  {[ &field-decl-begin @field-decl
   | * >
  ]}
  SYMBOL/end SYMBOL/class
                                $namedClass__Output
			       

- field-decl-begin
  [ ?SYMBOL/map ^ok
  | &non-keyword-symbol ^ok
  | * ^fail
 ]

= field-decl
  [ ?SYMBOL/map
    SYMBOL/map 
    @esaSymbol
  | &non-keyword-symbol @esaSymbol
  ]

= when-declaration
  SYMBOL/when
  @situation-ref
  {
  [ ?SYMBOL/or
      @or-situation 
  | * >
  ]
  }

  @class-ref

  {
  [ ?SYMBOL/script @script-declaration
   | ?SYMBOL/method @method-declaration
   | * >
  ]
  }
  SYMBOL/end SYMBOL/when

= situation-ref
  @esaSymbol % should be checked to be a situation

= or-situation
  SYMBOL/or @situation-ref
  
= class-ref
  @esaSymbol  % should be checked to be a kind

= method-declaration % "when" is always a declaration (of methods (external) and scripts (internal methods)
  SYMBOL/method @esaSymbol
  @formals
  @return-type-declaration
  
= script-declaration  % this is a (forward) declaration of scripts which will be defined later
  SYMBOL/script @esaSymbol
  @formals
  @return-type-declaration

= formals
  [ ?'(' 
     '(' 
     @type-list 
     ')'
  | *
  ]

= type-list
  @esaSymbol
  {[ &non-keyword-symbol
     @esaSymbol
   | * >
  ]}

= return-type-declaration
  [ ?'>' '>' '>'
         [ ?SYMBOL/map SYMBOL/map
           @esaSymbol
         | *
           @esaSymbol
  ]
  | *
  ]





% implementation code ...

= script-implementation
  SYMBOL/script
  @esaSymbol  % class
                                   $namedClass__LookupBeginScope
                                     $esamethod__NewScope
  @esaSymbol  % script method
                                       $esamethod__CheckThatMethodExistsInNamedClass
  @optional-formals-definition
                                       $esamethod__CheckFormals
  @optional-return-type-definition
                                       $esamethod__CheckReturnType
  @script-body
                                       $esamethod__SetField_implementation_from_implementation
  SYMBOL/end SYMBOL/script
                                     $esamethod__Output
                                   $namedClass__EndScope

= optional-formals-definition
  {[ ?'(' '(' @untyped-formals-definition ')'
   | * >
  ]}

= untyped-formals-definition
  {[ &non-keyword-symbol @esaSymbol
     % index and type
   | * >
  ]}
  
= optional-return-type-definition  % should check that return type matches the definition
  [ ?'>' '>' '>'
         [ ?SYMBOL/map SYMBOL/map @esaSymbol
         | * @esaSymbol

  ]
  | *
  ]  
  
= script-body
                                       $implementation__NewScope
  {
                                         $statement__NewScope
   [ ?SYMBOL/let @let-statement
   | ?SYMBOL/map @map-statement
   | ?SYMBOL/exit-map @exit-map-statement
   | ?SYMBOL/set @set-statement
   | ?SYMBOL/create @create-statement
   | ?SYMBOL/if @if-statement
   | ?SYMBOL/loop @loop-statement
   | ?SYMBOL/exit-when @exit-when-statement
   | ?'>' @return-statement
   | ?'@' @callInternalStatement
   | &non-keyword-symbol @callExternalStatement
   | * >
   ]
                                         $statement__Output
                                         $implementation__AppendFrom_statement
  }
                                       $implementation__Output

= let-statement
  SYMBOL/let
                                       $letStatement__NewScope
   @varName
                                         $letStatement__SetField_varName_from_varName
   '='
   @esa-expr
   SYMBOL/in
                                           $implementation__NewScope
   @script-body
                                           $implementation__Output
                                         $letStatement__SetField_implementation_from_implementation
   SYMBOL/end SYMBOL/let
                                       $letStatement__Output
                                       $statement__CoerceFrom_letStatement

= create-statement
  SYMBOL/create
  @varName
   '=' 
   [ ?'*' '*'  %  * means use class contained in expression, instead of absolute name
%                                          $indirectionKind__NewScope
%                                            $indirectionKind__SetEnum_indirect
%                                          $indirectionKind__Output
%                                        $maybeIndirectExpression__SetField_indirectionKind_from_indirectionKind
     @class-ref
   | *
%                                          $indirectionKind__NewScope
%                                            $indirectionKind__SetEnum_direct
%                                          $indirectionKind__Output
%                                        $maybeIndirectExpression__SetField_indirectionKind_from_indirectionKind
     @class-ref
   ]
%                                       $maybeIndirectExpression__SetField_expression_from_expression
%                                      $maybeIndirectExpression__Output
%				      $createStatement_SetField_maybeIndirectExpression_from_maybIndirectExpression
   SYMBOL/in 
%                                           $implementation__NewScope
   @script-body
%                                           $implementation__Output
   SYMBOL/end SYMBOL/create

= set-statement
  SYMBOL/set
   @esa-expr
   '=' 
   @esa-expr
  
= map-statement
  SYMBOL/map 
  @varName
  '='
  @esa-expr
  SYMBOL/in @script-body
  SYMBOL/end SYMBOL/map

= exit-map-statement
  SYMBOL/exit-map

= loop-statement
  SYMBOL/loop
    @script-body
  SYMBOL/end SYMBOL/loop
  
= exit-when-statement
  SYMBOL/exit-when
    @esa-expr

= if-statement
  SYMBOL/if
    @esa-expr
  SYMBOL/then
    @script-body
  [ ?SYMBOL/else SYMBOL/else
     @script-body
  | *
  ]
  SYMBOL/end SYMBOL/if

= script-call
  '@' @esa-expr

= method-call
  @esa-expr

= return-statement
  '>' '>'
  [ ?SYMBOL/true SYMBOL/true
  | ?SYMBOL/false SYMBOL/false
  | * @esaSymbol
  ]

= callInternalStatement
  '@'
  @esa-object-expr

= callExternalStatement
  @esa-object-expr

= esa-object-expr
  @object__

= varName
                    $varName__NewScope
  @esaSymbol
                      $varName__CoerceFrom_name
		    $varName__Output

= esa-expr
  [ ?SYMBOL/true SYMBOL/true
  | ?SYMBOL/false SYMBOL/false
  | *
    [ ?'@' '@' 
      @object__
    | * 
      @object__
    ]
   ]

% DSL allows parameterList only for fields
% self.a -> (slot-value self 'a)
% self.a.b -> (slot-value (slot-value self 's) 'b)
% self.array(i).b (slot-value ((slot-value self 'array) i) 'b)
% self.array(i).b(j) ((slot-value ((slot-value self 'array) i) 'b) j)
% fn -> fn
% fn(i) -> (fn i)
%
% name.field(optionalparameters) -> object/field/params
%
% object__ >> expression
= object__
  @object__name
  @object__fields

= object__name
  @esaSymbol
				 
  
% <<>>fieldMap
= object__fields
  {[ &object__field_p
         @object__single_field
   | * >
  ]}

- object__field_p
  [ ?'.' ^ok
  | ?'(' ^ok
  | * ^fail
  ]

= object__single_field
  [ ?'.'
     @object__dotFieldName
     @object__parameterMap
  | ?'('
     @object__parameterMap
  | *
  ]

= object__dotFieldName
  '.'
  @esaSymbol

= object__parameterMap
  [ ?'('
     '('
       @esa-expr
       @object__field__recursive-more-parameters
     ')'
  | *
  ]

= object__field__recursive-more-parameters
  [ &object__field__parameters__pred-parameterBegin
    @esa-expr
    @object__field__recursive-more-parameters
  | *
  ]

- object__field__parameters__pred-parameterBegin
  [ ?SYMBOL ^ok
  | * ^fail
  ]
  
= object__field__parameters__parameter
  @esaSymbol

= esaSymbol
                                 $name__NewScope
  SYMBOL
                                   $name__GetName
  {[ ?'/' '/'                      $name__combine
     SYMBOL                        $name__combine
   | ?'-' '-'                      $name__combine
     SYMBOL                        $name__combine
   | ?'?' '?'                      $name__combine
      >
   | ?CHARACTER/' CHARACTER/'
                                   $name__combine
     >
   | * >
  ]}
                                 $name__Output

