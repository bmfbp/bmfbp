classTable = :map namedClass
namedClass = { name methodsList }
methodsList = :map method
method = { name implmentation }
implementation = :map statement
statement =| letStatement | mapStatement | exitMapStatement | setStatement | createStatement | ifStatement | loopStatement | exitWhenStatement | returnStatement | callInternalStatement | callExternalStatement

% expression defined in exprtypes.dsl
