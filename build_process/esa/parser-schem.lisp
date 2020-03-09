(in-package :arrowgrams/build)

(defun run-rephrase-parser (output-filename input-filename)
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
			 "
			 self.start -> tokenize.start

			 self.pull,comments.pull,spaces.pull,strings.pull,symbols.pull,integers.pull,raw-text.pull -> tokenize.pull

			 tokenize.out -> raw-text.token
                         raw-text.out -> comments.token
                         comments.out -> strings.token
			 strings.out -> spaces.token
			 spaces.out -> symbols.token
			 symbols.out -> integers.token
			 integers.out -> self.out

			 tokenize.error,comments.error,strings.error,symbols.error,spaces.error,integers.error -> self.error
			 "
                         )

                 (:code file-writer (:filename :write) (:error))
                 (:code rp-parser (:start :token) (:pull :out :error))

                 (:schem parse (:start :output-filename) (:out :error)
                    (rp-parser scanner file-writer)
                    "
                    self.start -> rp-parser.start, scanner.start

                    rp-parser.pull -> scanner.pull
                    scanner.out -> rp-parser.token

                    self.output-filename -> file-writer.filename
                    rp-parser.out -> file-writer.write

                    scanner.error, rp-parser.error,file-writer.error -> self.error
                    "
                    ))))

    (let ((start-pin (@get-input-pin net :start))
          (output-filename-pin (@get-input-pin net :output-filename)))
      (@enable-logging)
      (@with-dispatch 
        (@inject net output-filename-pin output-filename)
        (@inject net start-pin input-filename)))))

(defun run-esa-parser (filename)
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
			 "
			 self.start -> tokenize.start

			 self.pull,comments.pull,spaces.pull,strings.pull,symbols.pull,integers.pull,raw-text.pull -> tokenize.pull

			 tokenize.out -> raw-text.token
                         raw-text.out -> comments.token
                         comments.out -> strings.token
			 strings.out -> spaces.token
			 spaces.out -> symbols.token
			 symbols.out -> integers.token
			 integers.out -> self.out

			 tokenize.error,comments.error,strings.error,symbols.error,spaces.error,integers.error -> self.error
			 "
                         )

                 (:code esa-parser (:start :token) (:pull :out :error))

                 (:schem parse (:start) (:out :error)
                    (esa-parser scanner)
                    "
                    self.start -> esa-parser.start, scanner.start
                    esa-parser.out -> self.out

                    esa-parser.pull -> scanner.pull
                    scanner.out -> esa-parser.token

                    scanner.error, esa-parser.error -> self.error
                    "
                    ))))

    (let ((start-pin (@get-input-pin net :start)))
      (@enable-logging)
      (@with-dispatch 
        (@inject net start-pin filename)))))
  
(defun cl-user::etest1 ()
  (asdf::run-program "rm -rf ~/.cache/common-lisp")
  (ql:quickload :arrowgrams/esa)
  (arrowgrams/build::run-rephrase-parser (asdf:system-relative-pathname :arrowgrams "build_process/esa/esa-dsl.lisp")
                                 (asdf:system-relative-pathname :arrowgrams "build_process/esa/esa.rp")))
(defun cl-user::etest2 ()
  (asdf::run-program "rm -rf ~/.cache/common-lisp")
  (ql:quickload :arrowgrams/esa)
  (arrowgrams/build::run-esa-parser (asdf:system-relative-pathname :arrowgrams "build_process/esa/esa.dsl")))

(defun cl-user::etest()
  (cl-user::etest1)
  (cl-user::etest2))
