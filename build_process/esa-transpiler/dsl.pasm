= rmSpaces
  [ ?SPACE | ?COMMENT | * . ]

= esa-dsl
  ~rmSpaces
                            $esaprogram__NewScope
  @type-decls
                                $typeDecls__NewScope
                                $typeDecls__Output
                              $esaprogram__SetField_typeDecls_from_typeDecls
  @situations
  @classes
  @whens-and-scripts
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
  {[ ?SYMBOL/situation @situation | * > ]}

= situation
  SYMBOL/situation SYMBOL

= classes
  {[ ?SYMBOL/class @class-def
   | * >
  ]}

= whens-and-scripts
  {[ ?SYMBOL/script @script-definition
   | ?SYMBOL/when @when-declaration
   | * >
  ]}

= class-def
  SYMBOL/class
  @esaSymbol
  @field-decl-begin @field-decl
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
%$     (emit p "~&(~a :accessor ~a :initform nil)~%" (atext p) (atext p))
  ]

= when-declaration
  SYMBOL/when
  @situation-ref {[ ?SYMBOL/or @or-situation | * > ]}
%$      (clear-method-stream p)
  @class-ref
  {[ ?SYMBOL/script @script-declaration
   | ?SYMBOL/method @method-declaration
   | * >
  ]}
  SYMBOL/end SYMBOL/when

= situation-ref
  @esaSymbol % should be checked to be a situation

= or-situation
  SYMBOL/or @situation-ref
  
= class-ref
  @esaSymbol  % should be checked to be a kind

= method-declaration % "when" is always a declaration
  SYMBOL/method @esaSymbol
%$      (emit-to-method-stream p "~%(defgeneric ~a (self" (atext p))
  @generic-typed-formals
%$      (emit-to-method-stream p ")") ;; close parameter list
  @optional-return-type-declaration
%$      (emit-to-method-stream p ")") ;; close generic
  
= script-declaration  % this is a declaration of scripts to be defined
  SYMBOL/script @esaSymbol
%$      (emit-to-method-stream p "~%(defgeneric ~a #|script|# (self" (atext p))
  @generic-typed-formals
%$      (emit-to-method-stream p ")")
  @optional-return-type-declaration
%$      (emit-to-method-stream p ")") ;; close generic

= generic-typed-formals
  [ ?'(' '(' generic-type-list ')'
  | *
  ]

= generic-type-list
  @esaSymbol
%$     (emit-to-method-stream p " ~a" (gensym))
  {[ &non-keyword-symbol @esaSymbol
%$     (emit-to-method-stream p " ~a" (gensym))
   | * >
  ]}

= optional-return-type-declaration
  [ ?'>' '>' '>'
         [ ?SYMBOL/map SYMBOL/map @esaSymbol
%$            (emit-to-method-stream p " #|returns map ~a|# " (atext p))
         | * @esaSymbol
%$            (emit-to-method-stream p " #|returns ~a|# " (atext p))
  ]
  | *
  ]



= script-definition
  SYMBOL/script
  @esaSymbol
                                   set-current-class
  @esaSymbol
                                   set-current-method
%$      (emit p "~%(defmethod ~a #|script|# ((self ~a)" (current-method p) (current-class p))
  @optional-formals-definition
%$      (emit p ")")  
  @optional-return-type-definition
  @script-body
%$      (emit p ")#|end script|#~%")
  SYMBOL/end SYMBOL/script

= optional-formals-definition
  {[ ?'(' '(' untyped-formals-definition ')'
   | * >
  ]}

= untyped-formals-definition
  {[ &non-keyword-symbol @esaSymbol
     % index and type
%$    (emit p " ~a " (atext p))
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
%$     (emit p "~%")
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
%$      (emit p "(let ((~a " (atext p))
   '='
   [ ?SYMBOL/map SYMBOL/map | * ]
   @esa-expr
%$      (emit p "))")
   SYMBOL/in 
   @script-body
%$      (emit p ")#|end let|#")   
   SYMBOL/end SYMBOL/let

= create-statement
  SYMBOL/create
   @esaSymbol
%$      (emit p "(let ((~a " (atext p))
   '=' 
   [ ?SYMBOL/map SYMBOL/map | * ]
   [ ?'*' '*'
     @class-ref
%$      (emit p "(make-instance ~a)))" (atext p))
   | *
   @class-ref
%$      (emit p "(make-instance ~a)))" (atext p))
   ]
   SYMBOL/in 
   @script-body
%$      (emit p ")#|end create|#")   
   SYMBOL/end SYMBOL/create

= set-statement
  SYMBOL/set
%$      (emit p "(setf ")
   @esa-expr
   '=' 
   @esa-expr
%$      (emit p ")")
  
= map-statement
  SYMBOL/map @esaSymbol
%$      (emit p "(block map (dolist (~a " (atext p))
  '='
  @esa-expr
%$      (emit p ")")
  SYMBOL/in @script-body
%$      (emit p "))#|end map|#")   
  SYMBOL/end SYMBOL/map

= exit-map-statement
  SYMBOL/exit-map
%$     (emit p "(return-from map nil)")

= loop-statement
  SYMBOL/loop
%$     (emit p "(loop")
    @script-body
%$     (emit p ")#|end loop|#")
  SYMBOL/end SYMBOL/loop
  
= exit-when-statement
  SYMBOL/exit-when
%$     (emit p "(when (esa-expr-true ")
    @esa-expr
%$     (emit p ") (return))")

= if-statement
  SYMBOL/if
%$    (emit p "(cond ((esa-expr-true ")
    @esa-expr
%$    (emit p ")")
  SYMBOL/then
%$    (emit p ")")
    @script-body
  [ ?SYMBOL/else SYMBOL/else
%$    (emit p "~%(t  ;else")
     @script-body
%$    (emit p ")#|end else|#~%")
  | *
  ]
%$    (emit p ")#|end if|#")
  SYMBOL/end SYMBOL/if

= script-call
  '@' @esa-expr
%$    (emit p "(call-script p ~a)" (atext p))

= method-call
  @esa-expr
%$    (emit p "(call-external p ~a)" (atext p))

= return-statement
  '>' '>'
  [ ?SYMBOL/true SYMBOL/true
%$                (emit p "(return-from ~a :true)" (current-method p))
  | ?SYMBOL/false SYMBOL/false
%$                (emit p "(return-from ~a :false)" (current-method p))
  | * @esaSymbol
%$                (emit p "(return-from ~a ~a)" (current-method p) (atext p))
  ]

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
  