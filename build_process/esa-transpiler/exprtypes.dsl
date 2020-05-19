expression = { ekind object }
ekind = 'true' | 'false' | 'object'
object = { name parameterList field }
name = :string
field =| empty | object
parameterList =| empty | nameList
nameList = :map name
empty = :null
