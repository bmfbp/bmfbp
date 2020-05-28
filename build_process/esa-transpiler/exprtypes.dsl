expression = { ekind object }
ekind = 'true' | 'false' | 'object'
object = { name fieldMap }
fieldMap = :map field
field = { name parameterList }
parameterList = :map name
name = :string

esaclass = { name }
