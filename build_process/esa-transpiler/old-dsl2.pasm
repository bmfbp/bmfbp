%
% in pass2, we deal with creating a data structure every method for every class
%  script methods are "internal" while non-script methods are "external"
%

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
  @esaSymbol

= situations
  {[ ?SYMBOL/situation @parse-situation-def 
   | * > ]}

= parse-situation-def
  SYMBOL/situation 
  @esaSymbol

% in pass2, parsing of class definitions simply puts empty entries into a class table
= classes
  {[ ?SYMBOL/class @class-def
   | * >
  ]}

= parse-whens-and-scripts
  {[ ?SYMBOL/when @when-declaration
       %% create method descriptor for each method and associate it with the given class
   |?SYMBOL/script @script-implementation
       %% ignore in pass2
       %% although, we could check that script implementations match the definitions ...
   | * >
  ]}

= class-def
  SYMBOL/class
  @esaSymbol
                                $esaclass__LookupByName_BeginScope
                                  $esaclass__SetField_methodsTable_empty
                                  $esaclass__SetField_sciprtsTable_empty
  @field-decl                     % we skip fields in pass2 (already done in pass1)
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
    @esaSymbol
  | &non-keyword-symbol @esaSymbol
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
                                  $scriptsTable_EndScope
   | ?SYMBOL/method
                                  $methodsTable_BeginScopeFrom_esaclass
     @method-declaration
                                    $methodsTable__AppendFrom_externalMethod
                                  $methodsTable_EndScope
   | * >
   ]}
  SYMBOL/end SYMBOL/when
                                $esaclass__EndScope

= situation-ref
  @esaSymbol % should be checked to be a situation

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
	                           $returnKind__SetField_name_from_name
         | *
                                   $returnKind_SetEnum_simple
           @esaSymbol
	                           $returnKind__SetField_name_from_name
  ]
  | *
                                   $returnKind_SetEnum_void
  ]
                                 $returnType__SetField_returnKind_from_returnKind
                               $returnType__NewScope





% implementation code ...

= script-implementation
  SYMBOL/script
  @esaSymbol  % class
  @esaSymbol  % script method
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
     % index and typex
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

= let-statement
  SYMBOL/let
   @varName
   '='
   @esa-expr
   SYMBOL/in
   @script-body
   SYMBOL/end SYMBOL/let
= create-statement
  SYMBOL/create
  @varName
   '=' 
   [ ?'*' '*'  %  * means use class contained in expression (indirect), instead of direct name
     @class-ref
   | *
     @class-ref
   ]
   SYMBOL/in 
   @script-body
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
  @esaSymbol

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
  SYMBOL
  {[ ?'/' '/'
     SYMBOL
   | ?'-' '-'
     SYMBOL
   | ?'?' '?'
      >
   | ?CHARACTER/' CHARACTER/'
     >
   | * >
  ]}

