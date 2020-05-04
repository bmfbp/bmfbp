= array
  '[' objects ']'

= object
  [ ?'{'  '{' @objects '}'
  | ?'[' @array
  | * @atom

= nameValuePair
  @atom
  ':'
  @object





- is-atom
  [ ?STRING ^ok
  | ?INTEGER ^ok
  | &is-null ^ok
  | &is-boolean ^ok
  | &is-array ^ok
  | &is-object ^ok
  | * ^fail
  ]

- is-boolean
  [ &SYMBOL/true ^ok
  | &SYMBOL/false ^ok
  | * ^fail
  ]

- is-null
  [ SYMBOL/null ^ok
  | * ^fail
  ]

- is-number
  [ &is-integer ^ok
  | &is-exponential ^ok
  | &is-float ^ok
  | * ^fail
  ]