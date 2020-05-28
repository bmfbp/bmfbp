esaprogram = { typeDecls situations classes scriptsAndWhens }

typeDecls = :map typeDecl
situation = :map situation
classes = :map esaclass
scriptsOrWhens = :map scriptOrWhen

typeDecl = { name typeName }
typeName = name
situation = { name situationName }
situationName = name
esaclass = { name fieldMap }

scriptOrWhen =| scriptDefinition | whenDefinition
whenDefinition = { name esaKind methodsAndScriptDefinitions }
scriptDefinition = { esaKind name scriptSignature esaCode }




methodsAndScriptDefinitions = :map methodOrScriptDeclaration

methodOrScript =| methodDeclaration | scriptDefinition

methodDeclaration =


scriptSignature =
esaCode = 

esaKind = name




expression = { ekind object }
ekind = 'true' | 'false' | 'object'
object = { name fieldMap }
fieldMap = :map field
field = { name parameterList }
parameterList = :map expression
name = :string

