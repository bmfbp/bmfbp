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
  {[ ?SYMBOL/when
     @when-declaration
   |?SYMBOL/script @script-implementation
   | * >
  ]}

= class-def
  SYMBOL/class
  @esaSymbol-in-decl
  @field-decl
  {[ &field-decl-begin @field-decl
   | * >
  ]}
  SYMBOL/end SYMBOL/class

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
  {[ ?SYMBOL/script
     @script-declaration-in-when
   | ?SYMBOL/method
     @method-declaration-in-when
   | *
     >
  ]}
  SYMBOL/end SYMBOL/when

= situation-ref
  @esaSymbol-in-decl % should be checked to be a situation

= or-situation
  SYMBOL/or @situation-ref
  
= class-ref
  @esaSymbol-in-decl  % should be checked to be a kind

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
  @esaSymbol  % class
                                    $esaclass__LookupFromClasses_BeginScope
				      $methodsTable__FromClass_BeginScope
  @esaSymbol  % script method
                                        $scriptDeclaration__LookupFromTable_BeginScope
  @optional-formals-definition
  @optional-return-type-definition
  @script-body
					  $scriptDeclaration__SetField_implementation_from_implementation
  SYMBOL/end SYMBOL/script
                                        $scriptDeclaration__EndScope
				      $methodsTable__EndScope
                                    $esaclass__EndScope

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

%% <<>> implementation
= script-body
                                          $implementation__NewScope
  {[ ?SYMBOL/let @let-statement
                                       $implementation__AppendFrom_statement
   | ?SYMBOL/map @map-statement
                                       $implementation__AppendFrom_statement
   | ?SYMBOL/set @set-statement
                                       $implementation__AppendFrom_statement
   | ?SYMBOL/exit-map @exit-map-statement
                                       $implementation__AppendFrom_statement
   | ?SYMBOL/create @create-statement
                                       $implementation__AppendFrom_statement
   | ?SYMBOL/if @if-statement
                                       $implementation__AppendFrom_statement
   | ?SYMBOL/loop @loop-statement
                                       $implementation__AppendFrom_statement
   | ?SYMBOL/exit-when @exit-when-statement
                                       $implementation__AppendFrom_statement
   | ?'>' @return-statement
                                       $implementation__AppendFrom_statement
   | ?'@' @callInternalStatement
                                       $implementation__AppendFrom_statement
   | &non-keyword-symbol @callExternalStatement
                                       $implementation__AppendFrom_statement
   | * >
  ]
  }
                                          $implementation__Output

= callInternalStatement
  @esa-expr-in-statement
                           $functionReference__NewScope             
                             $functionReference__CoerceFrom_expression
                           $functionReference__Output
                         $statement__NewScope
                             $callInternalStatement__NewScope
                               $callInternalStatement__SetField_functionReference_from_functionReference
                             $callInternalStatement__Output
                          $statement__CoerceFrom_callInternalStatement
                         $statement__Output

= callExternalStatement
  @esa-expr-in-statement
                           $functionReference__NewScope             
                             $functionReference__CoerceFrom_expression
                           $functionReference__Output
                         $statement__NewScope
                             $callExternalStatement__NewScope
                               $callExternalStatement__SetField_functionReference_from_functionReference
                             $callExternalStatement__Output
                          $statement__CoerceFrom_callExternalStatement
                         $statement__Output


= let-statement
  SYMBOL/let
                          $statement__NewScope
                            $letStatement__NewScope
   @esaSymbol-in-statement
                              $varName__NewScope
                                $varName__CoerceFrom_name
                              $varName__Output
                              $letStatement__SetField_varName_from_varName
   '='
   @esa-expr-in-statement
                              $letStatement__SetField_expression_from_expression
   SYMBOL/in 
   @script-body
                              $letStatement__SetField_implementation_from_implementation
   SYMBOL/end SYMBOL/let
                            $letStatement__Output
                            $statement__CoerceFrom_letStatement
                          $statement__Output
 
= map-statement
  SYMBOL/map
                          $statement__NewScope
                            $mapStatement__NewScope
  @esaSymbol-in-statement
                              $varName__NewScope
                                $varName__CoerceFrom_name
                              $varName__Output
                              $mapStatement__SetField_varName_from_varName
  '='
  @esa-expr-in-statement
                              $mapStatement__SetField_expression_from_expression
  SYMBOL/in
  @script-body
                              $mapStatement__SetField_implementation_from_implementation
  SYMBOL/end SYMBOL/map
                            $mapStatement__Output
                            $statement__CoerceFrom_mapStatement
                          $statement__Output
 

