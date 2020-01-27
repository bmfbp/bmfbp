(cl:in-package :arrowgrams/compiler/back-end/collector)

(defclass unparser (arrowgrams/compiler/back-end:parser)
  ())

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
"
)

(eval (sl:unparse *unparse-schem-script*))
