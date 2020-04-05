(in-package :arrowgrams/make-esa-compiler)

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



