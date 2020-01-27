(cl:in-package :arrowgrams/compiler/back-end)

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

= <unparse-part> 
  % wires object remains
    .name <unparse-string> -
    .kind <unparse-kind> -
    .inputs <unparse-inputs> -
    .outputs <unparse-outputs> -
    .react <unparse-string> -
    .first-time <unparse-string> -

= <unparse-parts> % tos=parts-list, tos[2]=wires table
  ~foreach {
    .inputs
    $foreach {
      @find-sink-part-pin-in-wires  % no pop, pushes a wire number
        :indexed-sink @emit-if-indexed-sink  % 3 top items wire#, pin, part ; no popping ; if tos==nil, don't emit anything
      }
    -
   }

= <unparse-string>
  :string @send-top
"
    )

    #+nil(let ((sexpr (sl:unparse *unparse-schem-script* "-UNPARSE")))
      (pprint sexpr)
      (eval sexpr)))

  
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
                  (UNPARSE-CALL-RULE U #'UNPARSE-INPUTS-UNPARSE)
                  (LET ()
                    (UNPARSE-POP U)
                    (LET ((OUTPUTS (SLOT-VALUE (UNPARSE-TOS U) 'OUTPUTS)))
                      OUTPUTS
                      (LET ()
                        (UNPARSE-CALL-RULE U #'UNPARSE-OUTPUTS-UNPARSE)
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
(DEFMETHOD UNPARSE-PARTS-UNPARSE
           ((U PARSER))
  (LET ()
    (UNPARSE-FOREACH-IN-LIST
     U
     #'(LAMBDA ()
         (LET ((INPUTS (SLOT-VALUE (UNPARSE-TOS U) 'INPUTS)))
           INPUTS
           (LET ()
             (UNPARSE-FOREACH-IN-TABLE
              U
              #'(LAMBDA ()
                  (LET ()
                    (UNPARSE-CALL-EXTERNAL U #'FIND-SINK-PART-PIN-IN-WIRES)
                    (LET () (UNPARSE-EMIT-TOKEN U :INDEXED-SINK) (LET () (UNPARSE-CALL-EXTERNAL U #'EMIT-IF-INDEXED-SINK))))))
             (LET () (UNPARSE-POP U))))))))

(DEFMETHOD UNPARSE-STRING-UNPARSE ((U PARSER)) (LET () (UNPARSE-EMIT-TOKEN U :STRING) (LET () (UNPARSE-CALL-EXTERNAL U #'SEND-TOP))))