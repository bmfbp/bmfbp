(in-package :arrowgrams/compiler/back-end/collector)

; (:code collector (:parse) (:out :error) #'arrowgrams/compiler/back-end/collector::collector-react #'arrowgrams/compiler/back-end/collector::collector-first-time)

(defparameter *collector-state* nil)

(defmethod collector-first-time ((self e/part:part))
  (setf *collector-state* :idle)
  )

(defmethod collector-react ((self e/part:part) (e e/event:event))
  (let ((tok (e/event::data e))
        (no-print '(:ws :newline :eof)))
    (flet ((pull (id) (send! self :request id) #+nil(format *standard-output* "~&generic emitter: pull ~S~%" id))
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
      (ecase *collector-state*
        (:idle
         (ecase (e/event::sym e)
           (:parse
            (let ((p (make-instance 'arrowgrams/compiler/back-end/collector::parser :owner self :token-stream (e/event::data e))))
              (ir p)
              (let ((schem (top-schematic p)))
                (unparse-schematic p)
                (send! self :out (arrowgrams/compiler/back-end::unparsed-token-stream p))
                (format *standard-output* "COLLECTOR NIY~%")
                (setf *collector-state* :done))))))
        
        (:done
         (debug-tok :error (format nil "generic parser done, but got ") tok))))))

;; proxies
(defun token-kind (tok) (arrowgrams/compiler/back-end:token-kind tok))
(defun token-text (tok) (arrowgrams/compiler/back-end:token-text tok))
(defun token-position (tok) (arrowgrams/compiler/back-end:token-position tok))
(defun token-pulled-p (tok) (arrowgrams/compiler/back-end:token-pulled-p tok))
(defmethod send! ((p e/part:part) pin data) (arrowgrams/compiler/back-end:send! p pin data))
