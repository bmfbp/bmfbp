(in-package :arrowgrams/compiler/back-end/json-emitter)

(defparameter *json-emitter-state* nil)

(defmethod json-emitter-first-time ((self e/part:part))
  (setf *json-emitter-state* :idle)
  )

(defmethod json-emitter-react ((self e/part:part) (e e/event:event))
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
      (ecase *json-emitter-state*
        (:idle
         (ecase (e/event::sym e)
           (:parse
            (format *standard-output* "json emitter NIY~%")
            (setf *json-emitter-state* :done))))
        
        (:done
         (debug-tok :error (format nil "json emitter done, but got ") tok))))))

;; proxies
(defun token-kind (tok) (arrowgrams/compiler/back-end:token-kind tok))
(defun token-text (tok) (arrowgrams/compiler/back-end:token-text tok))
(defun token-position (tok) (arrowgrams/compiler/back-end:token-position tok))
(defun token-pulled-p (tok) (arrowgrams/compiler/back-end:token-pulled-p tok))
(defmethod send! ((p e/part:part) pin data) (arrowgrams/compiler/back-end:send! p pin data))
