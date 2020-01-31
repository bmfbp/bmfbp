(cl:in-package :arrowgrams/compiler/back-end)

(defun parser (filename generic-filename json-filename lisp-filename)
  (let ((parser-net
         (cl-event-passing-user::@defnetwork parser

            (:code tokenize (:start :pull) (:out :error) #'tokenize-react #'tokenize-first-time)
            (:code parens (:token) (:out :error) #'parens-react #'parens-first-time)
            (:code spaces (:token) (:request :out :error) #'spaces-react #'spaces-first-time)
            (:code strings (:token) (:request :out :error) #'strings-react #'strings-first-time)
            (:code symbols (:token) (:request :out :error) #'symbols-react #'symbols-first-time)
            (:code integers (:token) (:request :out :error) #'integers-react #'integers-first-time)
            (:schem scanner (:start :request) (:out :error)
             (tokenize parens strings symbols spaces integers) ;; parts
             "
              self.start -> tokenize.start
              self.request,spaces.request,strings.request,symbols.request,integers.request -> tokenize.pull
              tokenize.out -> strings.token
              strings.out -> parens.token
              parens.out -> spaces.token
              spaces.out -> symbols.token
              symbols.out -> integers.token
              integers.out -> self.out

              tokenize.error,parens.error,strings.error,symbols.error,spaces.error,integers.error -> self.error
             "
             )
            (:code preparse (:start :token) (:out :request :error) #'preparse-react #'preparse-first-time)
            (:code generic-emitter (:parse) (:out :error) #'generic-emitter-react #'generic-emitter-first-time)
            (:code collector (:parse) (:out :error) #'collector-react #'collector-first-time)
            (:code emitter-pass2-generic (:in) (:out :error) #'emitter-pass2-generic-react #'emitter-pass2-generic-first-time)
            (:code json-emitter (:in) (:out :error) #'json-emitter-react #'json-emitter-first-time)

            (:code generic-file-writer (:filename :write) (:error) #'file-writer-react #'file-writer-first-time)
            (:code json-file-writer (:filename :write) (:error) #'file-writer-react #'file-writer-first-time)
            (:code lisp-file-writer (:filename :write) (:error) #'file-writer-react #'file-writer-first-time)

            (:schem parser (:start :generic-filename :json-filename :lisp-filename) (:out :error)
              (scanner preparse generic-emitter collector json-emitter emitter-pass2-generic
                       generic-file-writer json-file-writer lisp-file-writer)
              "
               self.start -> scanner.start,preparse.start

               scanner.out -> preparse.token
               preparse.request -> scanner.request

               preparse.out -> generic-emitter.parse,collector.parse

               self.generic-filename -> generic-file-writer.filename
               self.json-filename -> json-file-writer.filename
               self.lisp-filename -> lisp-file-writer.filename

               emitter-pass2-generic.out -> generic-file-writer.write

               collector.out -> emitter-pass2-generic.in

               json-emitter.out -> json-file-writer.write

               scanner.error,generic-emitter.error,json-emitter.error,preparse.error,collector.error,
                  generic-file-writer.error,
                  json-file-writer.error,
                  lisp-file-writer.error
               -> self.error

              ")
             )))

    (cl-event-passing-user:@enable-logging)
    (inject! parser-net :generic-filename generic-filename)
    (inject! parser-net :json-filename json-filename)
    (inject! parser-net :lisp-filename lisp-filename)
    (inject! parser-net :start filename)))

(defun cl-user::test ()
  (let ((filename (asdf:system-relative-pathname :arrowgrams "svg/back-end/test.ir"))
        (gfile (asdf:system-relative-pathname :arrowgrams "svg/back-end/generic.out"))
        (jfile (asdf:system-relative-pathname :arrowgrams "svg/back-end/json.out"))
        (lfile (asdf:system-relative-pathname :arrowgrams "svg/back-end/lisp.out")))
    (arrowgrams/compiler/back-end::parser filename gfile jfile lfile)))

(defun cl-user::clear ()
  (esrap::clear-rules)
  (asdf::run-program "rm -rf ~/.cache/common-lisp")
  (ql:quickload :arrowgrams/compiler/back-end))