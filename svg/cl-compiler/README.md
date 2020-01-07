usage:

CL-USER> (ql:quickload :arrowgrams/parser)
CL-USER> (arrowgrams/parser::create)
CL-USER> (ql:quickload :arrowgrams/compiler)
CL-USER> (arrowgrams/compiler::compiler)
... wait about one minute during add-kinds for the result ...

this makes it through add-kinds, using gprolog->peg->lisp->hprolog+lisp
it create 10 x :KIND facts (albeit slowly)