Part BackEnd
inputs: [ir json-filename generic-filename lisp-filename]
outputs: [json lisp metadata error]
parts: [ 
      synchronizer inputs: [ir json-filename generic-filename lisp-filename] outputs: [ir json-filename generic-filename lisp-filename]
       back-end-parser  inputs: [ir json-filename generic-filename lisp-filename] :outputs [json lisp metadata error]
]

self.ir -> synchronizer.ir
self.json-filename -> synchronizer.json-filename
self.generic-filename -> synchronizer.generic-filename
self.lisp-filename -> synchronizer.lisp-filename

synchronizer.ir -> back-end-parser.ir
synchronizer.json-filename -> back-end-parser.json-filename
synchronizer.generic-filename-> back-end-parser.generic-filename
synchronizer.lisp-filename -> back-end-parser.lisp-filename

back-end-parser.json -> self.json
back-end-parser.lisp -> self.lisp
back-end-parser.metadata -> self.metadat
back-end-parser.error -> self.error


