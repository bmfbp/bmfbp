(in-package :cl-user)

(uiop:run-program "~/quicklisp/local-projects/rm.bash")
(proclaim '(optimize (debug 3) (safety 3) (speed 0)))

(defun l1 ()
  (ql:quickload :stack-dsl)
  (ql:quickload :stack-dsl/use)
  (stack-dsl:transpile-stack 
   (asdf:system-relative-pathname :arrowgrams "build_process/esa-transpiler/exprtypes.dsl")
   "CL-USER"
   (asdf:system-relative-pathname :arrowgrams "build_process/esa-transpiler/exprtypes.lisp")
   (asdf:system-relative-pathname :arrowgrams "build_process/esa-transpiler/exprtypes.json")
   "ARROWGRAMS/ESA-TRANSPILER"
   "CL-USER"
   (asdf:system-relative-pathname :arrowgrams "build_process/esa-transpiler/mechanisms.lisp")
   ))


(defun l2 ()
  (ql:quickload :parsing-assembler/use)
  (pasm:pasm-to-file 
   "ARROWGRAMS/ESA-TRANSPILER"
   (asdf:system-relative-pathname :arrowgrams "build_process/esa-transpiler/dsl0.pasm")
   (asdf:system-relative-pathname :arrowgrams "build_process/esa-transpiler/dsl0.lisp")
   "-PASS0")
  (pasm:pasm-to-file 
   "ARROWGRAMS/ESA-TRANSPILER"
   (asdf:system-relative-pathname :arrowgrams "build_process/esa-transpiler/dsl1.pasm")
   (asdf:system-relative-pathname :arrowgrams "build_process/esa-transpiler/dsl1.lisp")
   "-PASS1")
  (pasm:pasm-to-file 
   "ARROWGRAMS/ESA-TRANSPILER"
   (asdf:system-relative-pathname :arrowgrams "build_process/esa-transpiler/dsl2.pasm")
   (asdf:system-relative-pathname :arrowgrams "build_process/esa-transpiler/dsl2.lisp")
   "-PASS2"))

(defun l3 ()
  (ql:quickload :arrowgrams/esa-transpiler)
  
  (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
  (load (arrowgrams/esa-transpiler::path "package.lisp"))
  (load (arrowgrams/esa-transpiler::path "classes.lisp"))
  (load (arrowgrams/esa-transpiler::path "dsl0.lisp"))
  (load (arrowgrams/esa-transpiler::path "dsl1.lisp"))
  (load (arrowgrams/esa-transpiler::path "dsl2.lisp"))
  (load (arrowgrams/esa-transpiler::path "exprtypes.lisp"))
  (load (arrowgrams/esa-transpiler::path "manual-types.lisp"))
  (load (arrowgrams/esa-transpiler::path "mechanisms.lisp"))
  (load (arrowgrams/esa-transpiler::path "manual-mechanisms.lisp"))
  (load (arrowgrams/esa-transpiler::path "mech-tester.lisp"))
  (load (arrowgrams/esa-transpiler::path "esa-transpile.lisp"))
  (load (arrowgrams/esa-transpiler::path "trace-rules.lisp"))
  (load (arrowgrams/esa-transpiler::path "trace-mechs.lisp"))
)
  
(defun l4 ()
  (ql:quickload :arrowgrams/esa-transpiler/tester))

(defun run ()
  (stack-dsl:initialize-types (arrowgrams/esa-transpiler:path "exprtypes.json"))
  (arrowgrams/esa-transpiler::transpile-esa-to-string 
   (arrowgrams/esa-transpiler:path "esa-test.dsl")
   :tracing-accept nil))
