;;INPUTS
;; (:in "string")  a string, if first and last chars are ", then delete them
;;
;;OUTPUTS
;; (:out String)         input string without leading and trailing quotes (if any)
;; (:fatal object)       some fatal error, "object" specifies error details
;;



(in-package :arrowgrams)

(defmethod stripquotes ((self e/part:part) (e e/event:event))
  (let ((data (e/event:data e))
        (action (e/event::sym e)))

    (unless (eq action :in)
      (cl-event-passing-user::@send self "bad input pin for stripquotes (only accepts :in)"))
    
    (unless (or (pathnamep data) (stringp data))
      (cl-event-passing-user::@send self "bad input string or stripquotes (only accepts string or pathname)"))
    
    (let ((str data))
      (if (and
           (eq #\" (char str 0))
           (or (eq #\" (char str (1- (length str))))
               (and (eq #\" (char str (1- (1- (length str)))))
                    (eq #\Newline (char str (1- (length str)))))))
          (cl-event-passing-user::@send self :out (subseq str 1 (1- (length str))))
        (cl-event-passing-user::@send self :out str)))))
