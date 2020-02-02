usage:

CL-USER> (ql:quickload :arrowgrams/parser)
CL-USER> (arrowgrams/parser::create)
CL-USER> (ql:quickload :arrowgrams/compiler)
CL-USER> (arrowgrams/compiler::compiler)
... wait about one minute during add-kinds for the result ...

this create <top-level>.ir, e.g. BUILD_PROCESS.ir

(../xform is an aborted attempt at a code emitter)
(the final code emitter is in ../back-end, see README.md there)
