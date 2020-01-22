(in-package :arrowgrams/compiler/back-end)

(defparameter *parser-state* nil)
(defparameter *token-stream* nil) ;; an ordered list of tokens
(defparameter *tstream* nil)      ;; an ordered list of tokens, used and updated during parse

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
           (:start
            (pull :parser1)
            (setf *parser-state* :slurping))))
        
        (:slurping
         (ecase (e/event::sym e)
           (:token
            (if (eq :EOF (token-text tok))
                (progn
                  (setf *parser-state* :ready-to-parse)
                  (send! self :go T))
              (progn
                (push tok *token-stream*)
                (unless (token-pulled-p tok)
                  (pull :parser2)))))))
        
        (:ready-to-parse
         (setf *tstream* (reverse *token-stream*))
         (let ((parsed (parse-ir self)))
           (send! self :out parsed)
           (setf *parser-state* :done)))
        
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
  (format *standard-output* "~a (next ~A)~%" (string-token tok) (string-token (first *tstream*))))

(defun accept (self)
  (declare (ignore self))
  (let ((val (first *tstream*)))
    (setf *tstream* (cdr *tstream*))
    (debug-token val)
    val))

(defun parse-error (self kind)
  (let ((strm *tstream*))
    (let ((msg (format nil "~&parser error expecting ~S, but got ~S ~%~%" kind (first *tstream*))))
      (assert nil () msg)
      (send! self :error msg)
      (setf *tstream* (cdr strm)) ;; stream is volatile to help debugging
    nil)))

(defun look-ahead-p (self kind)
  (declare (ignore self))
  (and *tstream*
       (eq kind (token-kind (first *tstream*)))))

(defun need (self kind)
  (if (look-ahead-p self kind)
      (accept self)
    (parse-error self kind)))

(defun accept-if (self kind)
  (when (look-ahead-p self kind)
    (accept self)))

(defun need-nil-symbol (self)
  (need self :symbol)
  (let ((sym (accept self)))
    (if (eq (token-text sym) nil)
        sym
      (parse-error self nil))))

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
    (let ((inputs (parse-inputs self)))
      (let ((outputs (parse-outputs self)))
        (let ((react-function (need self :string)))
          (let ((first-time-function (need self :string)))
            (let ((part-decls (parse-part-declarations self)))
              (let ((wiring (parse-wiring self)))
              `(,top-name ,inputs ,outputs ,react-function ,first-time-function ,part-decls ,wiring)))))))))

(defun parse-inputs (self)
  (parse-pin-list self))

(defun parse-outputs (self)
  (parse-pin-list self))

(defun parse-part-declarations (self)
  (need self :lpar)
  (let ((part-decl-list (parse-part-decl-list self)))
    (need self :rpar)
    part-decl-list))

(defun parse-wiring (self)
  (need self :lpar)
  (let ((wires (parse-wire-list self)))
    (need self :rpar)
    wires))

(defun parse-pin-list (self)
  (if (and (look-ahead-p self :symbol))
      (need-nil-symbol self)
    (progn
      (need self :lpar)
      (let ((ids (parse-ident-list self)))
        (need self :rpar)
        ids))))

(defun parse-ident-list (self)
  (let ((id (accept-if self :string)))
    (when id
      (cons id (parse-ident-list self)))))

(defun parse-part-decl-list (self)
  (if (accept-if self :lpar)
      (let ((part-decl (parse-part-decl self)))
        (need self :rpar)
        (cons part-decl (parse-part-decl-list self)))
    nil))

(defun parse-part-decl (self)
  (let ((part-id (need self :string)))
    (let ((part-kind (need self :string)))
      (let ((inputs (parse-inputs self)))
        (let ((outputs (parse-outputs self)))
          (let ((react-func (need self :string)))
            (let ((first-time-func (need self :string)))
              `((,part-id ,part-kind ,inputs ,outputs ,react-func ,first-time-func)))))))))

(defun parse-wire-list (self)
  (need self :lpar)
  (let ((wire (parse-wire self)))
    (need self :rpar)))

(defun parse-wire (self)
  (let ((id (need self :integer)))
    (let ((ins (parse-part-pin-list self)))
      (let ((outs (parse-part-pin-list self)))
        `(,id ,ins ,outs)))))

(defun parse-part-pin-list (self)
  (need self :lpar)
  (let ((part-pins (parse-part-pins self)))
    (need self :rpar)
    part-pins))

(defun parse-part-pins (self)
  (if (look-ahead-p self :lpar)
      (let ((part-pin (parse-part-pin self)))
        (if (look-ahead-p self :lpar)
            (cons part-pin (parse-part-pins self))
          part-pin))
    nil))

(defun parse-part-pin (self)
  (need self :lpar)
  (let ((part (need self :string)))
    (let ((pin (need self :string)))
      (need self :rpar)
      `(,part ,pin))))