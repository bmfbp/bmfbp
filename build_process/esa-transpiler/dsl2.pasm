= rmSpaces
  [ ?SPACE | ?COMMENT | * . ]

= esa-dsl
  ~rmSpaces
                        $esaprogram__BeginScope
  @type-decls
  @situations
  @classes
  @parse-whens-and-scripts
  EOF
                        $esaprogram__EndScope

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
  @esaSymbol-in-decl

= situations
  {[ ?SYMBOL/situation
     @parse-situation-def 
   | * > 
   ]}

= parse-situation-def
  SYMBOL/situation 
  @esaSymbol-in-decl

= classes
  {[ ?SYMBOL/class @class-def
   | * >
  ]}

= parse-whens-and-scripts
  {[ ?SYMBOL/when @when-declaration
   |?SYMBOL/script @script-implementation
   | * >
  ]}

= class-def
  SYMBOL/class
  @esaSymbol
                                $esaclass__LookupByName_BeginScope
                                  $esaclass__SetField_methodsTable_empty
                                  $esaclass__SetField_scriptsTable_empty
  @field-decl
  {[ &field-decl-begin @field-decl
   | * >
  ]}
  SYMBOL/end SYMBOL/class
                                $esaclass__EndScope

- field-decl-begin
  [ ?SYMBOL/map ^ok
  | &non-keyword-symbol ^ok
  | * ^fail
 ]

= field-decl
  [ ?SYMBOL/map
    SYMBOL/map 
    @esaSymbol-in-decl
  | &non-keyword-symbol @esaSymbol-in-decl
  ]

= when-declaration
  SYMBOL/when
  @situation-ref
 {[ ?SYMBOL/or
      @or-situation 
  | * >
  ]}

  @class-ref
                              $esaclass__LookupByName_BeginScope
  {[ ?SYMBOL/script 
                                  $scriptsTable__BeginScopeFrom_esaclass
     @script-declaration
                                    $scriptsTable__AppendFrom_internalMethod
                                  $scriptsTable__EndScope
   | ?SYMBOL/method
                                  $methodsTable__BeginScopeFrom_esaclass
     @method-declaration
                                    $methodsTable__AppendFrom_externalMethod
                                  $methodsTable__EndScope
   | * 
     >
  ]}
  SYMBOL/end SYMBOL/when
                              $esaclass__EndScope


= situation-ref
  @esaSymbol-in-decl % should be checked to be a situation

= or-situation
  SYMBOL/or @situation-ref
  
= class-ref
  @esaSymbol  % should be checked to be a kind

