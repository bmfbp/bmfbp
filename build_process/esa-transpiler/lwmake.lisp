(ql:quickload :stack-dsl/use)
(stack-dsl:transpile-stack 
     (asdf:system-relative-pathname :arrowgrams "build_process/esa-transpiler/exprtypes.dsl")
     "CL-USER"
     (asdf:system-relative-pathname :arrowgrams "build_process/esa-transpiler/exprtypes.lisp")
     (asdf:system-relative-pathname :arrowgrams "build_process/esa-transpiler/exprtypes.json")
     "ARROWGRAMS/ESA-TRANSPILER"
     "CL-USER"
     (asdf:system-relative-pathname :arrowgrams "build_process/esa-transpiler/mechanisms.lisp")
     )
  (ql:quickload :parsing-assembler/use)
  (pasm:pasm-to-file 
     "ARROWGRAMS/ESA-TRANSPILER"
     (asdf:system-relative-pathname :arrowgrams "build_process/esa-transpiler/dsl.pasm")
     (asdf:system-relative-pathname :arrowgrams "build_process/esa-transpiler/dsl.lisp"))
  (ql:quickload :arrowgrams/esa-transpiler)

  (load (arrowgrams/esa-transpiler::path "package.lisp"))
  (load (arrowgrams/esa-transpiler::path "classes.lisp"))
  (load (arrowgrams/esa-transpiler::path "dsl.lisp"))
  (load (arrowgrams/esa-transpiler::path "exprtypes.lisp"))
  (load (arrowgrams/esa-transpiler::path "mechanisms.lisp"))
  (load (arrowgrams/esa-transpiler::path "mech-tester.lisp"))
  (load (arrowgrams/esa-transpiler::path "esa-transpile.lisp"))
  (load (arrowgrams/esa-transpiler::path "trace-rules.lisp"))
  (load (arrowgrams/esa-transpiler::path "trace-mechs.lisp"))
  (ql:quickload :arrowgrams/esa-transpiler/tester)
  (stack-dsl:initialize-types (arrowgrams/esa-transpiler:path "exprtypes.json"))
  (trace-mechs)
  (trace-rules)
  (arrowgrams/esa-transpiler::transpile-esa-to-string
   (arrowgrams/esa-transpiler::path "test.esa")
   :tracing-accept t)
