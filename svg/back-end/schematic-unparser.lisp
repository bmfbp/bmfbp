#|

= id  -- define a rule, check that 1 item is on the stack
=N id -- define a rule, check that N [2-9] items are on the stack
: id  -- send id as a token kind with nothing as its token-text
! id  -- push id onto stack, pop id
? id  -- pop into id
?. id -- dup tos into id, no pop
. id  -- (push field "id" of top item on stack) onto stack
$foreach id -- map through list, binding each successive element to id
#foreach id -- map through table, binding each successive element to id
<id> -- call "id" (internally defined rule)
ident -- call "ident" (externally defined method)

|#

(in-package :arrowgrams/compiler/back-end)

(defmethod unparse ((self e/part:part) (schem arrowgrams/compiler/back-end/json-collector::schematic))
  (unparse-string (


= unparser-schematic
  :schem 
    ! .name unparse-string 
    ! .kind unparse-string
    ! .inputs unparse-inputs
    ! .outputs unparse-outputs
    ! .react unparse-string
    ! .first-time unparse-string
    ! .wires
    ! .parts unparse-parts
    % skip schem.wiring, since wiring is unparsed as a function of unparse-parts

= unparse-inputs
  :LPAR
    unparse-string-list
  :RPAR

= unparse-outputs
  :LPAR
    unparse-string-list
  :RPAR

= unparse-string-list
  $foreach str {
  :string
    ! str
    @send-top
  }

= unparse-parts
  #foreach part
  unparse-part

=2 unparse-part 
  ?part
  % wires object remains
    .name unparse-string
    .kind unparse-kind
    .inputs unparse-inputs
    .outputs unparse-outputs
    .react unparse-string
    .first-time unparse-string

=2 unparse-parts % tos=parts-list, tos[2]=wires table
  $foreach part {
    .inputs $foreach pin {
      @find-sink-part-pin-in-wires  % no pop, pushes a wire number
        :indexed-sink @emit-if-indexed-sink  % 3 top items wire#, pin, part ; no popping ; if tos==nil, don't emit anything
      }
   }
