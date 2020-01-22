(in-package :arrowgrams/compiler/back-end)

(defparameter *parser-state* nil)

(defmethod generic-parser-first-time ((self e/part:part))
  (setf *parser-state* :idle)
  )

(defmethod generic-parser-react ((self e/part:part) (e e/event:event))
  ;(format *standard-output* "~&generic parser ~S   ~S ~S~%" *parser-state* (e/event::sym e) (e/event:data e))
  (let ((tok (e/event::data e))
        (no-print '(:ws :newline :eof)))
    (flet ((pull (id) (send! self :request id) #+nil(format *standard-output* "~&generic parser: pull ~S~%" id))
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
      (ecase *parser-state*
        (:idle
         (ecase (e/event::sym e)
           (:parse
            (let ((p (make-instance 'parser :owner self :token-stream (e/event::data e))))
              (parse-ir p)
              (send! self :out (get-output p))
              (setf *parser-state* :done)))))
        
        (:done
         (debug-tok :error (format nil "generic parser done, but got ") tok))))))

(defmethod parse-ir ((p parser))
  (need p :lpar)
  (let ((top-name (need p :string)))
    (emit p "(~a~%" (token-text top-name))
    (let ((inputs (parse-inputs p)))
      (let ((outputs (parse-outputs p)))
        (let ((react-function (need p :string)))
          (let ((first-time-function (need p :string)))
            (let ((part-decls (parse-part-declarations p)))
              (let ((wiring (parse-wiring p)))
                (emit p ")~%")))))))))

(defmethod parse-inputs ((p parser))
  (parse-pin-list p))

(defmethod parse-outputs ((p parser))
  (parse-pin-list p))

(defmethod parse-part-declarations ((p parser))
  (need p :lpar)
  (let ((part-decl-list (parse-part-decl-list p)))
    (need p :rpar)
    (emit p ")")))

(defmethod parse-wiring ((p parser))
  (need p :lpar)
  (let ((wires (parse-wire-list p)))
    (need p :rpar)
    (emit p ")")))

(defmethod parse-pin-list ((p parser))
  (if (look-ahead-p p :symbol)
      (need-nil-symbol p)
    (progn
      (need p :lpar)
      (let ((ids (parse-ident-list p)))
        (need p :rpar)
        (emit p ")")))))

(defmethod parse-ident-list ((p parser))
  (let ((id (accept-if p :string)))
    (when id
      (emit p "~a " (token-text id))
      (parse-ident-list p))))

(defmethod parse-part-decl-list ((p parser))
  (when (accept-if p :lpar)
      (progn
        (emit p "(")
        (let ((part-decl (parse-part-decl p)))
          (need p :rpar)
          (emit p ")")
          (parse-part-decl-list p)))))

(defmethod parse-part-decl ((p parser))
  (let ((part-id (need p :string)))
    (emit p "~a " (token-text part-id))
    (let ((part-kind (need p :string)))
      (emit p "~a " (token-text part-kind))
      (let ((inputs (parse-inputs p)))
        (let ((outputs (parse-outputs p)))
          (let ((react-func (need p :string)))
            (emit p "~a " (token-text react-func))
            (let ((first-time-func (need p :string)))
              (emit p "~a " (token-text first-time-func)))))))))

(defmethod parse-wire-list ((p parser))
  (need p :lpar)
  (emit p "(")
  (let ((wire (parse-wire p)))
    (need p :rpar)
    (emit p ")")
    (when (look-ahead-p p :lpar)
      (emit p "(")
      (cons wire (parse-wire-list p)))))

(defmethod parse-wire ((p parser))
  (let ((id (need p :integer)))
    (emit p "~a " (token-text id))
    (let ((ins (parse-part-pin-list p)))
      (let ((outs (parse-part-pin-list p)))
        `(,id ,ins ,outs)))))

(defmethod parse-part-pin-list ((p parser))
  (need p :lpar)
  (emit p "(")
  (parse-part-pins p)
  (need p :rpar)
  (emit p ")"))

(defmethod parse-part-pins ((p parser))
  (when (look-ahead-p p :lpar)
    (parse-part-pin p)
    (parse-part-pins p)))

(defmethod parse-part-pin ((p parser))
  (need p :lpar)
  (emit p "(")
  (let ((part (need p :string)))
    (let ((pin (need p :string)))
      (need p :rpar)
      (emit p "~a ~a)" (token-text part) (token-text pin)))))
