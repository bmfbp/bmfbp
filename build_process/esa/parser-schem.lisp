(in-package :arrowgrams/esa)

(defun create-esa-compiler (input-filename output-filename)
  (let ((net (@defnetwork parse
                 (:code tokenize (:start :pull) (:out :error))
		 (:code comments (:token) (:pull :out :error))
		 (:code raw-text (:token) (:pull :out :error))
		 (:code spaces (:token) (:pull :out :error))
	         (:code strings (:token) (:pull :out :error))
		 (:code symbols (:token) (:pull :out :error))
		 (:code integers (:token) (:pull :out :error))
		 
		 (:schem scanner (:start :pull) (:out :error)
			 (tokenize comments strings symbols spaces integers raw-text) ;; parts

			 ;; wiring (raw-text must be before comments for % chars)
			 #+ nil "
			 self.start -> tokenize.start

			 self.pull,comments.pull,spaces.pull,strings.pull,symbols.pull,integers.pull,raw-text.pull -> tokenize.pull

			 tokenize.out -> raw-text.token
                         raw-text.out -> comments.token
                         comments.out -> strings.token
			 strings.out -> spaces.token
			 spaces.out -> symbols.token
			 symbols.out -> integers.token
			 integers.out -> self.out

			 tokenize.error,comments.error,strings.error,symbols.error,spaces.error,integers.error,raw-text.error -> self.error
			 "
((((:SELF :START)) ((TOKENIZE :START)))
 (((:SELF :PULL) (COMMENTS :PULL) (SPACES :PULL) (STRINGS :PULL)
   (SYMBOLS :PULL) (INTEGERS :PULL) (RAW-TEXT :PULL))
  ((TOKENIZE :PULL)))
 (((TOKENIZE :OUT)) ((RAW-TEXT :TOKEN)))
 (((RAW-TEXT :OUT)) ((COMMENTS :TOKEN))) (((COMMENTS :OUT)) ((STRINGS :TOKEN)))
 (((STRINGS :OUT)) ((SPACES :TOKEN))) (((SPACES :OUT)) ((SYMBOLS :TOKEN)))
 (((SYMBOLS :OUT)) ((INTEGERS :TOKEN))) (((INTEGERS :OUT)) ((:SELF :OUT)))
 (((TOKENIZE :ERROR) (COMMENTS :ERROR) (STRINGS :ERROR) (SYMBOLS :ERROR)
   (SPACES :ERROR) (INTEGERS :ERROR) (RAW-TEXT :ERROR))
  ((:SELF :ERROR))))                         )

                 (:code file-writer (:filename :write) (:error))
                 (:code rp-parser (:start :token) (:pull :out :error))
                 (:code error-manager (:error) ())

                 (:schem parse (:start :output-filename) (:out :error)
                    (rp-parser scanner file-writer error-manager)
                    #+nil "
                    self.start -> rp-parser.start, scanner.start

                    rp-parser.pull -> scanner.pull
                    scanner.out -> rp-parser.token

                    self.output-filename -> file-writer.filename
                    rp-parser.out -> file-writer.write

                    scanner.error, rp-parser.error,file-writer.error -> error-manager.error
                    "
((((:SELF :START)) ((RP-PARSER :START) (SCANNER :START)))
 (((RP-PARSER :PULL)) ((SCANNER :PULL)))
 (((SCANNER :OUT)) ((RP-PARSER :TOKEN)))
 (((:SELF :OUTPUT-FILENAME)) ((FILE-WRITER :FILENAME)))
 (((RP-PARSER :OUT)) ((FILE-WRITER :WRITE)))
 (((SCANNER :ERROR) (RP-PARSER :ERROR) (FILE-WRITER :ERROR))
  ((ERROR-MANAGER :ERROR))))                    ))))

    (let ((start-pin (@get-input-pin net :start))
          (output-filename-pin (@get-input-pin net :output-filename)))
      (@enable-logging)
      (@with-dispatch 
        (@inject net output-filename-pin output-filename)
        (@inject net start-pin input-filename)))))

