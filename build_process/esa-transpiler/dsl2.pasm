= rmSpaces
  [ ?SPACE | ?COMMENT | * . ]

= esa-dsl
  ~rmSpaces
                        $esaprogram__BeginScope
			  $classes__FromProgram_BeginScope
  @type-decls
  @situations
  @classes
                          $whenDeclarations__FromProgram_BeginScope
  @parse-whens-and-scripts
                          $whenDeclarations__EndScope
  EOF
			  $classes__EndScope
                        $esaprogram__Output

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
                                      $whenDeclarations__BeginMapping
  {[ ?SYMBOL/when
                                          $whenDeclaration__FromWhenDeclarationsMap_BeginScope
     @when-declaration
                                          $whenDeclaration__EndScope
                                      $whenDeclarations__Next
				      
   |?SYMBOL/script @script-implementation
   | * >
  ]}
                                      $whenDeclarations__EndMapping

= class-def
  SYMBOL/class
  @esaSymbol
                                     $esaclass__LookupFromClasses_BeginScope
				       $esaclass__SetField_methodsTable_empty
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
                                    $esaclass__LookupFromClasses_BeginScope

                                    $methodDeclarationsAndScriptDeclarations__FromWhenDeclaration_BeginScope
                                      $methodDeclarationsAndScriptDeclarations__BeginMapping
  {[ ?SYMBOL/script
                                        $scriptDeclaration__FromMap_BeginScope
					  $esaKind__FromClass_BeginOutputScope
					  $scriptDeclaration__SetField_esaKind_from_esaKind
     @script-declaration-in-when
                                          $scriptDeclaration__SetField_implementation_empty
					$scriptDeclaration__Output
					$declarationMethodOrScript__NewScope
                                          $declarationMethodOrScript__CoerceFrom_scriptDeclaration
					$declarationMethodOrScript__Output
					    $methodsTable__FromClass_BeginScope
                                              $methodsTable__AppendFrom_declarationMethodOrScript
					    $methodsTable__EndScope
                                      $methodDeclarationsAndScriptDeclarations__Next
   | ?SYMBOL/method
                                        $methodDeclaration__FromMap_BeginScope
					  $esaKind__FromClass_BeginOutputScope
					  $methodDeclaration__SetField_esaKind_from_esaKind
     @method-declaration-in-when
					$methodDeclaration__Output
					$declarationMethodOrScript__NewScope
                                          $declarationMethodOrScript__CoerceFrom_methodDeclaration
					$declarationMethodOrScript__Output
					    $methodsTable__FromClass_BeginScope
                                              $methodsTable__AppendFrom_declarationMethodOrScript
					    $methodsTable__EndScope
                                      $methodDeclarationsAndScriptDeclarations__Next
   | *
     >
  ]}
  SYMBOL/end SYMBOL/when
                                      $methodDeclarationsAndScriptDeclarations__EndMapping
                                    $methodDeclarationsAndScriptDeclarations__EndScope

                                    $esaclass__EndScope

= situation-ref
  @esaSymbol-in-decl % should be checked to be a situation

= or-situation
  SYMBOL/or @situation-ref
  
= class-ref
  @esaSymbol  % should be checked to be a kind

= method-declaration-in-when % "when" is always a declaration (of methods (external) and scripts (internal methods)
  SYMBOL/method      % should check declaration against definition, but, we'll skip this step during bootstrap
  @esaSymbol-in-decl
  @formals
  @return-type-declaration
  
= script-declaration-in-when  % this is a (forward) declaration of scripts which will be defined later
  SYMBOL/script      % should check declaration against definition, but, we'll skip this step during bootstrap
  @esaSymbol-in-decl
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

= esaSymbol-in-decl
  @esaSymbol
                                    $name__IgnoreInPass2

% implement code ...

= script-implementation
  SYMBOL/script
  @esaSymbol-in-decl  % class
  @esaSymbol-in-decl  % script method
  @optional-formals-definition
  @optional-return-type-definition
  @script-body
  SYMBOL/end SYMBOL/script
                                    $esaclass__EndScope

= optional-formals-definition
  {[ ?'(' '(' @untyped-formals-definition ')'
   | * >
  ]}

= untyped-formals-definition
  {[ &non-keyword-symbol
     @esaSymbol-in-decl
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
                     $name__IgnoreInPass2
   | *
   @class-ref
                     $name__IgnoreInPass2
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
  
