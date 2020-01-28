set current stack
push
pop
push-field to-stack


def <unparse-schematic> from object to main
  :schem
      .name <unparse-string> -
      .kind <unparse-string> -
      .inputs <unparse-inputs> -
      .outputs <unparse-outputs> -
      .react <unparse-string> -
      .first-time <unparse-string> -
      .wiring
      .parts <unparse-parts> - -


def <unparse-inputs> using main
  :LPAR 
    <unparse-string-list>
  :RPAR

def <unparse-outputs> using main
  :LPAR 
    <unparse-string-list>
  :RPAR

def <unparse-string-list> using main
  foreach {
    :string @send-top
  }

def <unparse-parts> using main
  foreach {
    <unparse-part>
  }

def <unparse-part> 








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
    >object2 .inputs 
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

= <unparse-output-wires> % stack=[part, wires-table]
    >object2 .outputs 
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

= <unparse-string>
  :string @send-top

= <emit-pin-name>
  :string @send-top


(defmethod unparse-schematic ((p parser) schem)
  (emit-string p (slot-value schem 'name))
  (emit-string p (slot-value schem 'kind))
  (unparse-inputs p (slot-value schem 'inputs))
  (unparse-outputs p (slot-value schem 'outputs))
  (emit-string p (slot-value schem 'react))
  (emit-string p (slot-value schem 'first-time))
  (unparse-parts  p (slot-value schem 'parts) (slot-value schem 'wiring)))

(defmethod emit-string ((p parser) str)
  (unparse-emit-string str))

(defmethod unparse-inputs ((p parser) string-list)
  (emit :inputs)
  (dolist (str string-list)
    (emit-string p str))
  (emit :end))

(defmethod unparse-outputs ((p parser) string-list)
  (emit :outputs)
  (dolist (str string-list)
    (emit-string p str))
  (emit :end))

(defmethod unparse-parts ((p parser) parts-list wiring-table)
  (dolist (part parts-list)
    (unparse-part p part wiring-table)))

(defmethod unparse-part ((p parser) part-name wiring-table)
  (emit :inputs)
  (dolist (pin-name (inputs p))
    (unparse-input-pin p pin-name part-name wiring-table))
  (emit :end)
  (emit :outputs)
  (dolist (pin-name (outputs p))
    (unparse-output-pin p pin-name part-name wiring-table)))
  (emit :end)


%   emit :inputs (foreach wire ...) :end
%   if pin has no wires, then emit :string name :end
%   if pin has 1 wire,   then emit :string name :integer nnn :end
%   if pin has multiple wires, emit multiple {:integer nnn} pairs

(defmethod unparse-input-pin ((p parser) pin-name part-name wiring-table)
  (emit-sring pin-name)
  (let ((wire-list (lookup-part-pin-in-sinks p wiring-table part-name pin-name)))
    (dolist (wire wire-list)
      (emit-integer wire)))
  (emit :end))

(defmethod unparse-output-pin ((p parser) pin-name part-name wiring-table)
  (emit-sring pin-name)
  (let ((wire-list (lookup-part-pin-in-sources p wiring-table part-name pin-name)))
    (dolist (wire wire-list)
      (emit-integer wire)))
  (emit :end))





                              