= set-statement
  SYMBOL/set
                          $statement__NewScope
                            $setStatement__NewScope
   @esaSymbol-in-statement
                              $varName__NewScope
                                $varName__CoerceFrom_name
                              $varName__Output
                              $setStatement__SetField_varName_from_varName
   '=' 
   @esa-expr-in-statement
                              $setStatement__SetField_expression_from_expression
                            $setStatement__Output
                            $statement__CoerceFrom_setStatement
                          $statement__Output
  
= exit-map-statement
  SYMBOL/exit-map
                          $statement__NewScope
                            $exitMapStatement__NewScope
                            $exitMapStatement__Output
                            $statement__CoerceFrom_exitMapStatement
                          $statement__Output

= loop-statement
  SYMBOL/loop
                          $statement__NewScope
                            $loopStatement__NewScope
    @script-body
                              $loopStatement__SetField_implementation_from_implementation
                            $loopStatement__Output
                            $statement__CoerceFrom_loopStatement
                          $statement__Output
  SYMBOL/end SYMBOL/loop
  
= exit-when-statement
  SYMBOL/exit-when
                          $statement__NewScope
 			    $exitWhenStatement__NewScope
  @esa-expr-in-statement
                              $exitWhenStatement__SetField_expression_from_expression
                            $exitWhenStatement__Output
                            $statement__CoerceFrom_exitWhenStatement
                          $statement__Output

= script-call
  '@' @esa-expr-in-statement

= method-call
  @esa-expr-in-statement


= esaSymbol-in-statement
  @esaSymbol

= esa-expr-in-statement
  @esa-expr

= return-statement
  '>' '>'
  [ ?SYMBOL/true SYMBOL/true
                               $statement__NewScope
                                 $returnTrueStatement__NewScope
                                 $returnTrueStatement__Output
                                 $statement__CoerceFrom_returnTrueStatement
                               $statement__Output
  | ?SYMBOL/false SYMBOL/false
                               $statement__NewScope
                                 $returnFalseStatement__NewScope
                                 $returnFalseStatement__Output
                                 $statement__CoerceFrom_returnFalseStatement
                               $statement__Output
  | * 
                               $statement__NewScope
                                 $returnValueStatement__NewScope
      @esaSymbol-in-statement
                                   $returnValueStatement__SetField_name_from_name
                                 $returnValueStatement__Output
                                 $statement__CoerceFrom_returnValueStatement
                               $statement__Output
  ]


= create-statement
  SYMBOL/create
                          $statement__NewScope
                            $createStatement__NewScope
   @esaSymbol-in-statement
                              $varName__NewScope
                                $varName__CoerceFrom_name
                              $varName__Output
                              $createStatement__SetField_varName_from_varName
   '=' 
                                $indirectionKind__NewScope
   [ ?'*' '*'
                                  $indirectionKind__SetEnum_indirect
   | *
                                  $indirectionKind__SetEnum_direct
   ]
                                $indirectionKind__Output
                              $createStatement__SetField_indirectionKind_from_indirectionKind
   @class-ref-in-statement
                              $createStatement__SetField_name_from_name
   SYMBOL/in 
   @script-body
                              $createStatement__SetField_implementation_from_implementation
   SYMBOL/end SYMBOL/create
                            $createStatement__Output
                            $statement__CoerceFrom_createStatement
                          $statement__Output

= class-ref-in-statement
  @esaSymbol-in-statement

= if-statement
                          $statement__NewScope
                            $ifStatement__NewScope
  SYMBOL/if
    @esa-expr-in-statement
                            $ifStatement__SetField_expression_from_expression
  SYMBOL/then
    @script-body
                              $thenPart__NewScope
                                $thenPart__CoerceFrom_implementation
                              $thenPart__Output
                              $ifStatement__SetField_thenPart_from_thenPart

                              $elsePart__NewScope
  [ ?SYMBOL/else SYMBOL/else
     @script-body
                                  $elsePart__CoerceFrom_implementation
  | *
  ]
                                $elsePart__Output
                             $ifStatement__SetField_elsePart_from_elsePart
  SYMBOL/end SYMBOL/if
                           $ifStatement__Output
                           $statement__CoerceFrom_ifStatement
                         $statement__Output



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


= print-tester
  @esa-dsl
