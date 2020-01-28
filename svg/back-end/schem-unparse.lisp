(in-package :arrowgrams/compiler/back-end)

(eval-when (:compile-toplevel :load-toplevel :execute)

  (defparameter *unparse-schem-script*
    "
= <unparse-schematic>
  :schem 
    ! .name <unparse-string> -
    ! .kind <unparse-string> -
    ! .inputs <unparse-inputs> -
    ! .outputs <unparse-outputs> -
    ! .react <unparse-string> -
    ! .first-time <unparse-string> -
    ! .wires
    ! .parts <unparse-parts> - -
    % skip schem.wiring, since wiring is unparsed as a function of unparse-parts

= <unparse-inputs>
  :LPAR
    <unparse-string-list>
  :RPAR

= <unparse-outputs>
  :LPAR
    <unparse-string-list>
  :RPAR

= <unparse-string-list>
  ~foreach {
    :string
    @send-top
  }

= <unparse-parts>
  $foreach {
    <unparse-part>
  }

= <unparse-part>  % stack=[part, wires table]
    .name <unparse-string> -
    .kind <unparse-kind> -
    .inputs <unparse-input-wires> -
    .outputs <unparse-output-wires> -
    .react <unparse-string> -
    .first-time <unparse-string> -

%   emit :inputs (foreach wire ...) :end
%   if pin has no wires, then emit :string name :end
%   if pin has 1 wire,   then emit :string name :integer nnn :end
%   if pin has multiple wires, emit multiple {:integer nnn} pairs

= <unparse-input-wires> % stack=[part, wires-table]
    .inputs :inputs
    ~foreach {              % stack=[input, part, wires-table]
        <emit-pin-name>
        &3                  % stack=[wires-table, input, part, wires-table]
        $foreach {          % foreach wire
                            % stack=[wire, wires-table, input, part, wires-table]
          @find-sink-part-pin-in-wires  % no pop, pushes a wire number if part-pin found for wire sink, else nil
            @emit-wire-if   % if tos==nil, don't emit anything, else emit {:integer wire#}
        }
        -                   % pop &3, stack=[input, part, wires-table]
     }
     :end
     -

= <unparse-output-wires> % stack=[part, wires-table]
    .outputs :outputs
    ~foreach {              % stack=[output, part, wires-table]
        <emit-pin-name>
        &3                  % stack=[wires-table, output, part, wires-table]
        $foreach {          % foreach wire
                            % stack=[wire, wires-table, output, part, wires-table]
          @find-source-part-pin-in-wires  % no pop, pushes a wire number if part-pin found for wire source, else nil
            @emit-wire-if   % if tos==nil, don't emit anything, else emit {:integer wire#}
        }
        -                   % pop &3, stack=[output, part, wires-table]
     }
     :end
     -

= <unparse-string>
  :string @send-top

= <emit-pin-name>
  :string @send-top
"
    )

    #+nil(let ((sexpr (sl:unparse arrowgrams/compiler/back-end::*unparse-schem-script* "-UNPARSE")))
      ;(pprint sexpr)
      (eval sexpr))
)

  (DEFMETHOD UNPARSE-SCHEMATIC-UNPARSE
    ((U PARSER))
    (LET ()
      (UNPARSE-EMIT-TOKEN U :SCHEM)
      (LET ()
        (UNPARSE-PUSH U (LET ((NAME (SLOT-VALUE (UNPARSE-TOS U) 'NAME))) NAME))
        (LET ()
          (UNPARSE-CALL-RULE U #'UNPARSE-STRING-UNPARSE)
          (LET ()
            (UNPARSE-POP U)
            (LET ()
              (UNPARSE-PUSH U (LET ((KIND (SLOT-VALUE (UNPARSE-TOS U) 'KIND))) KIND))
              (LET ()
                (UNPARSE-CALL-RULE U #'UNPARSE-STRING-UNPARSE)
                (LET ()
                  (UNPARSE-POP U)
                  (LET ()
                    (UNPARSE-PUSH U (LET ((INPUTS (SLOT-VALUE (UNPARSE-TOS U) 'INPUTS))) INPUTS))
                    (LET ()
                      (UNPARSE-CALL-RULE U #'UNPARSE-INPUTS-UNPARSE)
                      (LET ()
                        (UNPARSE-POP U)
                        (LET ()
                          (UNPARSE-PUSH U (LET ((OUTPUTS (SLOT-VALUE (UNPARSE-TOS U) 'OUTPUTS))) OUTPUTS))
                          (LET ()
                            (UNPARSE-CALL-RULE U #'UNPARSE-OUTPUTS-UNPARSE)
                            (LET ()
                              (UNPARSE-POP U)
                              (LET ()
                                (UNPARSE-PUSH U (LET ((REACT (SLOT-VALUE (UNPARSE-TOS U) 'REACT))) REACT))
                                (LET ()
                                  (UNPARSE-CALL-RULE U #'UNPARSE-STRING-UNPARSE)
                                  (LET ()
                                    (UNPARSE-POP U)
                                    (LET ()
                                      (UNPARSE-PUSH U (LET ((FIRST-TIME (SLOT-VALUE (UNPARSE-TOS U) 'FIRST-TIME))) FIRST-TIME))
                                      (LET ()
                                        (UNPARSE-CALL-RULE U #'UNPARSE-STRING-UNPARSE)
                                        (LET ()
                                          (UNPARSE-POP U)
                                          (LET ()
                                            (UNPARSE-PUSH U (LET ((WIRES (SLOT-VALUE (UNPARSE-TOS U) 'WIRES))) WIRES))
                                            (LET ()
                                              (UNPARSE-PUSH U (LET ((PARTS (SLOT-VALUE (UNPARSE-TOS U) 'PARTS))) PARTS))
                                              (LET ()
                                                (UNPARSE-CALL-RULE U #'UNPARSE-PARTS-UNPARSE)
                                                (LET () (UNPARSE-POP U) (LET () (UNPARSE-POP U))))))))))))))))))))))))))
  (DEFMETHOD UNPARSE-INPUTS-UNPARSE
    ((U PARSER))
    (LET () (UNPARSE-EMIT-TOKEN U :LPAR) (LET () (UNPARSE-CALL-RULE U #'UNPARSE-STRING-LIST-UNPARSE) (LET () (UNPARSE-EMIT-TOKEN U :RPAR)))))
  (DEFMETHOD UNPARSE-OUTPUTS-UNPARSE
    ((U PARSER))
    (LET () (UNPARSE-EMIT-TOKEN U :LPAR) (LET () (UNPARSE-CALL-RULE U #'UNPARSE-STRING-LIST-UNPARSE) (LET () (UNPARSE-EMIT-TOKEN U :RPAR)))))
  (DEFMETHOD UNPARSE-STRING-LIST-UNPARSE
    ((U PARSER))
    (LET () (UNPARSE-FOREACH-IN-LIST U #'(LAMBDA () (LET () (UNPARSE-EMIT-TOKEN U :STRING) (LET () (UNPARSE-CALL-EXTERNAL U #'SEND-TOP)))))))
  (DEFMETHOD UNPARSE-PARTS-UNPARSE ((U PARSER)) (LET () (UNPARSE-FOREACH-IN-TABLE U #'(LAMBDA () (LET () (UNPARSE-CALL-RULE U #'UNPARSE-PART-UNPARSE))))))
  (DEFMETHOD UNPARSE-PART-UNPARSE
    ((U PARSER))
    (LET ((NAME (SLOT-VALUE (UNPARSE-TOS U) 'NAME)))
      NAME
      (LET ()
        (UNPARSE-CALL-RULE U #'UNPARSE-STRING-UNPARSE)
        (LET ()
          (UNPARSE-POP U)
          (LET ((KIND (SLOT-VALUE (UNPARSE-TOS U) 'KIND)))
            KIND
            (LET ()
              (UNPARSE-CALL-RULE U #'UNPARSE-KIND-UNPARSE)
              (LET ()
                (UNPARSE-POP U)
                (LET ((INPUTS (SLOT-VALUE (UNPARSE-TOS U) 'INPUTS)))
                  INPUTS
                  (LET ()
                    (UNPARSE-CALL-RULE U #'UNPARSE-INPUT-WIRES-UNPARSE)
                    (LET ()
                      (UNPARSE-POP U)
                      (LET ((OUTPUTS (SLOT-VALUE (UNPARSE-TOS U) 'OUTPUTS)))
                        OUTPUTS
                        (LET ()
                          (UNPARSE-CALL-RULE U #'UNPARSE-OUTPUT-WIRES-UNPARSE)
                          (LET ()
                            (UNPARSE-POP U)
                            (LET ((REACT (SLOT-VALUE (UNPARSE-TOS U) 'REACT)))
                              REACT
                              (LET ()
                                (UNPARSE-CALL-RULE U #'UNPARSE-STRING-UNPARSE)
                                (LET ()
                                  (UNPARSE-POP U)
                                  (LET ((FIRST-TIME (SLOT-VALUE (UNPARSE-TOS U) 'FIRST-TIME)))
                                    FIRST-TIME
                                    (LET () (UNPARSE-CALL-RULE U #'UNPARSE-STRING-UNPARSE) (LET () (UNPARSE-POP U))))))))))))))))))))
  (DEFMETHOD UNPARSE-INPUT-WIRES-UNPARSE
    ((U PARSER))
    (LET ((INPUTS (SLOT-VALUE (UNPARSE-TOS U) 'INPUTS)))
      INPUTS
      (LET ()
        (UNPARSE-EMIT-TOKEN U :INPUTS)
        (LET ()
          (UNPARSE-FOREACH-IN-LIST
           U
           #'(LAMBDA ()
               (LET ()
                 (UNPARSE-CALL-RULE U #'EMIT-PIN-NAME-UNPARSE)
                 (LET ()
                   (UNPARSE-DUPN U 3)
                   (LET ()
                     (UNPARSE-FOREACH-IN-TABLE
                      U
                      #'(LAMBDA () (LET () (UNPARSE-CALL-EXTERNAL U #'FIND-SINK-PART-PIN-IN-WIRES) (LET () (UNPARSE-CALL-EXTERNAL U #'EMIT-WIRE-IF)))))
                     (LET () (UNPARSE-POP U)))))))
          (LET () (UNPARSE-EMIT-TOKEN U :END) (LET () (UNPARSE-POP U)))))))
  (DEFMETHOD UNPARSE-OUTPUT-WIRES-UNPARSE
    ((U PARSER))
    (LET ((OUTPUTS (SLOT-VALUE (UNPARSE-TOS U) 'OUTPUTS)))
      OUTPUTS
      (LET ()
        (UNPARSE-EMIT-TOKEN U :OUTPUTS)
        (LET ()
          (UNPARSE-FOREACH-IN-LIST
           U
           #'(LAMBDA ()
               (LET ()
                 (UNPARSE-CALL-RULE U #'EMIT-PIN-NAME-UNPARSE)
                 (LET ()
                   (UNPARSE-DUPN U 3)
                   (LET ()
                     (UNPARSE-FOREACH-IN-TABLE
                      U
                      #'(LAMBDA () (LET () (UNPARSE-CALL-EXTERNAL U #'FIND-SOURCE-PART-PIN-IN-WIRES) (LET () (UNPARSE-CALL-EXTERNAL U #'EMIT-WIRE-IF)))))
                     (LET () (UNPARSE-POP U)))))))
          (LET () (UNPARSE-EMIT-TOKEN U :END) (LET () (UNPARSE-POP U)))))))
  (DEFMETHOD UNPARSE-STRING-UNPARSE ((U PARSER)) (LET () (UNPARSE-EMIT-TOKEN U :STRING) (LET () (UNPARSE-CALL-EXTERNAL U #'SEND-TOP))))
  (DEFMETHOD EMIT-PIN-NAME-UNPARSE ((U PARSER)) (LET () (UNPARSE-EMIT-TOKEN U :STRING) (LET () (UNPARSE-CALL-EXTERNAL U #'SEND-TOP))))
