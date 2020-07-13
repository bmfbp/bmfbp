= pass2-rmSpaces
  [ ?SPACE | ?COMMENT | * . ]

= pass2-esa-dsl
  ~rmSpaces
  @pass2-type-decls
			      
  @pass2-situations
  @pass2-classes

  @pass2-parse-whens-and-scripts
  EOF

- pass2-keyword-symbol
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

- pass2-non-keyword-symbol
  [ ?SYMBOL
    [ &pass2-keyword-symbol ^fail
    | * ^ok
    ]
  | * ^fail
  ]

= pass2-type-decls
  {[ ?SYMBOL/type
    @pass2-type-decl
   | * >
  ]}

= pass2-type-decl
  SYMBOL/type
  @pass2-esaSymbol

= pass2-situations
  {[ ?SYMBOL/situation @pass2-parse-situation-def 
   | * > ]}

= pass2-parse-situation-def
  SYMBOL/situation 
  @pass2-esaSymbol

= pass2-classes
  {[ ?SYMBOL/class @pass2-class-def
   | * >
  ]}

= pass2-parse-whens-and-scripts
  {[ ?SYMBOL/when @pass2-when-declaration
   |?SYMBOL/script @pass2-script-implementation
   | * >
  ]}

= pass2-class-def
  SYMBOL/class
  @pass2-esaSymbol
  @pass2-field-decl
  {[ &pass2-field-decl-begin @pass2-field-decl
   | * >
  ]}
  SYMBOL/end SYMBOL/class

- pass2-field-decl-begin
  [ ?SYMBOL/map ^ok
  | &pass2-non-keyword-symbol ^ok
  | * ^fail
 ]

= pass2-field-decl
  [ ?SYMBOL/map
    SYMBOL/map 
    @pass2-esaSymbol
  | &pass2-non-keyword-symbol @pass2-esaSymbol
  ]

= pass2-when-declaration
  SYMBOL/when
  @pass2-situation-ref
  {
  [ ?SYMBOL/or
      @pass2-or-situation 
  | * >
  ]
  }

  @pass2-class-ref
                   $$class__BeginScope_LookupByName

  {
  [ ?SYMBOL/script @pass2-script-declaration
   | ?SYMBOL/method @pass2-method-declaration
   | * >
  ]
  }
  SYMBOL/end SYMBOL/when
                  $$class_EndScope

= pass2-situation-ref
  @pass2-esaSymbol % should be checked to be a situation

= pass2-or-situation
  SYMBOL/or @pass2-situation-ref
  
= pass2-class-ref
                 $name__NewScope
  @pass2-esaSymbol  % should be checked to be a kind
                 $name__Output

