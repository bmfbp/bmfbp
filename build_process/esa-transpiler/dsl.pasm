
= esa-dsl
                                  emitHeader
  @type-decls
  @situations
  @classes
  @whens-and-scripts
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
  {[ ?SYMBOL/type @type-decl
   | * >
  ]}

= type-decl
  SYMBOL/type @esa-symbol

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
  @esa-symbol
%       set-current-class
%$      (emit p "~&(defclass ~a ()~%(" (atext p))
  @field-decl-begin @field-decl
  {[ &field-decl-begin @field-decl
   | * >
  ]}
%$      (emit p "))~%")
  SYMBOL/end SYMBOL/class

- field-decl-begin
  [ ?SYMBOL/map ^ok
  | &non-keyword-symbol ^ok
  | * ^fail
 ]

= field-decl
  [ ?SYMBOL/map
    SYMBOL/map 
    @esa-symbol
  | &non-keyword-symbol @esa-symbol
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
  @esa-symbol % should be checked to be a situation

= or-situation
  SYMBOL/or @situation-ref
  
= class-ref
  @esa-symbol  % should be checked to be a kind

= method-declaration % "when" is always a declaration
  SYMBOL/method @esa-symbol
%$      (emit-to-method-stream p "~%(defgeneric ~a (self" (atext p))
  @generic-typed-formals
%$      (emit-to-method-stream p ")") ;; close parameter list
  @optional-return-type-declaration
%$      (emit-to-method-stream p ")") ;; close generic
  
= script-declaration  % this is a declaration of scripts to be defined
  SYMBOL/script @esa-symbol
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
  @esa-symbol
%$     (emit-to-method-stream p " ~a" (gensym))
  {[ &non-keyword-symbol @esa-symbol
%$     (emit-to-method-stream p " ~a" (gensym))
   | * >
  ]}

= optional-return-type-declaration
  [ ?'>' '>' '>'
         [ ?SYMBOL/map SYMBOL/map @esa-symbol
%$            (emit-to-method-stream p " #|returns map ~a|# " (atext p))
         | * @esa-symbol
%$            (emit-to-method-stream p " #|returns ~a|# " (atext p))
  ]
  | *
  ]



= script-definition
  SYMBOL/script
  @esa-symbol
                                   set-current-class
  @esa-symbol
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
  {[ &non-keyword-symbol @esa-symbol
     % index and type
%$    (emit p " ~a " (atext p))
   | * >
  ]}
  
= optional-return-type-definition  % should check that return type matches the definition
  [ ?'>' '>' '>'
         [ ?SYMBOL/map SYMBOL/map @esa-symbol
         | * @esa-symbol

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
   @esa-symbol
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
   @esa-symbol
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
  SYMBOL/map @esa-symbol
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
  | * @esa-symbol
%$                (emit p "(return-from ~a ~a)" (current-method p) (atext p))
  ]

= esa-symbol
  [ &non-keyword-symbol
    SYMBOL
    @esa-field-follow-nonemitting
  | *
  ]

= esa-field-follow-nonemitting
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


%% emitting

= esa-expr
  [ ?'@' '@' | * ]  % ignore @ (script call symbol)
                                 $expr__NewScope
  [ ?SYMBOL/true SYMBOL/true
                                   $expr__SetKindTrue
  | ?SYMBOL/false SYMBOL/false
                                   $expr__SetKindTrue
  | *
                                   $expr__SetKindObject
    @object__
                                   $expr__setField_object_from_object
   ]
                                 $expr__Output
                                 $expr__Emit

= object__
                                 $object__NewScope
  @object__name
                                   $object__setField_name_from_name
				   $fieldMap__NewScope
  @object__optionalParameterMap
                                   $fieldMap__Output
                                   $object__setField_fieldMap_from_fieldMap
  @object__fieldList
                                 $object__Output

= object__name
                                 $name__NewScope
  @esaSymbol
                                 $name__Output
  
= object__fieldList
  {[ ?'.'
     @object__fieldList__field
   | * >
  ]}


= object__optionalParameterMap
  @object__fieldList__field__optionalParameterMap
  

= object__fieldList__field
  '.'
                                 $object__NewScope
  @object__fieldList__field__name
                                   $object__setField_name_from_name
				   $fieldMap__NewScope
  @object__fieldList__field__optionalParameterMap
                                   $fieldMap__Output
                                   $object__setField_fieldMap_from_fieldMap
                                 $object__Output
				 
= object__fieldList__field__name
                                 $name__NewScope
  @esaSymbol
                                 $name__Output
  
= object__fieldList__field__optionalParameterMap
  [ ?'(' 
     '('
       object__fieldList__field__rec-parameters
     ')'
  | *
  ]

= object__fieldList__field__rec-parameters
  @object__fieldList__field__parameters__parameter
  [ &object__fieldList__field__parameters__pred-parameterBegin
    @object__fieldList__field__rec-parameters
  | *
  ]

- object__fields__field__parameters__pred-parameterBegin
  ?SYMBOL
  
= object__fields__field__parameters__parameter
                                 $name__NewScope
  @esaSymbol
                                 $name_Output

= esaSymbol
  SYMBOL
                                 $name__GetName
  {[ ?'/' '/'                    $name__combine
     SYMBOL                      $name__combine
   | ?'-' '-'                    $name__combine
     SYMBOL                      $name__combine
   | ?'?' '?'                    $name__combine
      >
   | ?CHARACTER/' CHARACTER/'    $name__combine
     >
   | * >
  ]}

  