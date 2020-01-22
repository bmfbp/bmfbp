(in-package :arrowgrams/compiler/back-end)

(defparameter *parser-state* nil)
(defparameter *token-stream* nil) ;; an ordered list of tokens
(defparameter *parser-output-stream* nil)

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
            (let ((tokens (e/event::data e)))
              (setf *token-stream* tokens)
              (setf *parser-output-stream* (make-string-output-stream))
              (parse-ir self)
              (let ((parsed (get-output-stream-string *parser-output-stream*)))
                (send! self :out parsed)
                (setf *parser-state* :done))))))
        
        (:done
         (debug-tok :error (format nil "generic parser done, but got ") tok))))))



(defun string-token (tok)
  (cond ((eq :lpar (token-kind tok)) "(")
        ((eq :rpar (token-kind tok)) ")")
        ((eq :string (token-kind tok)) (format nil "string ~A" (token-text tok)))
        ((eq :ws (token-kind tok)) " ")
        ((eq :integer (token-kind tok)) (format nil "integer ~a" (token-text tok)))
        ((eq :symbol (token-kind tok)) (format nil "symbol ~A" (token-text tok)))
        (t (assert nil))))

(defun debug-token (tok)
  (format *standard-output* "~a~%" (string-token tok)))

(defun accept (self)
  (declare (ignore self))
  (let ((val (first *token-stream*)))
    (setf *token-stream* (cdr *token-stream*))
    ;(debug-token val)
    val))

(defun parse-error (self kind)
  (let ((strm *token-stream*))
    (let ((msg (format nil "~&parser error expecting ~S, but got ~S ~%~%" kind (first *token-stream*))))
      (assert nil () msg)
      (send! self :error msg)
      (setf *token-stream* (cdr strm)) ;; stream is volatile to help debugging
      nil)))

(defun skip-ws (self)
  (declare (ignore self))
  (@:loop
    (@:exit-when (not (eq :ws (token-kind (first *token-stream*)))))
    (pop *token-stream*)))

(defun look-ahead-p (self kind)
  (skip-ws self)
  (and *token-stream*
       (eq kind (token-kind (first *token-stream*)))))

(defun need (self kind)
  (if (look-ahead-p self kind)
      (accept self)
    (parse-error self kind)))

(defun accept-if (self kind)
  (when (look-ahead-p self kind)
    (accept self)))

(defun need-nil-symbol (self)
  (if (and (look-ahead-p self :symbol)
           (string= "NIL" (string-upcase (token-text (first *token-stream*)))))
      (accept self)
    (parse-error self nil)))

(defun emit (fmtstr &rest args)
  (apply #'format *parser-output-stream* fmtstr args))

#|
input 
  LPAR '('
  RPAR ')'
  STRING
  NIL
end 

parse-ir <- LPAR 
|#

(defun parse-ir (self)
  (need self :lpar)
  (let ((top-name (need self :string)))
    (emit "(~a~%" (token-text top-name))
    (let ((inputs (parse-inputs self)))
      (let ((outputs (parse-outputs self)))
        (let ((react-function (need self :string)))
          (let ((first-time-function (need self :string)))
            (let ((part-decls (parse-part-declarations self)))
              (let ((wiring (parse-wiring self)))
                (emit ")~%")))))))))

(defun parse-inputs (self)
  (parse-pin-list self))

(defun parse-outputs (self)
  (parse-pin-list self))

(defun parse-part-declarations (self)
  (need self :lpar)
  (let ((part-decl-list (parse-part-decl-list self)))
    (need self :rpar)
    (emit ")")))

(defun parse-wiring (self)
  (need self :lpar)
  (let ((wires (parse-wire-list self)))
    (need self :rpar)
    (emit ")")))

(defun parse-pin-list (self)
  (if (look-ahead-p self :symbol)
      (need-nil-symbol self)
    (progn
      (need self :lpar)
      (let ((ids (parse-ident-list self)))
        (need self :rpar)
        (emit ")")))))

(defun parse-ident-list (self)
  (let ((id (accept-if self :string)))
    (when id
      (emit "~a " (token-text id))
      (parse-ident-list self))))

(defun parse-part-decl-list (self)
  (when (accept-if self :lpar)
      (progn
        (emit "(")
        (let ((part-decl (parse-part-decl self)))
          (need self :rpar)
          (emit ")")
          (parse-part-decl-list self)))))

(defun parse-part-decl (self)
  (let ((part-id (need self :string)))
    (emit "~a " (token-text part-id))
    (let ((part-kind (need self :string)))
      (emit "~a " (token-text part-kind))
      (let ((inputs (parse-inputs self)))
        (let ((outputs (parse-outputs self)))
          (let ((react-func (need self :string)))
            (emit "~a " (token-text react-func))
            (let ((first-time-func (need self :string)))
              (emit "~a " (token-text first-time-func)))))))))

(defun parse-wire-list (self)
  (need self :lpar)
  (emit "(")
  (let ((wire (parse-wire self)))
    (need self :rpar)
    (emit ")")
    (when (look-ahead-p self :lpar)
      (emit "(")
      (cons wire (parse-wire-list self)))))

(defun parse-wire (self)
  (let ((id (need self :integer)))
    (emit "~a " (token-text id))
    (let ((ins (parse-part-pin-list self)))
      (let ((outs (parse-part-pin-list self)))
        `(,id ,ins ,outs)))))

(defun parse-part-pin-list (self)
  (need self :lpar)
  (emit "(")
  (parse-part-pins self)
  (need self :rpar)
  (emit ")"))

(defun parse-part-pins (self)
  (when (look-ahead-p self :lpar)
    (parse-part-pin self)
    (parse-part-pins self)))

(defun parse-part-pin (self)
  (need self :lpar)
  (emit "(")
  (let ((part (need self :string)))
    (let ((pin (need self :string)))
      (need self :rpar)
      (emit "~a ~a)" (token-text part) (token-text pin)))))
