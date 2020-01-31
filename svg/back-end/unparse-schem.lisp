=def <schem> (schem)
  :string schem.name
  :string schem.kind
  <inputs> (schem.inputs)
  <outputs> (schem.outputs)
  :string react
  :string first-time
  <parts> (schem.parts schem.wiring)

=def <inputs> (list)
  ! :inputs
  ~foreach item in list {
    :string item
  }
  ! :end

=def <outputs> (list)
  ! :outputs
  ~foreach item in list {
    :string item
  }
  ! :end

=def <parts> (parts-table wiring-table)
  $foreach (name data) in parts-table {
    <part> (name data wiring-table)
  }

=def <part> (part-name data wiring-table)
  ! :inputs
  ~foreach (pin-name) in data.inputs {
    <input-pin> (pin-name part-name wiring-table)
  }
  ! :end
  ! :outputs
  ~foreach (pin-name) in data.inputs {
    <output-pin> (pin-name part-name wiring-table)
  }

=def <input-pin> (pin-name part-name wiring-table)
  :string pin-name
  let wire-number-list @loopkup-part-pin-in-sinks(wiring-table part-name pin-name)
  in
    ~foreach (wire-number) in wire-number-list {
      :integer wire-number
    }
  ! :end

=def <output-pin> (pin-name part-name wiring-table)
  :string pin-name
  let wire-number-list @loopkup-part-pin-in-sinks(wiring-table part-name pin-name)
  in
    ~foreach (wire-number) in wire-number-list {
      :integer wire-number
    }
  ! :end

