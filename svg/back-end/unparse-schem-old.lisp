#+nil(eval-when (:compile-toplevel :load-toplevel :execute)
  ;; the unparse DSL is not quite right, leaving unparse code here as a possible guide

  (defparameter *unparse-schem-script*
    "
= <unparse-schematic>
  :schem 
    >object
    .name <unparse-string> -
    .kind <unparse-string> -
    .inputs <unparse-inputs> -
    .outputs <unparse-outputs> -
    .react <unparse-string> -
    .first-time <unparse-string> -
    .wiring
    .parts <unparse-parts> - -
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
    >object
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
    >object .inputs 
    :inputs
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
     ^object

= <unparse-output-wires> % stack=[part, wires-table]
    >object .outputs 
    :outputs
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
     ^object

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
