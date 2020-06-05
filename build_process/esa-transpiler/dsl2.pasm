
= rmSpaces
  [ ?SPACE | ?COMMENT | * . ]

= esa-dsl
  ~rmSpaces
  @type-decls
			      
  @situations
  @classes

  @parse-whens-and-scripts
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





% implement code ...

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
  {
   [ ?SYMBOL/let @let-statement
   | ?SYMBOL/map @map-statement
   | ?SYMBOL/exit-map @exit-map-statement
   | ?SYMBOL/set @set-statement
   | ?SYMBOL/create @create-statement
   | ?SYMBOL/if @if-statement
   | ?SYMBOL/loop @loop-statement
   | ?SYMBOL/exit-when @exit-when-statement
   | ?'>' @return-statement
   | ?'@' @esa-expr
   | &non-keyword-symbol @esa-expr
   | * >
  ]}

= let-statement
  SYMBOL/let
   @esaSymbol
   '='
   [ ?SYMBOL/map SYMBOL/map | * ]
   @esa-expr
   SYMBOL/in 
   @script-body
   SYMBOL/end SYMBOL/let

= create-statement
  SYMBOL/create
   @esaSymbol
   '=' 
   [ ?SYMBOL/map SYMBOL/map | * ]
   [ ?'*' '*'
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
  SYMBOL/map @esaSymbol
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

= esa-expr
  [ ?'@' '@' | * ]  % ignore @ (script call symbol)
  [ ?SYMBOL/true SYMBOL/true
  | ?SYMBOL/false SYMBOL/false
  | *
    @object__
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


= tester
  ~rmSpaces
%   @object__
   @esa-expr  
%    @esa-dsl
%  @esa-expr
  