(defun run-esa-compiler (filename output-filename)
  (let ((net (@defnetwork parse
                 (:code tokenize (:start :pull) (:out :error))
		 (:code comments (:token) (:pull :out :error))
		 (:code raw-text (:token) (:pull :out :error))
		 (:code spaces (:token) (:pull :out :error))
	         (:code strings (:token) (:pull :out :error))
		 (:code symbols (:token) (:pull :out :error))
		 (:code integers (:token) (:pull :out :error))

		 
		 (:schem scanner (:start :pull) (:out :error)
			 (tokenize comments strings symbols spaces integers raw-text) ;; parts

			 ;; wiring (raw-text must be before comments for % chars)
			 #+nil "
			 self.start -> tokenize.start

			 self.pull,comments.pull,spaces.pull,strings.pull,symbols.pull,integers.pull,raw-text.pull -> tokenize.pull

			 tokenize.out -> raw-text.token
                         raw-text.out -> comments.token
                         comments.out -> strings.token
			 strings.out -> spaces.token
			 spaces.out -> symbols.token
			 symbols.out -> integers.token
			 integers.out -> self.out

			 tokenize.error,comments.error,raw-text.error,strings.error,symbols.error,spaces.error,integers.error -> self.error
			 "
((((:SELF :START)) ((TOKENIZE :START)))
 (((:SELF :PULL) (COMMENTS :PULL) (SPACES :PULL) (STRINGS :PULL)
   (SYMBOLS :PULL) (INTEGERS :PULL) (RAW-TEXT :PULL))
  ((TOKENIZE :PULL)))
 (((TOKENIZE :OUT)) ((RAW-TEXT :TOKEN)))
 (((RAW-TEXT :OUT)) ((COMMENTS :TOKEN))) (((COMMENTS :OUT)) ((STRINGS :TOKEN)))
 (((STRINGS :OUT)) ((SPACES :TOKEN))) (((SPACES :OUT)) ((SYMBOLS :TOKEN)))
 (((SYMBOLS :OUT)) ((INTEGERS :TOKEN))) (((INTEGERS :OUT)) ((:SELF :OUT)))
 (((TOKENIZE :ERROR) (COMMENTS :ERROR) (RAW-TEXT :ERROR) (STRINGS :ERROR)
   (SYMBOLS :ERROR) (SPACES :ERROR) (INTEGERS :ERROR))
  ((:SELF :ERROR))))			 
                         )

                 (:code esa-parser (:start :token) (:pull :out :error))
                 (:code esa-file-writer (:filename :write) (:error))
                 (:code esa-error-manager (:error) ())

                 (:schem parse (:start :esa-output-filename) (:out :error)
                    (esa-parser scanner esa-file-writer esa-error-manager)
                    #+nil "
                    self.start -> esa-parser.start, scanner.start
                    self.esa-output-filename -> esa-file-writer.filename
                    esa-parser.out -> esa-file-writer.write

                    esa-parser.pull -> scanner.pull
                    scanner.out -> esa-parser.token

                    scanner.error, esa-parser.error -> esa-error-manager.error
                    "
((((:SELF :START)) ((ESA-PARSER :START) (SCANNER :START)))
 (((:SELF :ESA-OUTPUT-FILENAME)) ((ESA-FILE-WRITER :FILENAME)))
 (((ESA-PARSER :OUT)) ((ESA-FILE-WRITER :WRITE)))
 (((ESA-PARSER :PULL)) ((SCANNER :PULL)))
 (((SCANNER :OUT)) ((ESA-PARSER :TOKEN)))
 (((SCANNER :ERROR) (ESA-PARSER :ERROR)) ((ESA-ERROR-MANAGER :ERROR))))		    
                    ))))

    (let ((start-pin (@get-input-pin net :start))
          (output-filename-pin (@get-input-pin net :esa-output-filename)))
      (@enable-logging)
      (@with-dispatch 
        (@inject net output-filename-pin output-filename)
        (@inject net start-pin filename)))))

(defun make-esa-dsl ()
  (arrowgrams/esa::create-esa-compiler (asdf:system-relative-pathname :arrowgrams "build_process/esa/esa.rp")
					 (asdf:system-relative-pathname :arrowgrams "build_process/esa/esa-dsl.lisp")))

(defun make-esa ()
  (arrowgrams/esa::run-esa-compiler
   (asdf:system-relative-pathname :arrowgrams "build_process/esa/esa.dsl")
   (asdf:system-relative-pathname :arrowgrams "build_process/cl-run/esa.lisp")))
;(asdf:system-relative-pathname :arrowgrams "build_process/cl-bundle/esa.lisp")))


;;; sample
(defun make-sample ()
  (arrowgrams/esa::run-esa-compiler
   (asdf:system-relative-pathname :arrowgrams "build_process/esa/sample.dsl")
   (asdf:system-relative-pathname :arrowgrams "build_process/esa/sample.lisp")))

