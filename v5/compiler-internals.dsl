Part CompilerInternals
[prolog-output-filename svg-filename]
[metadata json lisp error]
[
  front-end [svg-filename] [output-stream-string error]
  Compiler-Test-Bed [reset finished-pipeline prolog-output-filename factbase-string-stream  retract-fact request-fb add-fact done-step] [ step fb error ]
  passes [ step fb ] [finished-pipeline error basename retract-fact request-fb add-fact done-step ]
  file-namer [basename] [json-filename generic-filename lisp-filename error]
  back-end [ir json-filename generic-filename lisp-filename] [metadata json lisp error]
]

self.prolog-output-filename -> Compiler-test-bed. prolog-output-filename
self.svg-filename -> front-end.svg-filename

front-end.output-stream-string -> Compiler-Test-Bed.prolog-output-filename
front-end.error -> self.error

Compiler-Test-Bed.step -> passes.step
Compiler-Test-Bed.fb -> passes.fb
Compiler-Test-Bed.error -> self.error

passes.finished-pipeline -> Compiler-Test-Bed.finished-pipeline
passes.error -> self.error
passes.basename -> file-name.basename
passes.retract-fact -> Compiler-Test-Bed.retract-fact
passes.request-fb -> Compiler-Test-Bed.request-fb
passes.add-fact -> Compiler-Test-Bed.add-fact
passes.done-step -> Compiler-Test-Bed.done-step

file-namer.json-filename -> back-end.json-filename
file-namer.generic-filename -> back-end.generic-filename
file-namer.lisp-filename -> back-end.lisp-filename

back-end.metadata -> self.metadata
back-end.json -> self.json
back-end.lisp -> self.lisp
back-end.error -> self.error


