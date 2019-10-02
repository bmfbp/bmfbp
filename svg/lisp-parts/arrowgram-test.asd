;;; (ql:quickload :arrowgram-test) ONCE for every installation
(defsystem arrowgram-test
  :defsystem-depends-on (prove-asdf)
  :depends-on (prove
	       arrowgram/lwpasses)
  :pathname "t/"
  :components ((:test-file "basic"))
  :perform (asdf:test-op (op c)
	      (uiop:symbol-call :prove-asdf 'run-test-system c)))
	       




