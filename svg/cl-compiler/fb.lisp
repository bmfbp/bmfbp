(in-package :arrowgrams/compiler)

(defclass fb (e/part:part) ())
(defmethod e/part:busy-p ((self fb)) (call-next-method))
;; create an in-memory factbase, given single facts sent in on pins :string-fact or :lisp-fact

; (:code fb (:string-fact :lisp-fact :retract :go :fb-request :iterate :get-next :show) (:fb :no-more :next :error))

(defmethod e/part:first-time ((self fb))
  (@set self :show-additions nil)
  (@set self :state :idle)
  (@set self :fb-as-iterable-list nil)
  (@set self :factbase nil)
  (call-next-method))

(defmethod e/part:react ((self fb) e)
  (flet ((idle-handler (action state) (declare (ignorable state))
           (if (eq action :retract)
               (progn
                 (format *standard-output* "~&retract ~S~%" (e/event:data e))
                 (@set
                  self
                  :factbase
                  (arrowgrams/compiler/util::remove-fact
                   (e/event:data e)
                   (@get self :factbase)))
                 (@send self :fb (@get self :factbase)))
             (if (eq action :string-fact)
                 (add-string-fact self (e/event:data e))
               (if (eq action :lisp-fact)
                   (add-lisp-fact self (e/event:data e))
                 (if (eq action :go)
                     (assert nil)
                   (if (eq action :show)
		       (@set self :show-additions (e/event:data e))
                     (if (eq action :fb-request)
                         (@send self :fb (@get self :factbase))
                       (if (eq action :iterate)
                           (progn
                             (begin-iteration self)
                             (@set self :state :iterating))
                         (@send self :error
                                (format nil "FB in state :idle expected :retract, :string-fact, :lisp-fact, :go, :fb-request or :iterate, but got action ~S data ~S" action (e/event:data e))))))))))))
  
           (let ((action (@pin e))
                 (state (@get self :state)))    
             (ecase state
               (:idle
                (idle-handler action state))
               (:idle-with-cleanup ;; might get one more request after going back to :idle
                (if (eq action :get-next)
                    (@set self :state :idle)
                  (idle-handler action state)))
               (:iterating
		(if (eq action :get-next)
		    (send-next self)
		    (if (eq action :iterate) ;; restart iteration from beginning
			(begin-iteration self)
			(@send self :error
                               (format nil "FB in state :iterating expected :get-next or :iterate, but got action ~S data ~S"
                                       action (@data e)))))))
	     (call-next-method))))
  
(defmethod begin-iteration ((self fb))
  (@set self :fb-as-iterable-list (@get self :factbase))
  (send-next self))

(defmethod send-next ((self fb))
  (let ((fact-list (@get self :fb-as-iterable-list)))
    (let ((fact (pop fact-list)))
      (@set self :fb-as-iterable-list fact-list)
      (if (null fact)
          (progn
            (@send self :no-more t)
            (@set self :state :idle-with-cleanup))
        (@send self :next fact)))))
       
      
                           
(defmethod add-string-fact ((self fb) fact-string)
  (declare (ignore self))
  (with-input-from-string (fact-stream fact-string)
    (let ((fact (read fact-stream nil :EOF)))
      (if (not (listp fact))
          (@send self :error (format nil "db: expected a list, but got ~S" fact-string))
        (add-lisp-fact self fact)))))

(defmethod add-lisp-fact ((self fb) fact)
  (flet ((writefb (fb)
           (@set self :factbase (cons
				 (cons fact nil) ;; rules are lists of lists, facts are a list of a list
                                 fb))))
    (when (@get self :show-additions)
      (format *standard-output* "~&add-fact ~S~%" fact))
    (let ((fb (@get self :factbase)))
      (let ((existing-fact-lis (find-fact fact fb)))
        (if existing-fact-lis
            (let ((existing-fact (first existing-fact-lis)))
              (if (equal existing-fact fact)
                  (fb-warning self "fact already exists ~A" fact)
                (progn
                  ;(fb-error self "fact ~S attempts to override existing fact ~S" fact existing-fact)
                  (writefb fb))))
          (writefb fb))))))

(defmethod fb-warning ((self fb) format-string &rest format-args)
  (@send self :error (apply #'cl:format
                            nil
                            (concatenate 'string "WARNING FB: " format-string)
                            format-args)))

(defmethod fb-error ((self fb) format-string &rest format-args)
  (@send self :error (apply #'cl:format
                            nil
                            (concatenate 'string "ERROR FB: " format-string)
                            format-args)))


(defun find-fact (fact factbase)
  (find-if #'(lambda (f-list)
               (when (= 1 (length f-list))) ;; skip over rules, examine only facts
               (let ((f (first f-list)))
                 (and (equal (first fact) (first f))
                      (equal (second fact) (second f)))))
           factbase))
