esaprogram = { typeDecls situations classes whens scripts }

typeDecls = :map typeDecl
situations = :map situation
classes = :map esaclass
whens = :map whenDeclaration
scripts = :map scriptImplementation

typeDecl = { name typeName }
situation = { name situationName }
situationName =| name
esaclass = { name fieldMap }

% a "declaration" declares the existence of something, but gives no definition
%  for the thing, for example, a signature is a declaration
% a "definition" defines the operation of something by giving its implementation
%  in this DSL, only scripts can have definitions, methods are "outside of the scope"
%  of the DSL (e.g. they are always external), hence, can only be declared

whenDeclaration = { situationName esaKind methodDeclarationsAndScriptDeclarations }

methodDeclarationsAndScriptDeclarations = :map declarationMethodOrScript
declarationMethodOrScript =| methodDeclaration | scriptDeclaration

% declare external methods and forward references to scripts
methodDeclaration = { name formalList }

% declare (forward reference) internal scripts
scriptDeclaration = { name formalList }

% semantic ckecker should check that all declared scripts are defined later on...
% and that all script declarations match preceding script definitions

% define the "code" for an internal script
scriptImplementation = { name esaKind formalList scriptStatements }

formalList = :map name
scriptStatements = :map scriptStatement

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

thenStatements =| scriptStatements
elseStatements =| scriptStatements

esaKind =| name
letVarName =| name
mapVarName =| name
createVarName =| name
setVarName =| name
internalScriptName =| name
externalMethodName =| name
typeName =| name




expression = { ekind object }
ekind = 'true' | 'false' | 'object'
object = { name fieldMap }
fieldMap = :map field
field = { name fkind actualParameterList }
fkind = 'map' | 'simple'
actualParameterList = :map expression
name = :string