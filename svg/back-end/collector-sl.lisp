(in-package :arrowgrams/compiler/back-end)

(defparameter *collector-rules*
"
= <ir> 
                          schematic/open
  :lpar
    <kind>                schematic/set-kind-from-string
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

(eval (sl:parse *collector-rules* "-COLLECTOR"))
