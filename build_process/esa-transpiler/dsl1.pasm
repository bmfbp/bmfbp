= rmSpaces
  [ ?SPACE | ?COMMENT | * . ]

= esa-dsl
  ~rmSpaces
                            $esaprogram__NewScope
  @type-decls
                              $esaprogram__SetField_typeDecls_from_typeDecls
  @situations
                              $esaprogram__SetField_situations_from_situations

  @classes
                              $esaprogram__SetField_classes_from_classes

                              $whenDeclarations__NewScope
  @parse-whens-and-scripts
                              $whenDeclarations__Output
                              $esaprogram__SetField_whenDeclarations_from_whenDeclarations
                            $esaprogram__Output
  EOF

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
                       $typeDecls__NewScope  
  {[ ?SYMBOL/type
    @type-decl
                         $typeDecls__AppendFrom_typeDecl
   | * >
  ]}
                       $typeDecls__Output  

= type-decl
                       $typeDecl__NewScope
  SYMBOL/type
  @esaSymbol
                         $typeDecl__SetField_name_from_name
                       $typeDecl__Output

= situations
                       $situations__NewScope
  {[ ?SYMBOL/situation
     @parse-situation-def 
   | * > 
   ]}
                       $situations__Output

= parse-situation-def
  SYMBOL/situation 
  @esaSymbol
                         $situationDefinition__NewScope
			   $situationDefinition__CoerceFrom_name
                         $situationDefinition__Output
                       $situations__AppendFrom_situationDefinition			 

= classes
                       $classes__NewScope
  {[ ?SYMBOL/class @class-def
                         $classes__AppendFrom_esaclass  
   | * >
  ]}
                       $classes__Output

= parse-whens-and-scripts
  {[ ?SYMBOL/when @when-declaration
                              $whenDeclarations__AppendFrom_whenDeclaration
   |?SYMBOL/script @script-implementation
   | * >
  ]}

= class-def
  SYMBOL/class
                            $esaclass__NewScope
  @esaSymbol
                              $esaclass__SetField_name_from_name
			      $fieldMap__NewScope
  @field-decl
                                $fieldMap__AppendFrom_field
  {[ &field-decl-begin @field-decl
                                $fieldMap__AppendFrom_field
   | * >
  ]}
  SYMBOL/end SYMBOL/class
                              $fieldMap__Output
			      $esaclass__SetField_fieldMap_from_fieldMap
                            $esaclass__Output

- field-decl-begin
  [ ?SYMBOL/map ^ok
  | &non-keyword-symbol ^ok
  | * ^fail
 ]

= field-decl
                             $field__NewScope
  [ ?SYMBOL/map
    SYMBOL/map 
    @esaSymbol
                                $fkind__NewScope
                                  $fkind__SetEnum_map
                                $fkind__Output
                              $field__SetField_fkind_from_fkind
                              $field__SetField_name_from_name
  | &non-keyword-symbol @esaSymbol
                                $fkind__NewScope
                                  $fkind__SetEnum_simple
                                $fkind__Output
                              $field__SetField_fkind_from_fkind
                              $field__SetField_name_from_name
  ]
                            $field__Output

= when-declaration
  SYMBOL/when
                              $whenDeclaration__NewScope
  			        $situationReferenceList__NewScope
  @situation-ref
                                  $situationReferenceList__AppendFrom_situationReferenceName
 {[ ?SYMBOL/or
      @or-situation 
                                  $situationReferenceList__AppendFrom_situationReferenceName
  | * >
  ]}
			        $situationReferenceList__Output
			      $whenDeclaration__SetField_situationReferenceList_from_situationReferenceList

  @class-ref
                              $esaKind__NewScope
                                $esaKind__CoerceFrom_name
                              $esaKind__Output
                              $whenDeclaration__SetField_esaKind_from_esaKind

                                $methodDeclarationsAndScriptDeclarations__NewScope
  {[ ?SYMBOL/script @script-declaration
                                    $declarationMethodOrScript__NewScope
                                      $declarationMethodOrScript__CoerceFrom_scriptDeclaration
                                    $declarationMethodOrScript__Output
                                  $methodDeclarationsAndScriptDeclarations__AppendFrom_declarationMethodOrScript
   | ?SYMBOL/method @method-declaration
                                    $declarationMethodOrScript__NewScope
                                      $declarationMethodOrScript__CoerceFrom_methodDeclaration
                                    $declarationMethodOrScript__Output
                                  $methodDeclarationsAndScriptDeclarations__AppendFrom_declarationMethodOrScript
   | * 
                                    $declarationMethodOrScript__NewScope
                                    $declarationMethodOrScript__Output
                                  $methodDeclarationsAndScriptDeclarations__AppendFrom_declarationMethodOrScript
     >
  ]}
                                $methodDeclarationsAndScriptDeclarations__Output
                              $whenDeclaration__SetField_methodDeclarationsAndScriptDeclarations_from_methodDeclarationsAndScriptDeclarations
  SYMBOL/end SYMBOL/when
                            $whenDeclaration__Output

= situation-ref
  @esaSymbol % should be checked to be a situation
                            $situationReferenceName__NewScope
                              $situationReferenceName__CoerceFrom_name
                            $situationReferenceName__Output

= or-situation
  SYMBOL/or @situation-ref
  
= class-ref
  @esaSymbol  % should be checked to be a kind

= method-declaration % "when" is always a declaration (of methods (external) and scripts (internal methods)
                                      $methodDeclaration__NewScope
  SYMBOL/method @esaSymbol
                                        $methodDeclaration__SetField_name_from_name
  @formals
                                        $methodDeclaration__SetField_formalList_from_formalList
  @return-type-declaration
                                        $methodDeclaration__SetField_returnType_from_returnType
                                      $methodDeclaration__Output
  
= script-declaration  % this is a (forward) declaration of scripts which will be defined later
                                      $scriptDeclaration__NewScope
  SYMBOL/script @esaSymbol
                                        $scriptDeclaration__SetField_name_from_name
  @formals
                                        $scriptDeclaration__SetField_formalList_from_formalList
  @return-type-declaration
                                        $scriptDeclaration__SetField_returnType_from_returnType
                                      $scriptDeclaration__Output

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
  [ ?'>' '>' '>'
         [ ?SYMBOL/map SYMBOL/map
                                      $returnKind__NewScope
                                         $returnKind__SetEnum_map
                                      $returnKind__Output
           @esaSymbol
	                              $returnType__SetField_name_from_name
         | *
                                      $returnKind__NewScope
                                         $returnKind__SetEnum_simple
                                      $returnKind__Output
           @esaSymbol
	                              $returnType__SetField_name_from_name
  ]
  | *
                                      $returnKind__NewScope
                                         $returnKind__SetEnum_void
                                      $returnKind__Output
  ]
                                      $returnType__SetField_returnKind_from_returnKind

                                    $returnType__Output




% implement code ...

= script-implementation
  SYMBOL/script
  @esaSymbol  % class
                                    $name__IgnoreInPass1
  @esaSymbol  % script method
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
check-stacks

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
  
