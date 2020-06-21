esaprogram = { typeDecls situations classes whenDeclarations  }

typeDecls = :map typeDecl
situations = :map situationDefinition
classes = :map esaclass
whenDeclarations = :map whenDeclaration

typeDecl = { name typeName }
situationDefinition =| name
esaclass = { name fieldMap methodsTable }

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

% a synonym for "situation" might be "phase"
% in this design, it is important that certain actions happen in a certain order, e.g. in classical CS: define, load, run,
% e.g. in ESA, the (architectually) important phases are: build, load, intialize, run (where build is chopped up into two phases: very important (build) and less-architecturally-important (build-aux)
% a synonym for "when" would, then, be "in phase xxx"
% the word "phase" came to me much later and I, originally, used the word "situation" - also, I was looking for words that weren't already overloaded in meaning

% declarations are important during phase 1
% during phase 2, we pull up (lookup) classes and methods that were collected during phase 1 and embellish them with more meaning

% the job of phase 1 is to collect things into fields of the datatype "esaprogram"
% the job of phase 2 is to associate methods (external methods) and scripts (internal methods) with their corresponding classes, from the when declarations
% the job of phase 3 is to collect code bodies for script methods (internal methods) - the bodies are lists of sequential statements
% the job of phase 4 is to emit code - classes with fields and methods

whenDeclaration = { situationReferenceList esaKind methodDeclarationsAndScriptDeclarations }
situationReferenceList = :map situationReferenceName
situationReferenceName =| name

methodDeclarationsAndScriptDeclarations = :map declarationMethodOrScript
declarationMethodOrScript =| methodDeclaration | scriptDeclaration

% declare external methods and forward references to scripts
methodDeclaration = { esaKind name formalList returnType }

% declare (forward reference) internal scripts
scriptDeclaration = { esaKind name formalList returnType implementation }

returnType = { returnKind name }
returnKind = 'map' | 'simple' | 'void'
formalList = :map name

% semantic ckecker should check that all declared scripts are defined later on...
% and that all script declarations match preceding script definitions


esaKind =| name
typeName =| name

expression = { ekind object }
ekind = 'true' | 'false' | 'object' | 'calledObject'
object = { name fieldMap }
fieldMap = :map field
field = { name fkind actualParameterList } 
fkind = 'map' | 'simple'
actualParameterList = :map expression
name = :string

methodsTable = :map declarationMethodOrScript

%
% pass2 data structures
%
externalMethod = { name formalList returnType }
internalMethod = { name formalList returnType implementation }
implementation = :map statement

% pass3 data structures
statement =| letStatement | mapStatement | exitMapStatement | setStatement | createStatement | ifStatement | loopStatement | exitWhenStatement | callInternalStatement | callExternalStatement | returnTrueStatement | returnFalseStatement | returnValueStatement

letStatement = { varName expression implementation }
mapStatement = { varName expression implementation }
exitMapStatement = { filler } 
setStatement = { lval expression }
createStatement = { varName indirectionKind name implementation }
ifStatement = { expression thenPart elsePart }
loopStatement = { implementation }
exitWhenStatement = { expression }
returnTrueStatement = { methodName }
returnFalseStatement = { methodName }
returnValueStatement = { methodName name }
callInternalStatement = { functionReference } 
callExternalStatement = { functionReference }

lval =| expression
varName =| name
functionReference =| expression
thenPart =| implementation
elsePart =| implementation

indirectionKind = 'indirect' | 'direct'

% deficiency in stack-dsl parser - expects at least one field (we really want 0 fields here)
methodName =| name
filler =| name
