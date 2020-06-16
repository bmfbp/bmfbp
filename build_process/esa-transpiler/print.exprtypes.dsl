esaprogram = { typeDecls situations classes whenDeclarations  }

typeDecls = :map typeDecl
situations = :map situationDefinition
classes = :map esaclass
whenDeclarations = :map whenDeclaration

typeDecl = { name typeName }
situationDefinition =| name
esaclass = { name fieldMap methodsTable }


whenDeclaration = { situationReferenceList esaKind methodDeclarationsAndScriptDeclarations }
situationReferenceList = :map situationReferenceName
situationReferenceName =| name

methodDeclarationsAndScriptDeclarations = :map declarationMethodOrScript
declarationMethodOrScript =| methodDeclaration | scriptDeclaration

% declare external methods and forward references to scripts
methodDeclaration = { name formalList returnType }

% declare (forward reference) internal scripts
scriptDeclaration = { name formalList returnType implementation }

returnType = { returnKind name }
returnKind = 'map' | 'simple' | 'void'
formalList = :map name

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
setStatement = { varName expression }
createStatement = { varName indirectionKind name implementation }
ifStatement = { expression thenPart elsePart }
loopStatement = { implementation }
exitWhenStatement = { expression }
returnTrueStatement = { filler }
returnFalseStatement = { filler }
returnValueStatement = { name }
callInternalStatement = { functionReference } 
callExternalStatement = { functionReference }

varName =| name
functionReference =| expression
thenPart =| implementation
elsePart =| implementation

indirectionKind = 'indirect' | 'direct'

% deficiency in stack-dsl parser - expects at least one field (we really want 0 fields here)
filler =| name



---------------------

emiting

when asStringing esaprogram
  script asString
  method asStringClassHeader
  method asStringClassMiddle
  method asStringClassTrailer
end when

script esaprogram asString
  map c = self.classes in
    c.asString
  end map
end script

when asStringing esaclass
end when

script esaclass asString
  % { name fieldMap methodsTable }
  self.asStringClassHeader
  map f = self.fieldMap in
    f.asString(self)
  end map
  self.asStringClassMiddle
  map m = self.methodsTable in
    m.asString(self)
  end map
  self.asStringClassTrailer
end when

script methodDeclaration asString
end script

script scriptDeclaration asString
end script

script letStatement asString
end script

script mapStatement asString
end script

script name asString
  self.asString
end script

script varName asString
  self.asString
end script

when printing returnTrueStatement
  method asString
end when

when printing returnFalseStatement
  method asString
end when

