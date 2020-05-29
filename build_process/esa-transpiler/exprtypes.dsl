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

% a "declaration" declares the existence of something, but gives no definition
%  for the thing, for example, a signature is a declaration
% a "definition" defines the operation of something by giving its implementation
%  in this DSL, only scripts can have definitions, methods are "outside of the scope"
%  of the DSL (e.g. they are always external), hence, can only be declared

scriptOrWhen =| scriptDefinition | whenDeclaration
whenDeclaration = { situationName esaKind methodsAndScriptDeclarations }

% declare external methods and forward references to scripts
methodDeclaration = { name formalParameterList }

% declare (forward reference) internal scripts
scriptDeclaration = { name formalParameterList }

% semantic ckecker should check that all declared scripts are defined later on...
% and that all script declarations match preceding script definitions

% define the "code" for an internal script
scriptImplementation = { name esaKind formalParameterList scriptStatements }

situationName = name
formalParameterList = :map name
scriptStatements= :map scriptStatement

scriptStatement =| letStatement | mapStatement | exitMapStatement | setStatement | createStatement | ifStatement | loopStatement | exitWhenStatement | returnStatement | callScriptStatement | callExternalStatement

letStatement = { letVarName expression scriptStatements } 
mapStatement = { mapVarName expression scriptStatements }
createStatement = { createVarName expression scriptStatements }
setStatement = { setVarName expression scriptStatements }
exitMapStatement = { expression }
ifStatement = { expression thenStatements elseStatements }
loopStatement = { scriptStatements }
exitWhenStatement = { expression }
returnStatement = { expression }
callScriptStatement = { internalScriptName }
callExternalStatement = { externalMethodName }

thenStatements = scriptStatements
elseStatements = scriptStatements

esaKind = name
letVarName = name
mapVarName = name
createVarName = name
setVarName = name
internalScriptName = name
externalMethodName = name




expression = { ekind object }
ekind = 'true' | 'false' | 'object'
object = { name fieldMap }
fieldMap = :map field
field = { name parameterList }
parameterList = :map expression
name = :string

