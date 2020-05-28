esaprogram = { typeDecls situations classes scriptsAndWhens }

typeDecls = :map typeDecl
situation = :map situation
classes = :map esaclass
scriptsAndWhens = :map scriptOrWhen

typeDecl = { name typeName }
typeName = name
situation = { name situationName }
situationName = name
esaclass = { name fieldMap }
scriptOrWhen =| script | when
when = { name esaKind methodsAndScripts }
methodsAndScripts = :map methodOrScript

methodOrScript =| methodDefinition | scriptDefinition

scriptDefinition = { esaKind name signature esaCode }

esaKind = name




expression = { ekind object }
ekind = 'true' | 'false' | 'object'
object = { name fieldMap }
fieldMap = :map field
field = { name parameterList }
parameterList = :map expression
name = :string

