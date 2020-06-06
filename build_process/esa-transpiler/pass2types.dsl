pass2 = { classTable }
classTable = :map namedClass
namedClass = { name methodsList }
methodsList = :map method
method = { name implmentation }
implementation = :map statement
statement =| letStatement | mapStatement | exitMapStatement | setStatement | createStatement | ifStatement | loopStatement | exitWhenStatement | returnStatement | callInternalStatement | callExternalStatement

letStatement = { varName expression implementation }
mapStatement = { varName expression implementation }
exitMapStatement = { } 
setStatement = { varName expression implementation }
createStatement = { varName implementation }
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

% expression defined in exprtypes.dsl

