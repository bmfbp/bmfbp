(cl:in-package :arrowgrams/compiler)

(defun parser (filename generic-filename json-filename lisp-filename)
  (let ((parser-net
         #+nil(cl-event-passing-user::@defnetwork parser

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
            )
(PROGN
 (CL-EVENT-PASSING-USER:@INITIALIZE)
 (LET ((TOKENIZE
        (CL-EVENT-PASSING-USER:@NEW-CODE :KIND 'TOKENIZE :NAME "TOKENIZE"
                                         :INPUT-HANDLER
                                         #'CL-EVENT-PASSING-PART:REACT
                                         :INPUT-PINS '(:START :IR :PULL)
                                         :OUTPUT-PINS '(:OUT :ERROR)
                                         :FIRST-TIME-HANDLER
                                         #'CL-EVENT-PASSING-PART:FIRST-TIME)))
   (LET ((PARENS
          (CL-EVENT-PASSING-USER:@NEW-CODE :KIND 'PARENS :NAME "PARENS"
                                           :INPUT-HANDLER
                                           #'CL-EVENT-PASSING-PART:REACT
                                           :INPUT-PINS '(:TOKEN) :OUTPUT-PINS
                                           '(:OUT :ERROR) :FIRST-TIME-HANDLER
                                           #'CL-EVENT-PASSING-PART:FIRST-TIME)))
     (LET ((SPACES
            (CL-EVENT-PASSING-USER:@NEW-CODE :KIND 'SPACES :NAME "SPACES"
                                             :INPUT-HANDLER
                                             #'CL-EVENT-PASSING-PART:REACT
                                             :INPUT-PINS '(:TOKEN) :OUTPUT-PINS
                                             '(:REQUEST :OUT :ERROR)
                                             :FIRST-TIME-HANDLER
                                             #'CL-EVENT-PASSING-PART:FIRST-TIME)))
       (LET ((STRINGS
              (CL-EVENT-PASSING-USER:@NEW-CODE :KIND 'STRINGS :NAME "STRINGS"
                                               :INPUT-HANDLER
                                               #'CL-EVENT-PASSING-PART:REACT
                                               :INPUT-PINS '(:TOKEN)
                                               :OUTPUT-PINS
                                               '(:REQUEST :OUT :ERROR)
                                               :FIRST-TIME-HANDLER
                                               #'CL-EVENT-PASSING-PART:FIRST-TIME)))
         (LET ((SYMBOLS
                (CL-EVENT-PASSING-USER:@NEW-CODE :KIND 'SYMBOLS :NAME "SYMBOLS"
                                                 :INPUT-HANDLER
                                                 #'CL-EVENT-PASSING-PART:REACT
                                                 :INPUT-PINS '(:TOKEN)
                                                 :OUTPUT-PINS
                                                 '(:REQUEST :OUT :ERROR)
                                                 :FIRST-TIME-HANDLER
                                                 #'CL-EVENT-PASSING-PART:FIRST-TIME)))
           (LET ((INTEGERS
                  (CL-EVENT-PASSING-USER:@NEW-CODE :KIND 'INTEGERS :NAME
                                                   "INTEGERS" :INPUT-HANDLER
                                                   #'CL-EVENT-PASSING-PART:REACT
                                                   :INPUT-PINS '(:TOKEN)
                                                   :OUTPUT-PINS
                                                   '(:REQUEST :OUT :ERROR)
                                                   :FIRST-TIME-HANDLER
                                                   #'CL-EVENT-PASSING-PART:FIRST-TIME)))
             (LET ((SCANNER
                    (CL-EVENT-PASSING-USER:@NEW-SCHEMATIC :NAME "SCANNER"
                                                          :INPUT-PINS
                                                          '(:START :REQUEST
                                                            :IR)
                                                          :OUTPUT-PINS
                                                          '(:OUT :ERROR)
                                                          :FIRST-TIME-HANDLER
                                                          NIL)))
               (CL-EVENT-PASSING-USER:@ADD-PART-TO-SCHEMATIC SCANNER TOKENIZE)
               (CL-EVENT-PASSING-USER:@ADD-PART-TO-SCHEMATIC SCANNER PARENS)
               (CL-EVENT-PASSING-USER:@ADD-PART-TO-SCHEMATIC SCANNER STRINGS)
               (CL-EVENT-PASSING-USER:@ADD-PART-TO-SCHEMATIC SCANNER SYMBOLS)
               (CL-EVENT-PASSING-USER:@ADD-PART-TO-SCHEMATIC SCANNER SPACES)
               (CL-EVENT-PASSING-USER:@ADD-PART-TO-SCHEMATIC SCANNER INTEGERS)
               (LET ((#:WIRE-628
                      (CL-EVENT-PASSING::MAKE-WIRE
                       (LIST
                        (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                 (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                  :PIN-PARENT
                                                                  TOKENIZE
                                                                  :PIN-NAME :IR
                                                                  :DIRECTION
                                                                  :INPUT)))))
                     (#:WIRE-629
                      (CL-EVENT-PASSING::MAKE-WIRE
                       (LIST
                        (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                 (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                  :PIN-PARENT
                                                                  TOKENIZE
                                                                  :PIN-NAME
                                                                  :START
                                                                  :DIRECTION
                                                                  :INPUT)))))
                     (#:WIRE-630
                      (CL-EVENT-PASSING::MAKE-WIRE
                       (LIST
                        (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                 (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                  :PIN-PARENT
                                                                  TOKENIZE
                                                                  :PIN-NAME
                                                                  :PULL
                                                                  :DIRECTION
                                                                  :INPUT)))))
                     (#:WIRE-631
                      (CL-EVENT-PASSING::MAKE-WIRE
                       (LIST
                        (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                 (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                  :PIN-PARENT
                                                                  STRINGS
                                                                  :PIN-NAME
                                                                  :TOKEN
                                                                  :DIRECTION
                                                                  :INPUT)))))
                     (#:WIRE-632
                      (CL-EVENT-PASSING::MAKE-WIRE
                       (LIST
                        (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                 (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                  :PIN-PARENT
                                                                  PARENS
                                                                  :PIN-NAME
                                                                  :TOKEN
                                                                  :DIRECTION
                                                                  :INPUT)))))
                     (#:WIRE-633
                      (CL-EVENT-PASSING::MAKE-WIRE
                       (LIST
                        (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                 (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                  :PIN-PARENT
                                                                  SPACES
                                                                  :PIN-NAME
                                                                  :TOKEN
                                                                  :DIRECTION
                                                                  :INPUT)))))
                     (#:WIRE-634
                      (CL-EVENT-PASSING::MAKE-WIRE
                       (LIST
                        (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                 (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                  :PIN-PARENT
                                                                  SYMBOLS
                                                                  :PIN-NAME
                                                                  :TOKEN
                                                                  :DIRECTION
                                                                  :INPUT)))))
                     (#:WIRE-635
                      (CL-EVENT-PASSING::MAKE-WIRE
                       (LIST
                        (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                 (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                  :PIN-PARENT
                                                                  INTEGERS
                                                                  :PIN-NAME
                                                                  :TOKEN
                                                                  :DIRECTION
                                                                  :INPUT)))))
                     (#:WIRE-636
                      (CL-EVENT-PASSING::MAKE-WIRE
                       (LIST
                        (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                 (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                  :PIN-PARENT
                                                                  SCANNER
                                                                  :PIN-NAME
                                                                  :OUT
                                                                  :DIRECTION
                                                                  :OUTPUT)))))
                     (#:WIRE-637
                      (CL-EVENT-PASSING::MAKE-WIRE
                       (LIST
                        (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                 (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                  :PIN-PARENT
                                                                  SCANNER
                                                                  :PIN-NAME
                                                                  :ERROR
                                                                  :DIRECTION
                                                                  :OUTPUT))))))
                 (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE SCANNER #:WIRE-628
                                                          (LIST
                                                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                            :PIN
                                                            (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                             :PIN-PARENT
                                                             SCANNER :PIN-NAME
                                                             :IR :DIRECTION
                                                             :INPUT))))
                 (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE SCANNER #:WIRE-629
                                                          (LIST
                                                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                            :PIN
                                                            (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                             :PIN-PARENT
                                                             SCANNER :PIN-NAME
                                                             :START :DIRECTION
                                                             :INPUT))))
                 (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE SCANNER #:WIRE-630
                                                          (LIST
                                                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                            :PIN
                                                            (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                             :PIN-PARENT
                                                             SCANNER :PIN-NAME
                                                             :REQUEST
                                                             :DIRECTION
                                                             :INPUT))
                                                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                            :PIN
                                                            (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                             :PIN-PARENT SPACES
                                                             :PIN-NAME :REQUEST
                                                             :DIRECTION
                                                             :OUTPUT))
                                                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                            :PIN
                                                            (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                             :PIN-PARENT
                                                             STRINGS :PIN-NAME
                                                             :REQUEST
                                                             :DIRECTION
                                                             :OUTPUT))
                                                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                            :PIN
                                                            (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                             :PIN-PARENT
                                                             SYMBOLS :PIN-NAME
                                                             :REQUEST
                                                             :DIRECTION
                                                             :OUTPUT))
                                                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                            :PIN
                                                            (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                             :PIN-PARENT
                                                             INTEGERS :PIN-NAME
                                                             :REQUEST
                                                             :DIRECTION
                                                             :OUTPUT))))
                 (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE SCANNER #:WIRE-631
                                                          (LIST
                                                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                            :PIN
                                                            (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                             :PIN-PARENT
                                                             TOKENIZE :PIN-NAME
                                                             :OUT :DIRECTION
                                                             :OUTPUT))))
                 (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE SCANNER #:WIRE-632
                                                          (LIST
                                                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                            :PIN
                                                            (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                             :PIN-PARENT
                                                             STRINGS :PIN-NAME
                                                             :OUT :DIRECTION
                                                             :OUTPUT))))
                 (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE SCANNER #:WIRE-633
                                                          (LIST
                                                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                            :PIN
                                                            (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                             :PIN-PARENT PARENS
                                                             :PIN-NAME :OUT
                                                             :DIRECTION
                                                             :OUTPUT))))
                 (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE SCANNER #:WIRE-634
                                                          (LIST
                                                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                            :PIN
                                                            (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                             :PIN-PARENT SPACES
                                                             :PIN-NAME :OUT
                                                             :DIRECTION
                                                             :OUTPUT))))
                 (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE SCANNER #:WIRE-635
                                                          (LIST
                                                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                            :PIN
                                                            (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                             :PIN-PARENT
                                                             SYMBOLS :PIN-NAME
                                                             :OUT :DIRECTION
                                                             :OUTPUT))))
                 (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE SCANNER #:WIRE-636
                                                          (LIST
                                                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                            :PIN
                                                            (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                             :PIN-PARENT
                                                             INTEGERS :PIN-NAME
                                                             :OUT :DIRECTION
                                                             :OUTPUT))))
                 (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE SCANNER #:WIRE-637
                                                          (LIST
                                                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                            :PIN
                                                            (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                             :PIN-PARENT
                                                             TOKENIZE :PIN-NAME
                                                             :ERROR :DIRECTION
                                                             :OUTPUT))
                                                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                            :PIN
                                                            (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                             :PIN-PARENT PARENS
                                                             :PIN-NAME :ERROR
                                                             :DIRECTION
                                                             :OUTPUT))
                                                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                            :PIN
                                                            (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                             :PIN-PARENT
                                                             STRINGS :PIN-NAME
                                                             :ERROR :DIRECTION
                                                             :OUTPUT))
                                                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                            :PIN
                                                            (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                             :PIN-PARENT
                                                             SYMBOLS :PIN-NAME
                                                             :ERROR :DIRECTION
                                                             :OUTPUT))
                                                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                            :PIN
                                                            (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                             :PIN-PARENT SPACES
                                                             :PIN-NAME :ERROR
                                                             :DIRECTION
                                                             :OUTPUT))
                                                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                            :PIN
                                                            (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                             :PIN-PARENT
                                                             INTEGERS :PIN-NAME
                                                             :ERROR :DIRECTION
                                                             :OUTPUT)))))
               (LET ((PREPARSE
                      (CL-EVENT-PASSING-USER:@NEW-CODE :KIND 'PREPARSE :NAME
                                                       "PREPARSE"
                                                       :INPUT-HANDLER
                                                       #'CL-EVENT-PASSING-PART:REACT
                                                       :INPUT-PINS
                                                       '(:START :TOKEN)
                                                       :OUTPUT-PINS
                                                       '(:OUT :REQUEST :ERROR)
                                                       :FIRST-TIME-HANDLER
                                                       #'CL-EVENT-PASSING-PART:FIRST-TIME)))
                 (LET ((GENERIC-EMITTER
                        (CL-EVENT-PASSING-USER:@NEW-CODE :KIND 'GENERIC-EMITTER
                                                         :NAME
                                                         "GENERIC-EMITTER"
                                                         :INPUT-HANDLER
                                                         #'CL-EVENT-PASSING-PART:REACT
                                                         :INPUT-PINS '(:PARSE)
                                                         :OUTPUT-PINS
                                                         '(:OUT :ERROR)
                                                         :FIRST-TIME-HANDLER
                                                         #'CL-EVENT-PASSING-PART:FIRST-TIME)))
                   (LET ((COLLECTOR
                          (CL-EVENT-PASSING-USER:@NEW-CODE :KIND 'COLLECTOR
                                                           :NAME "COLLECTOR"
                                                           :INPUT-HANDLER
                                                           #'CL-EVENT-PASSING-PART:REACT
                                                           :INPUT-PINS
                                                           '(:PARSE)
                                                           :OUTPUT-PINS
                                                           '(:OUT :ERROR)
                                                           :FIRST-TIME-HANDLER
                                                           #'CL-EVENT-PASSING-PART:FIRST-TIME)))
                     (LET ((EMITTER-PASS2-GENERIC
                            (CL-EVENT-PASSING-USER:@NEW-CODE :KIND
                                                             'EMITTER-PASS2-GENERIC
                                                             :NAME
                                                             "EMITTER-PASS2-GENERIC"
                                                             :INPUT-HANDLER
                                                             #'CL-EVENT-PASSING-PART:REACT
                                                             :INPUT-PINS '(:IN)
                                                             :OUTPUT-PINS
                                                             '(:OUT :ERROR)
                                                             :FIRST-TIME-HANDLER
                                                             #'CL-EVENT-PASSING-PART:FIRST-TIME)))
                       (LET ((JSON-EMITTER
                              (CL-EVENT-PASSING-USER:@NEW-CODE :KIND
                                                               'JSON-EMITTER
                                                               :NAME
                                                               "JSON-EMITTER"
                                                               :INPUT-HANDLER
                                                               #'CL-EVENT-PASSING-PART:REACT
                                                               :INPUT-PINS
                                                               '(:IN)
                                                               :OUTPUT-PINS
                                                               '(:OUT :ERROR)
                                                               :FIRST-TIME-HANDLER
                                                               #'CL-EVENT-PASSING-PART:FIRST-TIME)))
                         (LET ((GENERIC-FILE-WRITER
                                (CL-EVENT-PASSING-USER:@NEW-CODE :KIND
                                                                 'GENERIC-FILE-WRITER
                                                                 :NAME
                                                                 "GENERIC-FILE-WRITER"
                                                                 :INPUT-HANDLER
                                                                 #'FILE-WRITER-REACT
                                                                 :INPUT-PINS
                                                                 '(:FILENAME
                                                                   :WRITE)
                                                                 :OUTPUT-PINS
                                                                 '(:ERROR)
                                                                 :FIRST-TIME-HANDLER
                                                                 #'FILE-WRITER-FIRST-TIME)))
                           (LET ((JSON-FILE-WRITER
                                  (CL-EVENT-PASSING-USER:@NEW-CODE :KIND
                                                                   'JSON-FILE-WRITER
                                                                   :NAME
                                                                   "JSON-FILE-WRITER"
                                                                   :INPUT-HANDLER
                                                                   #'FILE-WRITER-REACT
                                                                   :INPUT-PINS
                                                                   '(:FILENAME
                                                                     :WRITE)
                                                                   :OUTPUT-PINS
                                                                   '(:ERROR)
                                                                   :FIRST-TIME-HANDLER
                                                                   #'FILE-WRITER-FIRST-TIME)))
                             (LET ((LISP-FILE-WRITER
                                    (CL-EVENT-PASSING-USER:@NEW-CODE :KIND
                                                                     'LISP-FILE-WRITER
                                                                     :NAME
                                                                     "LISP-FILE-WRITER"
                                                                     :INPUT-HANDLER
                                                                     #'FILE-WRITER-REACT
                                                                     :INPUT-PINS
                                                                     '(:FILENAME
                                                                       :WRITE)
                                                                     :OUTPUT-PINS
                                                                     '(:ERROR)
                                                                     :FIRST-TIME-HANDLER
                                                                     #'FILE-WRITER-FIRST-TIME)))
                               (LET ((PARSER
                                      (CL-EVENT-PASSING-USER:@NEW-SCHEMATIC
                                       :NAME "PARSER" :INPUT-PINS
                                       '(:START :IR :GENERIC-FILENAME
                                         :JSON-FILENAME :LISP-FILENAME)
                                       :OUTPUT-PINS '(:OUT :ERROR)
                                       :FIRST-TIME-HANDLER NIL)))
                                 (CL-EVENT-PASSING-USER:@ADD-PART-TO-SCHEMATIC
                                  PARSER SCANNER)
                                 (CL-EVENT-PASSING-USER:@ADD-PART-TO-SCHEMATIC
                                  PARSER PREPARSE)
                                 (CL-EVENT-PASSING-USER:@ADD-PART-TO-SCHEMATIC
                                  PARSER GENERIC-EMITTER)
                                 (CL-EVENT-PASSING-USER:@ADD-PART-TO-SCHEMATIC
                                  PARSER COLLECTOR)
                                 (CL-EVENT-PASSING-USER:@ADD-PART-TO-SCHEMATIC
                                  PARSER JSON-EMITTER)
                                 (CL-EVENT-PASSING-USER:@ADD-PART-TO-SCHEMATIC
                                  PARSER EMITTER-PASS2-GENERIC)
                                 (CL-EVENT-PASSING-USER:@ADD-PART-TO-SCHEMATIC
                                  PARSER GENERIC-FILE-WRITER)
                                 (CL-EVENT-PASSING-USER:@ADD-PART-TO-SCHEMATIC
                                  PARSER JSON-FILE-WRITER)
                                 (CL-EVENT-PASSING-USER:@ADD-PART-TO-SCHEMATIC
                                  PARSER LISP-FILE-WRITER)
                                 (LET ((#:WIRE-638
                                        (CL-EVENT-PASSING::MAKE-WIRE
                                         (LIST
                                          (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                           :PIN
                                           (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                            :PIN-PARENT SCANNER :PIN-NAME :IR
                                            :DIRECTION :INPUT))
                                          (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                           :PIN
                                           (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                            :PIN-PARENT PREPARSE :PIN-NAME
                                            :START :DIRECTION :INPUT)))))
                                       (#:WIRE-639
                                        (CL-EVENT-PASSING::MAKE-WIRE
                                         (LIST
                                          (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                           :PIN
                                           (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                            :PIN-PARENT SCANNER :PIN-NAME
                                            :START :DIRECTION :INPUT))
                                          (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                           :PIN
                                           (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                            :PIN-PARENT PREPARSE :PIN-NAME
                                            :START :DIRECTION :INPUT)))))
                                       (#:WIRE-640
                                        (CL-EVENT-PASSING::MAKE-WIRE
                                         (LIST
                                          (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                           :PIN
                                           (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                            :PIN-PARENT PREPARSE :PIN-NAME
                                            :TOKEN :DIRECTION :INPUT)))))
                                       (#:WIRE-641
                                        (CL-EVENT-PASSING::MAKE-WIRE
                                         (LIST
                                          (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                           :PIN
                                           (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                            :PIN-PARENT SCANNER :PIN-NAME
                                            :REQUEST :DIRECTION :INPUT)))))
                                       (#:WIRE-642
                                        (CL-EVENT-PASSING::MAKE-WIRE
                                         (LIST
                                          (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                           :PIN
                                           (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                            :PIN-PARENT GENERIC-EMITTER
                                            :PIN-NAME :PARSE :DIRECTION
                                            :INPUT))
                                          (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                           :PIN
                                           (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                            :PIN-PARENT COLLECTOR :PIN-NAME
                                            :PARSE :DIRECTION :INPUT)))))
                                       (#:WIRE-643
                                        (CL-EVENT-PASSING::MAKE-WIRE
                                         (LIST
                                          (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                           :PIN
                                           (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                            :PIN-PARENT GENERIC-FILE-WRITER
                                            :PIN-NAME :FILENAME :DIRECTION
                                            :INPUT)))))
                                       (#:WIRE-644
                                        (CL-EVENT-PASSING::MAKE-WIRE
                                         (LIST
                                          (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                           :PIN
                                           (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                            :PIN-PARENT JSON-FILE-WRITER
                                            :PIN-NAME :FILENAME :DIRECTION
                                            :INPUT)))))
                                       (#:WIRE-645
                                        (CL-EVENT-PASSING::MAKE-WIRE
                                         (LIST
                                          (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                           :PIN
                                           (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                            :PIN-PARENT LISP-FILE-WRITER
                                            :PIN-NAME :FILENAME :DIRECTION
                                            :INPUT)))))
                                       (#:WIRE-646
                                        (CL-EVENT-PASSING::MAKE-WIRE
                                         (LIST
                                          (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                           :PIN
                                           (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                            :PIN-PARENT GENERIC-FILE-WRITER
                                            :PIN-NAME :WRITE :DIRECTION
                                            :INPUT)))))
                                       (#:WIRE-647
                                        (CL-EVENT-PASSING::MAKE-WIRE
                                         (LIST
                                          (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                           :PIN
                                           (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                            :PIN-PARENT JSON-EMITTER :PIN-NAME
                                            :IN :DIRECTION :INPUT))
                                          (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                           :PIN
                                           (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                            :PIN-PARENT EMITTER-PASS2-GENERIC
                                            :PIN-NAME :IN :DIRECTION
                                            :INPUT)))))
                                       (#:WIRE-648
                                        (CL-EVENT-PASSING::MAKE-WIRE
                                         (LIST
                                          (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                           :PIN
                                           (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                            :PIN-PARENT JSON-FILE-WRITER
                                            :PIN-NAME :WRITE :DIRECTION
                                            :INPUT)))))
                                       (#:WIRE-649
                                        (CL-EVENT-PASSING::MAKE-WIRE
                                         (LIST
                                          (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                           :PIN
                                           (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                            :PIN-PARENT PARSER :PIN-NAME :ERROR
                                            :DIRECTION :OUTPUT))))))
                                   (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                                    PARSER #:WIRE-638
                                    (LIST
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           PARSER
                                                                           :PIN-NAME
                                                                           :IR
                                                                           :DIRECTION
                                                                           :INPUT))))
                                   (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                                    PARSER #:WIRE-639
                                    (LIST
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           PARSER
                                                                           :PIN-NAME
                                                                           :START
                                                                           :DIRECTION
                                                                           :INPUT))))
                                   (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                                    PARSER #:WIRE-640
                                    (LIST
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           SCANNER
                                                                           :PIN-NAME
                                                                           :OUT
                                                                           :DIRECTION
                                                                           :OUTPUT))))
                                   (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                                    PARSER #:WIRE-641
                                    (LIST
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           PREPARSE
                                                                           :PIN-NAME
                                                                           :REQUEST
                                                                           :DIRECTION
                                                                           :OUTPUT))))
                                   (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                                    PARSER #:WIRE-642
                                    (LIST
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           PREPARSE
                                                                           :PIN-NAME
                                                                           :OUT
                                                                           :DIRECTION
                                                                           :OUTPUT))))
                                   (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                                    PARSER #:WIRE-643
                                    (LIST
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           PARSER
                                                                           :PIN-NAME
                                                                           :GENERIC-FILENAME
                                                                           :DIRECTION
                                                                           :INPUT))))
                                   (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                                    PARSER #:WIRE-644
                                    (LIST
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           PARSER
                                                                           :PIN-NAME
                                                                           :JSON-FILENAME
                                                                           :DIRECTION
                                                                           :INPUT))))
                                   (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                                    PARSER #:WIRE-645
                                    (LIST
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           PARSER
                                                                           :PIN-NAME
                                                                           :LISP-FILENAME
                                                                           :DIRECTION
                                                                           :INPUT))))
                                   (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                                    PARSER #:WIRE-646
                                    (LIST
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           EMITTER-PASS2-GENERIC
                                                                           :PIN-NAME
                                                                           :OUT
                                                                           :DIRECTION
                                                                           :OUTPUT))))
                                   (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                                    PARSER #:WIRE-647
                                    (LIST
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           COLLECTOR
                                                                           :PIN-NAME
                                                                           :OUT
                                                                           :DIRECTION
                                                                           :OUTPUT))))
                                   (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                                    PARSER #:WIRE-648
                                    (LIST
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           JSON-EMITTER
                                                                           :PIN-NAME
                                                                           :OUT
                                                                           :DIRECTION
                                                                           :OUTPUT))))
                                   (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                                    PARSER #:WIRE-649
                                    (LIST
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           SCANNER
                                                                           :PIN-NAME
                                                                           :ERROR
                                                                           :DIRECTION
                                                                           :OUTPUT))
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           GENERIC-EMITTER
                                                                           :PIN-NAME
                                                                           :ERROR
                                                                           :DIRECTION
                                                                           :OUTPUT))
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           JSON-EMITTER
                                                                           :PIN-NAME
                                                                           :ERROR
                                                                           :DIRECTION
                                                                           :OUTPUT))
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           PREPARSE
                                                                           :PIN-NAME
                                                                           :ERROR
                                                                           :DIRECTION
                                                                           :OUTPUT))
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           COLLECTOR
                                                                           :PIN-NAME
                                                                           :ERROR
                                                                           :DIRECTION
                                                                           :OUTPUT))
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           GENERIC-FILE-WRITER
                                                                           :PIN-NAME
                                                                           :ERROR
                                                                           :DIRECTION
                                                                           :OUTPUT))
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           JSON-FILE-WRITER
                                                                           :PIN-NAME
                                                                           :ERROR
                                                                           :DIRECTION
                                                                           :OUTPUT))
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           LISP-FILE-WRITER
                                                                           :PIN-NAME
                                                                           :ERROR
                                                                           :DIRECTION
                                                                           :OUTPUT)))))
                                 (LET ()
                                   (CL-EVENT-PASSING-USER:@TOP-LEVEL-SCHEMATIC
                                    PARSER)
                                   (CL-EVENT-PASSING-USER-UTIL::CHECK-TOP-LEVEL-SCHEMATIC-SANITY
                                    PARSER)
                                   PARSER))))))))))))))))))

	  ))

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
    (parser filename gfile jfile lfile)))

(defun cl-user::clear ()
  (asdf::run-program "rm -rf ~/.cache/common-lisp")
  (ql:quickload :arrowgrams/compiler/back-end))