= method-declaration % "when" is always a declaration (of methods (external) and scripts (internal methods)
  SYMBOL/method
                                 $externalMethod__NewScope
  @esaSymbol
                                  $externalMethod__SetField_name_from_name
  @formals
                                  $externalMethod__SetField_formalList_from_formalList
  @return-type-declaration
                                  $externalMethod__SetField_returnType_from_returnType
                                 $externalMethod__Output
  
= script-declaration  % this is a (forward) declaration of scripts which will be defined later
  SYMBOL/script
                                 $internalMethod__NewScope
  @esaSymbol
                                  $internalMethod__SetField_name_from_name
  @formals
                                  $internalMethod__SetField_formalList_from_formalList
  @return-type-declaration
                                  $internalMethod__SetField_returnType_from_returnType
                                 $internalMethod__Output

= formals
                                 $formalList__NewScope
  [ ?'(' 
     '(' 
     @type-list 
     ')'
  | *
  ]
                                 $formalList__Output

= type-list
  @esaSymbol
                                   $formalList__AppendFrom_name
  {[ &non-keyword-symbol
     @esaSymbol
                                   $formalList__AppendFrom_name
   | * >
  ]}

= return-type-declaration
                                   $returnType__NewScope
                                     $returnKind__NewScope
  [ ?'>' '>' '>'
         [ ?SYMBOL/map SYMBOL/map
                                         $returnKind_SetEnum_map
           @esaSymbol
	                               $returnType__SetField_name_from_name
         | *
                                         $returnKind_SetEnum_simple
           @esaSymbol
	                               $returnType__SetField_name_from_name
  ]
  | *
                                         $returnKind__SetEnum_void
  ]
                                     $returnKind__Output
                                     $returnType__SetField_returnKind_from_returnKind
                                   $returnType__Output

= esaSymbol-in-decl
  @esaSymbol
                                    $name__IgnoreInPass2

% implement code ...

= script-implementation
  SYMBOL/script
  @esaSymbol-in-decl  % class
                                    $name__IgnoreInPass1
  @esaSymbol-in-decl  % script method
                                    $name__IgnoreInPass1
  @optional-formals-definition
  @optional-return-type-definition
  @script-body
  SYMBOL/end SYMBOL/script

= optional-formals-definition
  {[ ?'(' '(' @untyped-formals-definition ')'
   | * >
  ]}

= untyped-formals-definition
  {[ &non-keyword-symbol @esaSymbol-in-decl
     % index and type
   | * >
  ]}
  
= optional-return-type-definition  % should check that return type matches the definition
  [ ?'>' '>' '>'
         [ ?SYMBOL/map SYMBOL/map @esaSymbol-in-decl
         | * @esaSymbol-in-decl

  ]
  | *
  ]  
  
= script-body
  {[ ?SYMBOL/let @let-statement
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
  ]}

= callInternalStatement
  @esa-expr-in-statement
                             $expression__IgnoreInPass1                              

= callExternalStatement
  @esa-expr-in-statement
                             $expression__IgnoreInPass1                              

= let-statement
  SYMBOL/let
   @esaSymbol-in-statement
   '='
   @esa-expr-in-statement
   SYMBOL/in 
   @script-body
   SYMBOL/end SYMBOL/let

= create-statement
  SYMBOL/create
   @esaSymbol-in-statement
   '=' 
   [ ?'*' '*'
     @class-ref
                     $name__EndOutputScope
   | *
   @class-ref
                     $name__EndOutputScope
   ]
   SYMBOL/in 
   @script-body
   SYMBOL/end SYMBOL/create

= set-statement
  SYMBOL/set
   @esa-expr-in-statement
   '=' 
   @esa-expr-in-statement
  
= map-statement
  SYMBOL/map @esaSymbol-in-statement
  '='
  @esa-expr-in-statement
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
    @esa-expr-in-statement

= if-statement
  SYMBOL/if
    @esa-expr-in-statement
  SYMBOL/then
    @script-body
  [ ?SYMBOL/else SYMBOL/else
     @script-body
  | *
  ]
  SYMBOL/end SYMBOL/if

= script-call
  '@' @esa-expr-in-statement

= method-call
  @esa-expr-in-statement

= return-statement
  '>' '>'
  [ ?SYMBOL/true SYMBOL/true
  | ?SYMBOL/false SYMBOL/false
  | * @esaSymbol-in-statement
  ]

= esaSymbol-in-statement
  @esaSymbol

= esa-expr-in-statement
  @esa-expr

= esa-expr
  [ ?'@' '@' | * ]  % ignore @ (script call symbol)
                              $expression__NewScope
  [ ?SYMBOL/true SYMBOL/true
			       $ekind__NewScope
			         $ekind__SetEnum_true
			       $ekind__Output
                               $expression__SetField_ekind_from_ekind
  | ?SYMBOL/false SYMBOL/false
			       $ekind__NewScope
			         $ekind__SetEnum_false
			       $ekind__Output
                               $expression__SetField_ekind_from_ekind
  | *
			       $ekind__NewScope
			         $ekind__SetEnum_object
			       $ekind__Output
                               $expression__SetField_ekind_from_ekind
    @object__
                               $expression__SetField_object_from_object
   ]
                              $expression__Output

% DSL allows parameterList only for fields
% self.a -> (slot-value self 'a)
% self.a.b -> (slot-value (slot-value self 's) 'b)
% self.array(i).b (slot-value ((slot-value self 'array) i) 'b)
% self.array(i).b(j) ((slot-value ((slot-value self 'array) i) 'b) j)
% fn -> fn
% fn(i) -> (fn i)
%
% name.field(optionalparameters) -> object/field/params
= object__
                             $object__NewScope
  @object__name
                               $object__SetField_name_from_name
			       $fieldMap__NewScope
  @object__fields
                               $fieldMap__Output
                               $object__SetField_fieldMap_from_fieldMap
			     $object__Output

= object__name
  @esaSymbol
				 
  
% <<>>fieldMap
= object__fields
  {[ &object__field_p
                                  $field__NewScope
         @object__single_field
                                  $field__Output
                                $fieldMap__AppendFrom_field
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
                               $field__SetField_name_from_name

= object__parameterMap
  [ ?'('
                                $actualParameterList__NewScope
     '('
       @esa-expr
                                  $actualParameterList__AppendFrom_expression
       @object__field__recursive-more-parameters
     ')'
                                $actualParameterList__Output
                              $field__SetField_actualParameterList_from_actualParameterList
  | *
  ]

= object__field__recursive-more-parameters
  [ &object__field__parameters__pred-parameterBegin
    @esa-expr
                                $actualParameterList__AppendFrom_expression
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


= tester
  ~rmSpaces
%  $mech-tester
%   @object__
   @esa-expr  
%    @esa-dsl
    $bp
%  @esa-expr
%  $emit__expression
  
