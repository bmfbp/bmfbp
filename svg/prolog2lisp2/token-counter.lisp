;;INPUTS
;; (:in <token>) counts the # of tokens of each type, then outputs a list when it receives (:EOF nil)
;;
;;OUTPUTS
;; (:out <string>)   count of each type of token, in a string
;; (:error object)       some fatal error, "object" specifies error details
;;
;; (:code token-counter (:in) (:out :error)
;;  :react #'arrowgrams/parser/token-counter::react
;;  :first-time #'arrowgrams/parser/token-counter::first-time)

(in-package :arrowgrams/parser/token-counter)

(defmethod first-time ((self e/part:part))
  (@set-instance-var self :counts (make-hash-table)))

(defmethod react ((self e/part:part) (e e/event:event))
  (let ((token (e/event:data e))
        (action (e/event::sym e)))
    (assert (eq action :in))
    (let ((ty (token-type token)))
      (if (eq :EOF ty)
          (finalize self)
        (tcount self token)))))

(defmethod tcount ((self e/part:part) token)
  (let ((hash-key (token-type token)))
    (let ((counts-hashtable (@get-instance-var self :counts)))
      (multiple-value-bind (count success)
          (gethash hash-key counts-hashtable)
        (let ((new-count
               (if success
                   (1+ count)
                 1)))
          (setf (gethash hash-key counts-hashtable) new-count)
          (@set-instance-var self :counts counts-hashtable))))))

(defmethod finalize ((self e/part:part))
  (let ((counts (@get-instance-var self :counts)))
    (let ((final-list nil))
      (maphash #'(lambda (key val)
                   (push (list key val) final-list))
               counts)
      (let ((out-pin (@get-output-pin self :out)))
        (@send self out-pin final-list)))))
