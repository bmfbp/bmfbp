(in-package :rephrase)

(in-package :rephrase)

;; tokens --> :character, :raw, :ws, :string, :symbol, :integer
;; all tokens have 4 accessible fields - kind, text, position (in line, 0=bol), line (starts at line 1)

;; internally, we send a "pull" request to the tokenizer for every token
;; every token is filtered, as per the scanner schematic in parser-schem.lisp: tokenize -> comments -> spaces -> strings -> symbols -> integers, where comments are %...newline and become :ws (whitespace token), symbols are
;; [A-Za-z<][A-Za-z0-9>-]*

;; internally, we add a field pulled-p to tokens, to tell if a filter earlier in the pipeline has already pulled this token (see symbols.lisp - once it sees a start-char, it buffers characters until it sees a non-follow-char, then emits a :symbol token along with the just-seen non-symbol token - in this case, it has already sent enough pulls to get every symbol token plus one more pull to get the non-symbol token - it sets pulled-p to T in the non-symbol token)

;; syntax - rp uses left-handles to make it easier to parse, each left-handle is exactly one character (which makes it even easier to parse :-)

;; = <name>            define a rule with given name
;; - <name>            define a predicate rule with given name, predicate can contain ^ok or ^fail operator
;;     to perform certain actions (e.g. anything not related to parsing), but we ignore that semantic check for now

