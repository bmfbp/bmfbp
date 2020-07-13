(in-package :arrowgrams/compiler)

#+nil
(eval-when (:compile-toplevel)

  (defparameter *collector-rules*
    "
= <ir> 
                          schematic/open
  :lpar
    <top-name>            schematic/set-name-from-string
    <kind>                schematic/set-kind-from-string
    <meta>                schematic/set-meta-from-string
    <inputs>              schematic/set-inputs-from-list list/pop
    <outputs>             schematic/set-outputs-from-list list/pop
    <react>               schematic/set-react-from-string
    <first-time>          schematic/set-first-time-from-string

                          table/new
    <part-declarations>
                          schematic/set-parts-from-table-pop-table
                          table/close-pop

                          table/new
    <wiring>
                          schematic/set-wiring-from-table-pop-table
                          table/close-pop
  :rpar
                          schematic/close-pop
= <top-name>
  :string

= <inputs>
                                        list/new
  [ ?symbol :symbol symbol-must-be-nil  
  | ?lpar :lpar <pin-list> :rpar]       list/close

= <outputs>                             list/new
  [ ?symbol :symbol symbol-must-be-nil  
  | ?lpar :lpar <pin-list> :rpar]       list/close

= <part-declarations> 
  :lpar <part-decl-list> :rpar

= <pin-list> 
  <ident-list>

= <ident-list> 
  :string                               rm-quotes list/add-string
  [ ?string <ident-list> ]

= <part-decl-list> 
  [ ?lpar <part-decl> [ ?lpar <part-decl-list> ] | ! ]

= <part-decl>
                                        part/new
  :lpar
    <name>                              rm-quotes part/set-name
    <kind>                              rm-quotes part/set-kind
    <inputs>                            part/set-inputs-from-list list/pop
    <outputs>                           part/set-outputs-from-list list/pop
    <react>                             rm-quotes part/set-react
    <first-time>                        rm-quotes part/set-first-time
  :rpar           
                                        table/add-part
                                        part/close-pop

= <name>
  :string

= <meta>
  :string

= <kind>
  :string

= <react>
  :string

= <first-time>
  :string

= <wiring>                            % stack=[table]
  :lpar                                 
    <wire-list>
  :rpar

= <wire-list>
  <wire>                              table/add-wire  wire/pop
  [ ?lpar <wire-list> ] 

= <wire>                                                                 % stacks:{table} <- puts a wire into the tos table
  :lpar                               wire/new                           % stacks:{wire,table}
    :integer                          wire/set-index
  
                                      sources-list/new
    <wire-sources>                    wire/set-sources-list
                                      sources-list/close-pop

                                      sinks-list/new
    <wire-sinks>                      wire/set-sinks-list
                                      sinks-list/close-pop

  :rpar                               table/add-wire
                                      wire/close

= <wire-sources>                                                          % stacks:{sources-list,wire,table}
                                      part-pin-pair-list/new              % stacks:{part-pin-pair-list, sources-list, wire, table}
    :lpar <many-part-pin-pairs> :rpar sources-list/becomes-part-pin-pair-list
                                      part-pin-pair-list/close-pop        % stacks:{sources-list, table}

= <many-part-pin-pairs>                                                   % stacks:{part-pin-pair-list, sources-list, wire,table}
  [ 
    ?lpar                             part-pin-pair/new                   % stacks:{part-pin-pair, part-pin-pair-list, sources-list, wire, table}
       <part-pin-pair>                part-pin-pair-list/add-pair         % stacks:{part-pin-pair, part-pin-pair-list, sources-list, wire,table}
                                      part-pin-pair/close-pop             % stacks:{part-pin-pair-list, sources-list, wire, table}
       <many-part-pin-pairs>
    | !
  ]

= <part-pin-pair>
    :lpar                             
      <part>
      <pin>
    :rpar                             

= <part>
  :string                             rm-quotes part-pin-pair/add-first-string
= <pin>
  :string                             rm-quotes part-pin-pair/add-second-string

= <wire-sinks>                        part-pin-pair-list/new
    :lpar <many-part-pin-pairs> :rpar sinks-list/becomes-part-pin-pair-list
                                      part-pin-pair-list/close-pop

"
    )


#+nil    (defmacro xxx () (sl:parse *collector-rules* "-COLLECTOR")))

#+nil (xxx)

#+nil (sl:parse *collector-rules* "-COLLECTOR")

(PROGN
 (DEFMETHOD IR-COLLECTOR ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'IR-COLLECTOR))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'SCHEMATIC/OPEN DEPTH CURRENT-METHOD)
     (MUST-SEE P :LPAR)
     (CALL-RULE P #'TOP-NAME-COLLECTOR DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'SCHEMATIC/SET-NAME-FROM-STRING DEPTH CURRENT-METHOD)
     (CALL-RULE P #'KIND-COLLECTOR DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'SCHEMATIC/SET-KIND-FROM-STRING DEPTH CURRENT-METHOD)
     (CALL-RULE P #'META-COLLECTOR DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'SCHEMATIC/SET-META-FROM-STRING DEPTH CURRENT-METHOD)
     (CALL-RULE P #'INPUTS-COLLECTOR DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'SCHEMATIC/SET-INPUTS-FROM-LIST DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'LIST/POP DEPTH CURRENT-METHOD)
     (CALL-RULE P #'OUTPUTS-COLLECTOR DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'SCHEMATIC/SET-OUTPUTS-FROM-LIST DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'LIST/POP DEPTH CURRENT-METHOD)
     (CALL-RULE P #'REACT-COLLECTOR DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'SCHEMATIC/SET-REACT-FROM-STRING DEPTH CURRENT-METHOD)
     (CALL-RULE P #'FIRST-TIME-COLLECTOR DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'SCHEMATIC/SET-FIRST-TIME-FROM-STRING DEPTH
                    CURRENT-METHOD)
     (CALL-EXTERNAL P #'TABLE/NEW DEPTH CURRENT-METHOD)
     (CALL-RULE P #'PART-DECLARATIONS-COLLECTOR DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'SCHEMATIC/SET-PARTS-FROM-TABLE-POP-TABLE DEPTH
                    CURRENT-METHOD)
     (CALL-EXTERNAL P #'TABLE/CLOSE-POP DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'TABLE/NEW DEPTH CURRENT-METHOD)
     (CALL-RULE P #'WIRING-COLLECTOR DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'SCHEMATIC/SET-WIRING-FROM-TABLE-POP-TABLE DEPTH
                    CURRENT-METHOD)
     (CALL-EXTERNAL P #'TABLE/CLOSE-POP DEPTH CURRENT-METHOD)
     (MUST-SEE P :RPAR)
     (CALL-EXTERNAL P #'SCHEMATIC/CLOSE-POP DEPTH CURRENT-METHOD)))
 (DEFMETHOD TOP-NAME-COLLECTOR ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'TOP-NAME-COLLECTOR))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)))
 (DEFMETHOD INPUTS-COLLECTOR ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'INPUTS-COLLECTOR))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'LIST/NEW DEPTH CURRENT-METHOD)
     (COND
      ((LOOK-AHEAD P :SYMBOL) (MUST-SEE P :SYMBOL)
       (CALL-EXTERNAL P #'SYMBOL-MUST-BE-NIL DEPTH CURRENT-METHOD))
      ((LOOK-AHEAD P :LPAR) (MUST-SEE P :LPAR)
       (CALL-RULE P #'PIN-LIST-COLLECTOR DEPTH CURRENT-METHOD)
       (MUST-SEE P :RPAR)))
     (CALL-EXTERNAL P #'LIST/CLOSE DEPTH CURRENT-METHOD)))
 (DEFMETHOD OUTPUTS-COLLECTOR ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'OUTPUTS-COLLECTOR))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'LIST/NEW DEPTH CURRENT-METHOD)
     (COND
      ((LOOK-AHEAD P :SYMBOL) (MUST-SEE P :SYMBOL)
       (CALL-EXTERNAL P #'SYMBOL-MUST-BE-NIL DEPTH CURRENT-METHOD))
      ((LOOK-AHEAD P :LPAR) (MUST-SEE P :LPAR)
       (CALL-RULE P #'PIN-LIST-COLLECTOR DEPTH CURRENT-METHOD)
       (MUST-SEE P :RPAR)))
     (CALL-EXTERNAL P #'LIST/CLOSE DEPTH CURRENT-METHOD)))
 (DEFMETHOD PART-DECLARATIONS-COLLECTOR ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'PART-DECLARATIONS-COLLECTOR))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :LPAR)
     (CALL-RULE P #'PART-DECL-LIST-COLLECTOR DEPTH CURRENT-METHOD)
     (MUST-SEE P :RPAR)))
 (DEFMETHOD PIN-LIST-COLLECTOR ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'PIN-LIST-COLLECTOR))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (CALL-RULE P #'IDENT-LIST-COLLECTOR DEPTH CURRENT-METHOD)))
 (DEFMETHOD IDENT-LIST-COLLECTOR ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'IDENT-LIST-COLLECTOR))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)
     (CALL-EXTERNAL P #'RM-QUOTES DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'LIST/ADD-STRING DEPTH CURRENT-METHOD)
     (COND
      ((LOOK-AHEAD P :STRING)
       (CALL-RULE P #'IDENT-LIST-COLLECTOR DEPTH CURRENT-METHOD)))))
 (DEFMETHOD PART-DECL-LIST-COLLECTOR ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'PART-DECL-LIST-COLLECTOR))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (COND
      ((LOOK-AHEAD P :LPAR)
       (CALL-RULE P #'PART-DECL-COLLECTOR DEPTH CURRENT-METHOD)
       (COND
        ((LOOK-AHEAD P :LPAR)
         (CALL-RULE P #'PART-DECL-LIST-COLLECTOR DEPTH CURRENT-METHOD))))
      (T))))
 (DEFMETHOD PART-DECL-COLLECTOR ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'PART-DECL-COLLECTOR))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'PART/NEW DEPTH CURRENT-METHOD)
     (MUST-SEE P :LPAR)
     (CALL-RULE P #'NAME-COLLECTOR DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'RM-QUOTES DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'PART/SET-NAME DEPTH CURRENT-METHOD)
     (CALL-RULE P #'KIND-COLLECTOR DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'RM-QUOTES DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'PART/SET-KIND DEPTH CURRENT-METHOD)
     (CALL-RULE P #'INPUTS-COLLECTOR DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'PART/SET-INPUTS-FROM-LIST DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'LIST/POP DEPTH CURRENT-METHOD)
     (CALL-RULE P #'OUTPUTS-COLLECTOR DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'PART/SET-OUTPUTS-FROM-LIST DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'LIST/POP DEPTH CURRENT-METHOD)
     (CALL-RULE P #'REACT-COLLECTOR DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'RM-QUOTES DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'PART/SET-REACT DEPTH CURRENT-METHOD)
     (CALL-RULE P #'FIRST-TIME-COLLECTOR DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'RM-QUOTES DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'PART/SET-FIRST-TIME DEPTH CURRENT-METHOD)
     (MUST-SEE P :RPAR)
     (CALL-EXTERNAL P #'TABLE/ADD-PART DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'PART/CLOSE-POP DEPTH CURRENT-METHOD)))
 (DEFMETHOD NAME-COLLECTOR ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'NAME-COLLECTOR))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)))
 (DEFMETHOD META-COLLECTOR ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'META-COLLECTOR))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)))
 (DEFMETHOD KIND-COLLECTOR ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'KIND-COLLECTOR))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)))
 (DEFMETHOD REACT-COLLECTOR ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'REACT-COLLECTOR))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)))
 (DEFMETHOD FIRST-TIME-COLLECTOR ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'FIRST-TIME-COLLECTOR))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)))
 (DEFMETHOD WIRING-COLLECTOR ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'WIRING-COLLECTOR))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :LPAR)
     (CALL-RULE P #'WIRE-LIST-COLLECTOR DEPTH CURRENT-METHOD)
     (MUST-SEE P :RPAR)))
 (DEFMETHOD WIRE-LIST-COLLECTOR ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'WIRE-LIST-COLLECTOR))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (CALL-RULE P #'WIRE-COLLECTOR DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'TABLE/ADD-WIRE DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'WIRE/POP DEPTH CURRENT-METHOD)
     (COND
      ((LOOK-AHEAD P :LPAR)
       (CALL-RULE P #'WIRE-LIST-COLLECTOR DEPTH CURRENT-METHOD)))))
 (DEFMETHOD WIRE-COLLECTOR ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'WIRE-COLLECTOR))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :LPAR)
     (CALL-EXTERNAL P #'WIRE/NEW DEPTH CURRENT-METHOD)
     (MUST-SEE P :INTEGER)
     (CALL-EXTERNAL P #'WIRE/SET-INDEX DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'SOURCES-LIST/NEW DEPTH CURRENT-METHOD)
     (CALL-RULE P #'WIRE-SOURCES-COLLECTOR DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'WIRE/SET-SOURCES-LIST DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'SOURCES-LIST/CLOSE-POP DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'SINKS-LIST/NEW DEPTH CURRENT-METHOD)
     (CALL-RULE P #'WIRE-SINKS-COLLECTOR DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'WIRE/SET-SINKS-LIST DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'SINKS-LIST/CLOSE-POP DEPTH CURRENT-METHOD)
     (MUST-SEE P :RPAR)
     (CALL-EXTERNAL P #'TABLE/ADD-WIRE DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'WIRE/CLOSE DEPTH CURRENT-METHOD)))
 (DEFMETHOD WIRE-SOURCES-COLLECTOR ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'WIRE-SOURCES-COLLECTOR))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'PART-PIN-PAIR-LIST/NEW DEPTH CURRENT-METHOD)
     (MUST-SEE P :LPAR)
     (CALL-RULE P #'MANY-PART-PIN-PAIRS-COLLECTOR DEPTH CURRENT-METHOD)
     (MUST-SEE P :RPAR)
     (CALL-EXTERNAL P #'SOURCES-LIST/BECOMES-PART-PIN-PAIR-LIST DEPTH
                    CURRENT-METHOD)
     (CALL-EXTERNAL P #'PART-PIN-PAIR-LIST/CLOSE-POP DEPTH CURRENT-METHOD)))
 (DEFMETHOD MANY-PART-PIN-PAIRS-COLLECTOR ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'MANY-PART-PIN-PAIRS-COLLECTOR))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (COND
      ((LOOK-AHEAD P :LPAR)
       (CALL-EXTERNAL P #'PART-PIN-PAIR/NEW DEPTH CURRENT-METHOD)
       (CALL-RULE P #'PART-PIN-PAIR-COLLECTOR DEPTH CURRENT-METHOD)
       (CALL-EXTERNAL P #'PART-PIN-PAIR-LIST/ADD-PAIR DEPTH CURRENT-METHOD)
       (CALL-EXTERNAL P #'PART-PIN-PAIR/CLOSE-POP DEPTH CURRENT-METHOD)
       (CALL-RULE P #'MANY-PART-PIN-PAIRS-COLLECTOR DEPTH CURRENT-METHOD))
      (T))))
 (DEFMETHOD PART-PIN-PAIR-COLLECTOR ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'PART-PIN-PAIR-COLLECTOR))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :LPAR)
     (CALL-RULE P #'PART-COLLECTOR DEPTH CURRENT-METHOD)
     (CALL-RULE P #'PIN-COLLECTOR DEPTH CURRENT-METHOD)
     (MUST-SEE P :RPAR)))
 (DEFMETHOD PART-COLLECTOR ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'PART-COLLECTOR))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)
     (CALL-EXTERNAL P #'RM-QUOTES DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'PART-PIN-PAIR/ADD-FIRST-STRING DEPTH CURRENT-METHOD)))
 (DEFMETHOD PIN-COLLECTOR ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'PIN-COLLECTOR))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (MUST-SEE P :STRING)
     (CALL-EXTERNAL P #'RM-QUOTES DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'PART-PIN-PAIR/ADD-SECOND-STRING DEPTH CURRENT-METHOD)))
 (DEFMETHOD WIRE-SINKS-COLLECTOR ((P PARSER) &OPTIONAL (DEPTH 0))
   (LET ((CURRENT-METHOD 'WIRE-SINKS-COLLECTOR))
     (IN-RULE P DEPTH CURRENT-METHOD)
     (CALL-EXTERNAL P #'PART-PIN-PAIR-LIST/NEW DEPTH CURRENT-METHOD)
     (MUST-SEE P :LPAR)
     (CALL-RULE P #'MANY-PART-PIN-PAIRS-COLLECTOR DEPTH CURRENT-METHOD)
     (MUST-SEE P :RPAR)
     (CALL-EXTERNAL P #'SINKS-LIST/BECOMES-PART-PIN-PAIR-LIST DEPTH
                    CURRENT-METHOD)
     (CALL-EXTERNAL P #'PART-PIN-PAIR-LIST/CLOSE-POP DEPTH CURRENT-METHOD))))
