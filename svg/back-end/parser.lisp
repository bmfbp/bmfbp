(cl:in-package :arrowgrams/compiler/back-end)

(defun parser (filename generic-filename json-filename lisp-filename)
  (let ((parser-net
         (cl-event-passing-user::@defnetwork parser

            (:code tokenize (:start :ir :pull) (:out :error))
            (:code parens (:token) (:out :error))
            (:code spaces (:token) (:request :out :error))
            (:code strings (:token) (:request :out :error))
            (:code symbols (:token) (:request :out :error))
            (:code integers (:token) (:request :out :error))
            (:schem scanner (:start :request :ir) (:out :error)
             (tokenize parens strings symbols spaces integers) ;; parts
             "
              self.ir -> tokenize.ir
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
            (:code preparse (:start :token) (:out :request :error))
            (:code generic-emitter (:parse) (:out :error))
            (:code collector (:parse) (:out :error))
            (:code emitter-pass2-generic (:in) (:out :error))
            (:code json-emitter (:in) (:out :error))

            (:code generic-file-writer (:filename :write) (:error) #'file-writer-react #'file-writer-first-time)
            (:code json-file-writer (:filename :write) (:error) #'file-writer-react #'file-writer-first-time)
            (:code lisp-file-writer (:filename :write) (:error) #'file-writer-react #'file-writer-first-time)

            (:schem parser (:start :ir :generic-filename :json-filename :lisp-filename) (:out :error)
              (scanner preparse generic-emitter collector json-emitter emitter-pass2-generic
                       generic-file-writer json-file-writer lisp-file-writer)
              "
               self.ir -> scanner.ir,preparse.start

               self.start -> scanner.start,preparse.start

               scanner.out -> preparse.token
               preparse.request -> scanner.request

               preparse.out -> generic-emitter.parse,collector.parse

               self.generic-filename -> generic-file-writer.filename
               self.json-filename -> json-file-writer.filename
               self.lisp-filename -> lisp-file-writer.filename

               emitter-pass2-generic.out -> generic-file-writer.write

               collector.out -> json-emitter.in,emitter-pass2-generic.in

               json-emitter.out -> json-file-writer.write

               scanner.error,generic-emitter.error,json-emitter.error,preparse.error,collector.error,
                  generic-file-writer.error,
                  json-file-writer.error,
                  lisp-file-writer.error
               -> self.error

              ")
             )))

    (cl-event-passing-user:@enable-logging)
    (@with-dispatch
      (@inject parser-net :generic-filename generic-filename)
      (@inject parser-net :json-filename json-filename)
      (@inject parser-net :lisp-filename lisp-filename)
      (@inject parser-net :start filename))))

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
