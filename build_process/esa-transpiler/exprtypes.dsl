esaprogram = { typeDecls situations classes whenDeclarations scriptImplementations }

typeDecls = :map typeDecl
situations = :map situationDefinition
classes = :map esaclass
whenDeclarations = :map whenDeclaration
scriptImplementations = :map scriptImplementation

typeDecl = { name typeName }
situationDefinition =| name
esaclass = { name fieldMap  }

% a "declaration" declares the existence of something, but gives no definition
%  for the thing
% a "definition" defines the operation of something by giving its implementation
%  in this DSL, only scripts can have definitions, methods are "outside of the scope"
%  of the DSL (e.g. they are always external), hence, can only be declared

% in ESA, here are 3 kinds of definition and 1 kind of code implementation
% a "class" defines fields (only)
% a "when" declares methods and declares the scripts (both are like forward references) associated with a class
% a "script" *implements* a method based on simplistic ESA code rules, a "script" may refer to methods of the class
% things declared as "methods" are not implemented but are left to be implemented in the underlying base language
% (I lied - there are 2 kinds of implementation - "class" definitions define fields - these fields are a kind of "implementation" (they can be emitted))
% "whens" also declare when (a time during which) particular methods (and scripts) are valid - the "situation", in ESA, I have 4 main phases - building, loading, initializing and running, I split "building" into two pieces - "building" and "building-aux" to separate the Architecturally important stuff ("building") from the less-important (Architecturally) details ("building-aux")

% I deemed that I wanted to have script implementations "near" the definitions, so I allow intermingling of when declarations and script implementations

whenDeclaration = { situationReferenceList esaKind methodDeclarationsAndScriptDeclarations }
situationReferenceList = :map situationReferenceName
situationReferenceName =| name

methodDeclarationsAndScriptDeclarations = :map declarationMethodOrScript
declarationMethodOrScript =| methodDeclaration | scriptDeclaration

% declare external methods and forward references to scripts
methodDeclaration = { name formalList returnType }

% declare (forward reference) internal scripts
scriptDeclaration = { name formalList returnType }

returnType = { returnKind name }
returnKind = 'map' | 'simple' | 'void'
formalList = :map name

% semantic ckecker should check that all declared scripts are defined later on...
% and that all script declarations match preceding script definitions


esaKind =| name
typeName =| name

expression = { ekind object }
ekind = 'true' | 'false' | 'object'
object = { name fieldMap }
fieldMap = :map field
field = { name fkind actualParameterList }
fkind = 'map' | 'simple'
actualParameterList = :map expression
name = :string


%
% pass2 data structures
%
pass2 = { classTable }
classTable = :map namedClass
namedClass = { name methodsList }
methodsList = :map method
method = { name implmentation }
implementation = :map statement
statement =| letStatement | mapStatement | exitMapStatement | setStatement | createStatement | ifStatement | loopStatement | exitWhenStatement | returnStatement | callInternalStatement | callExternalStatement

letStatement = { varName expression implementation }
mapStatement = { varName mxpression implementation }
exitMapStatement = { } 
setStatement = { varName expression implementation }
createStatement = { varName maybeIndirectExpression implementation }
ifStatement { expression thenPart elsePart }
loopStatement = { implementation }
exitWhenStatement = { expression }
returnStatement = { expression }
callInternalStatement = { functionReference } 
callExternalStatementlet = { functionReference }

varName =| name
functionReference =| expression
thenPart =| implementation
elsePart =| implementation

maybeIndirectExpression = { indirectionKind expression }
indirectionKind = 'indirect' | 'direct'

