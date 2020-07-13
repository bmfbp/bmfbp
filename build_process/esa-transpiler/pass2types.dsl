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

% expression defined in exprtypes.dsl