= pass2-method-declaration % "when" is always a declaration (of methods (external) and scripts (internal methods)
  SYMBOL/method @pass2-esaSymbol
  @pass2-formals
  @pass2-return-type-declaration
  
= pass2-script-declaration  % this is a (forward) declaration of scripts which will be defined later
  SYMBOL/script @pass2-esaSymbol
  @pass2-formals
  @pass2-return-type-declaration

= pass2-formals
  [ ?'(' 
     '(' 
     type-list 
     ')'
  | *
  ]

= pass2-type-list
  @pass2-esaSymbol
  {[ &pass2-non-keyword-symbol
     @pass2-esaSymbol
   | * >
  ]}

= pass2-return-type-declaration
  [ ?'>' '>' '>'
         [ ?SYMBOL/map SYMBOL/map
           @pass2-esaSymbol
         | *
           @pass2-esaSymbol
  ]
  | *
  ]





% implement code ...

= pass2-script-implementation
  SYMBOL/script
  @pass2-esaSymbol  % class
  @pass2-esaSymbol  % script method
%$      (emit p "~%(defmethod ~a #|script|# ((self ~a)" (current-method p) (current-class p))
  @pass2-optional-formals-definition
%$      (emit p ")")  
  @pass2-optional-return-type-definition
  @pass2-script-body
%$      (emit p ")#|end script|#~%")
  SYMBOL/end SYMBOL/script

= pass2-optional-formals-definition
  {[ ?'(' '(' untyped-formals-definition ')'
   | * >
  ]}

= pass2-untyped-formals-definition
  {[ &pass2-non-keyword-symbol @pass2-esaSymbol
     % index and type
%$    (emit p " ~a " (atext p))
   | * >
  ]}
  
= pass2-optional-return-type-definition  % should check that return type matches the definition
  [ ?'>' '>' '>'
         [ ?SYMBOL/map SYMBOL/map @pass2-esaSymbol
         | * @pass2-esaSymbol

  ]
  | *
  ]  
  
= pass2-script-body
  {
%$     (emit p "~%")
   [ ?SYMBOL/let @pass2-let-statement
   | ?SYMBOL/map @pass2-map-statement
   | ?SYMBOL/exit-map @pass2-exit-map-statement
   | ?SYMBOL/set @pass2-set-statement
   | ?SYMBOL/create @pass2-create-statement
   | ?SYMBOL/if @pass2-if-statement
   | ?SYMBOL/loop @pass2-loop-statement
   | ?SYMBOL/exit-when @pass2-exit-when-statement
   | ?'>' @pass2-return-statement
   | ?'@pass2-' @pass2-esa-expr
   | &pass2-non-keyword-symbol @pass2-esa-expr
   | * >
  ]}

= pass2-let-statement
  SYMBOL/let
   @pass2-esaSymbol
%$      (emit p "(let ((~a " (atext p))
   '='
   [ ?SYMBOL/map SYMBOL/map | * ]
   @pass2-esa-expr
%$      (emit p "))")
   SYMBOL/in 
   @pass2-script-body
%$      (emit p ")#|end let|#")   
   SYMBOL/end SYMBOL/let

= pass2-create-statement
  SYMBOL/create
   @pass2-esaSymbol
%$      (emit p "(let ((~a " (atext p))
   '=' 
   [ ?SYMBOL/map SYMBOL/map | * ]
   [ ?'*' '*'
     @pass2-class-ref
%$      (emit p "(make-instance ~a)))" (atext p))
   | *
   @pass2-class-ref
%$      (emit p "(make-instance ~a)))" (atext p))
   ]
   SYMBOL/in 
   @pass2-script-body
%$      (emit p ")#|end create|#")   
   SYMBOL/end SYMBOL/create

= pass2-set-statement
  SYMBOL/set
%$      (emit p "(setf ")
   @pass2-esa-expr
   '=' 
   @pass2-esa-expr
%$      (emit p ")")
  
= pass2-map-statement
  SYMBOL/map @pass2-esaSymbol
%$      (emit p "(block map (dolist (~a " (atext p))
  '='
  @pass2-esa-expr
%$      (emit p ")")
  SYMBOL/in @pass2-script-body
%$      (emit p "))#|end map|#")   
  SYMBOL/end SYMBOL/map

= pass2-exit-map-statement
  SYMBOL/exit-map
%$     (emit p "(return-from map nil)")

= pass2-loop-statement
  SYMBOL/loop
%$     (emit p "(loop")
    @pass2-script-body
%$     (emit p ")#|end loop|#")
  SYMBOL/end SYMBOL/loop
  
= pass2-exit-when-statement
  SYMBOL/exit-when
%$     (emit p "(when (esa-expr-true ")
    @pass2-esa-expr
%$     (emit p ") (return))")

= pass2-if-statement
  SYMBOL/if
%$    (emit p "(cond ((esa-expr-true ")
    @pass2-esa-expr
%$    (emit p ")")
  SYMBOL/then
%$    (emit p ")")
    @pass2-script-body
  [ ?SYMBOL/else SYMBOL/else
%$    (emit p "~%(t  ;else")
     @pass2-script-body
%$    (emit p ")#|end else|#~%")
  | *
  ]
%$    (emit p ")#|end if|#")
  SYMBOL/end SYMBOL/if

= pass2-script-call
  '@pass2-' @pass2-esa-expr
%$    (emit p "(call-script p ~a)" (atext p))

= pass2-method-call
  @pass2-esa-expr
%$    (emit p "(call-external p ~a)" (atext p))

= pass2-return-statement
  '>' '>'
  [ ?SYMBOL/true SYMBOL/true
%$                (emit p "(return-from ~a :true)" (current-method p))
  | ?SYMBOL/false SYMBOL/false
%$                (emit p "(return-from ~a :false)" (current-method p))
  | * @pass2-esaSymbol
%$                (emit p "(return-from ~a ~a)" (current-method p) (atext p))
  ]

= pass2-esa-expr
  [ ?'@pass2-' '@pass2-' | * ]  % ignore @pass2- (script call symbol)
  [ ?SYMBOL/true SYMBOL/true
  | ?SYMBOL/false SYMBOL/false
  | *
    @pass2-object__
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
= pass2-object__
  @pass2-object__name
  @pass2-object__fields

= pass2-object__name
  @pass2-esaSymbol
				 
  
% <<>>fieldMap
= pass2-object__fields
  {[ &pass2-object__field_p
         @pass2-object__single_field
   | * >
  ]}

- pass2-object__field_p
  [ ?'.' ^ok
  | ?'(' ^ok
  | * ^fail
  ]

= pass2-object__single_field
  [ ?'.'
     @pass2-object__dotFieldName
     @pass2-object__parameterMap
  | ?'('
     @pass2-object__parameterMap
  | *
  ]

= pass2-object__dotFieldName
  '.'
  @pass2-esaSymbol

= pass2-object__parameterMap
  [ ?'('
     '('
       @pass2-esa-expr
       @pass2-object__field__recursive-more-parameters
     ')'
  | *
  ]

= pass2-object__field__recursive-more-parameters
  [ &pass2-object__field__parameters__pred-parameterBegin
    @pass2-esa-expr
    @pass2-object__field__recursive-more-parameters
  | *
  ]

- pass2-object__field__parameters__pred-parameterBegin
  [ ?SYMBOL ^ok
  | * ^fail
  ]
  
= pass2-object__field__parameters__parameter
  @pass2-esaSymbol

= pass2-esaSymbol
  SYMBOL
      >
   | ?CHARACTER/' CHARACTER/'
     >
   | * >
  ]}


= pass2-tester
  ~pass2-rmSpaces
%   @pass2-object__
   @pass2-esa-expr  
%    @pass2-esa-dsl
%  @pass2-esa-expr
  