expression = { ekind object }
ekind = 'true' | 'false' | 'object'
name = :string
parameterList =| empty | nameList
nameList = :map name
empty = :null

object = { name fieldMap }
fieldMap = :map field
field = { fieldName parameterList }
fieldName = :string


