(in-package :arrowgrams/compiler/back-end)

(defparameter *generic-json-parser-state* nil)

(defmethod generic-json-parser-first-time ((self e/part:part))
  (setf *generic-json-parser-state* :idle)
  )

(defmethod generic-json-parser-react ((self e/part:part) (e e/event:event))
  (let ((tok (e/event::data e))
        (no-print '(:ws :newline :eof)))
    (flet ((pull (id) (send! self :request id))
           (debug-tok (out-pin msg tok)
             (if (token-pulled-p tok)
                 (send! self out-pin (format nil "~&~a:~a pos:~a c:~a pulled-p:~a"
                                             msg
                                             (token-kind tok)
                                             (token-position tok)
                                             (if (member (token-kind tok) no-print) "." (token-text tok))
                                             (token-pulled-p tok)))
               (send! self out-pin (format nil "~&~a:~a pos:~a c:~a"
                                           msg
                                           (token-kind tok)
                                           (token-position tok)
                                           (if (member (token-kind tok) no-print) "." (token-text tok)))))))
      (ecase *generic-json-parser-state*
        (:idle
         (ecase (e/event::sym e)
           (:parse
            (let ((p (make-instance 'parser :owner self :token-stream (e/event::data e))))
              (generic-json-parse-ir p)
              (send! self :out (get-output p))
              (setf *generic-json-parser-state* :done)))))
        
        (:done
         (debug-tok :error (format nil "generic json parser done, but got ") tok))))))

(defmethod generic-json-parse-ir ((p parser))
  (need p :lpar)
  (let ((top-name (need p :string)))
    (emit p "{ \"kindName\" : ~a,~%" (token-text top-name))
    (emit p "  \"metaData\" : \"\"~%")
    (let ((inputs (generic-json-parse-inputs p)))
      (let ((outputs (generic-json-parse-outputs p)))
        (let ((react-function (need p :string)))
          (let ((first-time-function (need p :string)))
            (let ((part-decls (generic-json-parse-part-declarations p)))
              (let ((wiring (generic-json-parse-wiring p)))
                (emit p "}~%")))))))))

(defmethod generic-json-parse-inputs ((p parser))
  (emit p "  \"inputs\" : ~%")
  (generic-json-parse-pin-list p)
  (emit p "  ]%"))

(defmethod generic-json-parse-outputs ((p parser))
  (emit p "  \"outputs\" : ~%")
  (generic-json-parse-pin-list p)
  (emit p "  ]%"))

(defmethod generic-json-parse-part-declarations ((p parser))
  (need p :lpar)
  (let ((part-decl-list (generic-json-parse-part-decl-list p)))
    (need p :rpar)
    (emit p ")")))

(defmethod generic-json-parse-wiring ((p parser))
  (need p :lpar)
  (let ((wires (generic-json-parse-wire-list p)))
    (need p :rpar)
    (emit p ")")))

(defmethod generic-json-parse-pin-list ((p parser))
  (if (look-ahead-p p :symbol)
      (need-nil-symbol p)
    (progn
      (need p :lpar)
      (emit p "[ ")
      (let ((ids (generic-json-parse-ident-list p)))
        (need p :rpar)
        (emit p "]~%")))))

(defmethod generic-json-parse-ident-list ((p parser))
  (let ((id (accept-if p :string)))
    (when id
      (emit p "~a " (token-text id))
      (generic-json-parse-ident-list p))))

(defmethod generic-json-parse-part-decl-list ((p parser))
  (when (accept-if p :lpar)
      (progn
        (emit p "[")
        (let ((part-decl (generic-json-parse-part-decl p)))
          (need p :rpar)
          (emit p "]~%")
          (generic-json-parse-part-decl-list p)))))

(defmethod generic-json-parse-part-decl ((p parser))
  (let ((part-id (need p :string)))
    (emit p "~a " (token-text part-id))
    (let ((part-kind (need p :string)))
      (emit p "~a " (token-text part-kind))
      (let ((inputs (generic-json-parse-inputs p)))
        (let ((outputs (generic-json-parse-outputs p)))
          (let ((react-func (need p :string)))
            (emit p "~a " (token-text react-func))
            (let ((first-time-func (need p :string)))
              (emit p "~a " (token-text first-time-func)))))))))

(defmethod generic-json-parse-wire-list ((p parser))
  (need p :lpar)
  (emit p "[")
  (let ((wire (generic-json-parse-wire p)))
    (need p :rpar)
    (emit p "]~%")
    (when (look-ahead-p p :lpar)
      (cons wire (generic-json-parse-wire-list p)))))

(defmethod generic-json-parse-wire ((p parser))
  (let ((id (need p :integer)))
    (emit p "\"wire\": ~a " (token-text id))
    (generic-json-parse-part-pin-list p)
    (generic-json-parse-part-pin-list p)))

(defmethod generic-json-parse-part-pin-list ((p parser))
  (need p :lpar)
  (emit p "[")
  (generic-json-parse-part-pins p)
  (need p :rpar)
  (emit p "]~%"))

(defmethod generic-json-parse-part-pins ((p parser))
  (when (look-ahead-p p :lpar)
    (generic-json-parse-part-pin p)
    (generic-json-parse-part-pins p)))

(defmethod generic-json-parse-part-pin ((p parser))
  (need p :lpar)
  (emit p "[")
  (let ((part (need p :string)))
    (let ((pin (need p :string)))
      (need p :rpar)
      (emit p "]~% ~a ~a)" (token-text part) (token-text pin)))))
