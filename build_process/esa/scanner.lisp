(in-package :rephrase)

(defun rephrase (filename)
  (let ((net (@defnetwork scanner
                 (:code tokenize (:start :pull) (:out :error))
		 (:code comments (:token) (:pull :out :error))
		 (:code spaces (:token) (:pull :out :error))
	         (:code strings (:token) (:pull :out :error))
		 (:code symbols (:token) (:pull :out :error))
		 (:code integers (:token) (:pull :out :error))
		 
		 (:code dumper (:start :in) (:pull :out :error))
		 
		 (:schem scanner (:start :pull) (:out :error)
			 (tokenize comments strings symbols spaces integers ;; parts
				   dumper)
			 ;; wiring

			 "
			 self.start -> tokenize.start,dumper.start

			 self.pull,comments.pull,spaces.pull,strings.pull,symbols.pull,integers.pull, dumper.pull -> tokenize.pull

			 tokenize.out -> comments.token
                         comments.out -> strings.token
			 strings.out -> spaces.token
			 spaces.out -> symbols.token
			 symbols.out -> integers.token
			 integers.out -> dumper.in
                         dumper.out -> self.out

			 tokenize.error,comments.error,strings.error,symbols.error,spaces.error,integers.error,  dumper.error -> self.error
			 "
			 ))))

    (let ((start-pin (@get-input-pin net :start)))
      (@enable-logging)
      (@with-dispatch 
        (@inject net start-pin filename)))))
  
(defun cl-user::rtest ()
  (rephrase:rephrase (asdf:system-relative-pathname :rephrase "testfile")))