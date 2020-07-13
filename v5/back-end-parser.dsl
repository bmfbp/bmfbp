Part BackEnd

inputs: [ start generic-filename json-filename lisp-filename ]
outputs: [ json-out error ]
parts : [ 
      Scanner inputs: [ start request ] outputs: [out error]
      preparse inputs: [token] outputs: [out request error] 
      generic-emitter inputs: [in] outputs: [out error] 
      collector inputs: [in] outputs: [out error] 
      json1-emitter inputs: [in] outputs: [out error] 
      lisp-emitter inputs: [in] outputs: [out error] 
      emitter-pass2-generic inputs: [in] outputs: [out error] 
      json emitter inputs: [in] outputs: [out error] 
      generic-file-writer: [in] outputs: [out error] 
      json-file-writer inputs: [in] outputs: [out error] 
      lisp-file-writer inputs: [in] outputs: [out error] 
]

self.start -> Scanner.start

Scanner.out -> preparse.token

preparse.request -> Scanner.request
preparse.out -> generic-emitter.in, collector.in, json1-emitter.in, lisp-emitter.in

collector.out -> emiter-pass2-generic.in, json-emitter.in

json1-emitter.out -> json-file-writer.in, self.json-out
lisp-emitter.out -> lisp-file-writer.in
emitter-pass2-generic.out -> generic-file-writer.in

self.lisp-filename -> lisp-file-writer.lisp-filename
self.json-filename -> json-file-writer.in
self.generic-filename -> generic-file-write.generic-filename