;; [A-Z]+ - (all caps) input a token with the kind given by the symbol (e.g. STRING means input a string), else, error,
;;     if the token name is followed by "/text", then token must be a symbol and its text must match the given text (text is case sensitive)
;; 'x' character token match - token kind must be :character and text must be a single char with value given (e.g. x)
;; ?'x' - look ahead for a :character token which matches given character, succeed if matched, else fail
;; ?TTT - look ahead for a token with the given kind, succeed if so, else fail
;; ?TTT/text - look ahead for a token with the given kind and text, succeed if so, else fail
;; * - no-op, always succeeds, only allowed in choice exprs
;; = - define a new rule whose name is that of the next symbol (e.g. = <architecture> starts a new rule called "<architecture>", N.B. "<" is a valid start-char, and ">" and "-" are valid follow-chars for symbols
;; [ - start a choice, next item must be a lookahead
;; | - start another choice clause, next item must be one of...  '<symbol>, :<symbol>, ?<symbol> or *
;; | * "otherwise"/"else" choice clause, see * above
;; ] - end choice
;; @symbol - call rule named by the symbol
;; &symbol - call predicate named by the symbol
;; symbol - call external routine
;; ^ok or ^fail   return status from predicate
;; { begin cycle (forever)
;; } end cycle
;; > exit cycle
;; 

;; N.B. "<" and ">" are valid identifier characters in Common Lisp

(defmethod <rp> ((p parser))
  (@:loop
    (if (parser-success-p (look-char? p #\=))
	(<parse-rule> p)
      (if (parser-success-p (look-char? p #\-))
	  (<parse-predicate> p)
         (@:exit-when t))))
)

(defmethod <parse-token-expr> ((p parser))
  (cond ((parser-success-p (look-char? p #\'))
	 (input-char p #\')
	 (input p :character)
             (emit p "(input-char p #\\~c)" (token-text (accepted-token p)))
         (input-char p #\')
	 :ok)
	((parser-success-p (look-upcase-symbol? p))
	 (input-upcase-symbol p)
	 (if (parser-success-p (look-char? p #\/))
	     ;; qualified token NAME/qual
             (progn
               (input-char p #\/)
	       ;; qual can be a SYMBOl or a single char
	       (if (parser-success-p (look? p :character))
		   (progn
		     (input p :character)
		     (emit p "(input-char p #\\~c)" (token-text (accepted-token p))))
		  (progn
		    (input p :symbol)
		    (emit p "(input-symbol p ~s)" (token-text (accepted-token p)))))
	       )
	   ;; unqualified token NAME
           (emit p "(input p :~a)" (token-text (accepted-token p))))
	 :ok)
	(t :fail)))

(defmethod <parse-noop> ((p parser))
  (cond ((parser-success-p (look-char? p #\*))
	 (input-char p #\*)
             (emit p " t ")
	 :ok)
	(t :fail)))

(defmethod <parse-expr> ((p parser))
  (cond ((parser-success-p (<parse-token-expr> p)) :ok)
	((parser-success-p (<parse-noop> p))       :ok)
	(t :fail)))

(defmethod <parse-lookahead-token-expr> ((p parser))
  (cond ((parser-success-p (look-char? p #\'))
	 (input-char p #\')
	 (input p :character)
             (emit p "(parser-success-p (look-char? p #\\~c))" (token-text (accepted-token p)))
         (input-char p #\')
	 :ok)
	((parser-success-p (look-upcase-symbol? p))
	 (input-upcase-symbol p)
	 (cond ((parser-success-p (look-char? p #\/))
                 ;; same as above (<parse-token-expr>) TOKEN/qual where qual can be a symbol or a character
                 ;; TOKEN/q where q is a :symbol or :character
                 (input-char p #\/)
                 (cond ((parser-success-p (look? p :character))
                        ;; q is :character
                        (input p :character)
                        (emit p "(parser-success-p (look-char? p #\\~c))" (token-text (accepted-token p))))
                       ;; else q is :symbol
                       (t
                        (input p :symbol)
                        (emit p "(parser-success-p (look-symbol? p ~s))" (token-text (accepted-token p))))))
               (t (emit p "(parser-success-p (look? p :~a))" (token-text (accepted-token p)))))
         :ok)
        (t :fail)))

(defmethod <parse-lookahead-noop> ((p parser))
  (cond ((parser-success-p (look-char? p #\*))
	 (input-char p #\*)
             (emit p " t ")
	 :ok)
	(t :fail)))

(defmethod <parse-lookahead-expr> ((p parser))
  (cond ((parser-success-p (<parse-lookahead-token-expr> p)) :ok)
	((parser-success-p (<parse-lookahead-noop> p))       :ok)
	(t :fail)))

(defmethod <parse-statement> ((p parser))
  (cond ((parser-success-p (<parse-cycle> p)) :ok)
	((parser-success-p (<parse-choice> p)) :ok)
	((parser-success-p (<parse-return> p)) :ok)
	((parser-success-p (<parse-cycle-exit> p)) :ok)
	((parser-success-p (<parse-input-token> p)) :ok)
	((parser-success-p (<parse-lookahead> p)) :ok)
	((parser-success-p (<parse-noop> p)) :ok)
	((parser-success-p (<parse-rule-call> p)) :ok)
	((parser-success-p (<parse-predicate-call> p)) :ok)
	((parser-success-p (<parse-external-call> p)) :ok)
	((parser-success-p (<parse-raw-text> p)) :ok)
	(t :fail)))

(defmethod <parse-statements> ((p parser))
  (let ((result :fail))
  (@:loop
   (@:exit-when (not (parser-success-p (<parse-statement> p))))
   (emit p "~%")
   (setf result :ok))
  result))

(defmethod <parse-cond-statements> ((p parser))
  (let ((result :fail))
  (@:loop
   (@:exit-when (not (parser-success-p (<parse-statement> p))))
   (setf result :ok))
  result))

(defmethod <parse-cycle> ((p parser))
  (cond ((parser-success-p (look-char? p #\{))
	 (input-char p #\{)
                 (emit p "~&(loop~%")
	 (<parse-statements> p)
	 (input-char p #\})
                 (emit p ") ;;loop~%")
	 :ok)
	(t :fail)))

(defmethod <parse-choice> ((p parser))
  (cond ((parser-success-p (look-char? p #\[))
	 (input-char p #\[)
             (emit p "~&(cond~%")
             (emit p "(")
	 (<parse-cond-statements> p)
             (emit p ");choice clause~%")
         (@:loop
           (@:exit-when (not (parser-success-p (look-char? p #\|))))
           (input-char p #\|)
               (emit p "(")
           (<parse-statements> p)
               (emit p ");choice alt~%"))
	 (input-char p #\])
            (emit p ");choice~%")
	 :ok)
	(t :fail)))

(defmethod <parse-choice-alternate> ((p parser))
  (cond ((parser-success-p (look-char? p #\|))
	 (input-char p #\|)
             (emit p "(")
	 (<parse-statements> p)
             (emit p ") ;; alternate~%")
	 :ok)
	(t :fail)))

(defmethod <parse-input-token> ((p parser))
  (<parse-expr> p))

(defmethod error-if-not-success ((p parser) value)
  (if (eq :ok value)
      :ok
      (parse-error p nil "")))

(defmethod <parse-lookahead> ((p parser))
  (cond ((parser-success-p (look-char? p #\?))
	 (input-char p #\?)
	 (error-if-not-success p (<parse-lookahead-expr> p))
	 :ok)
	(t :fail)))
  
(defmethod <parse-rule-call> ((p parser))
  (cond ((parser-success-p (look-char? p #\@))
	 (input-char p #\@)
	 (input p :symbol)
            (emit p "(call-rule p #'~a)" (token-text (accepted-token p)))
	 :ok)
	(t :fail)))

(defmethod <parse-predicate-call> ((p parser))
  (cond ((parser-success-p (look-char? p #\&))
	 (input-char p #\&)
	 (input p :symbol)
            (emit p "(parser-success-p (call-predicate p #'~a))" (token-text (accepted-token p)))
	 :ok)
	(t :fail)))

(defmethod <parse-external-call> ((p parser))
  (cond ((parser-success-p (look? p :symbol))
	 (input p :symbol)
               (emit p "(call-external p #'~a)" (token-text (accepted-token p)))
	 :ok)
	(t :fail)))

(defmethod <parse-raw-text> ((p parser))
  (cond ((parser-success-p (look? p :raw))
	 (input p :raw)
               (emit p "~&")
               (emit-raw p (token-text (accepted-token p)))
	 :ok)
	(t :fail)))
	
(defmethod <parse-cycle-exit> ((p parser))
  (cond ((parser-success-p (look-char? p #\>))
	 (input-char p #\>)
           (emit p "(return)")
	 :ok)
	(t :fail)))

(defmethod <parse-return> ((p parser))
  (cond ((parser-success-p (look-char? p #\^))
	 (input-char p #\^)
	 (input p :symbol)
	 (error-if-not-success p
	  (if (string= "fail" (token-text (accepted-token p)))
	      (progn
                      (emit p "(return-from ~a :fail)" (current-rule p))
                :ok)
	      (if (string= "ok" (token-text (accepted-token p)))
		  (progn
                      (emit p "(return-from ~a :ok)" (current-rule p))
                    :ok)
		  :fail)))
	 :ok)
	(t :fail)))
  
(defmethod <parse-rule> ((p parser))
  (input-char p #\=)
  (input p :symbol)
  (setf (current-rule p) (token-text (accepted-token p)))
             (emit p "(defmethod ~a ((p parser))~%" (current-rule p))
  (<parse-statements> p)
             (emit p ") ; rule~%~%")
  :ok
  )

(defmethod <parse-predicate> ((p parser))
  (input-char p #\-)
  (input p :symbol)
  (setf (current-rule p) (token-text (accepted-token p)))
             (emit p "(defmethod ~a ((p parser)) ;; predicate~%" (current-rule p))
  (<parse-statements> p)
             (emit p ") ; pred~%~%")
  :ok
  )
