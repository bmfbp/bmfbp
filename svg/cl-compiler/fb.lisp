(in-package :arrowgrams/compiler)

(defclass fb (compiler-part)
  ((show-additions :accessor show-additions)
   (fb-as-iterable-list :accessor fb-as-iterable-list)))

(defmethod e/part:busy-p ((self fb)) (call-next-method))
(defmethod e/part:clone ((self fb)) (call-next-method))
;; create an in-memory factbase, given single facts sent in on pins :string-fact or :lisp-fact

; (:code fb (:string-fact :lisp-fact :retract :go :fb-request :iterate :get-next :show) (:fb :no-more :next :error))

(defmethod e/part:first-time ((self fb))
  (setf (show-additions self) nil)
  (setf (fb-as-iterable-list self) nil)
  (call-next-method))

(defmethod e/part:react ((self fb) e)
  (flet ((idle-handler (action state) (declare (ignorable state))
           (if (eq action :retract)
               (progn
                 (setf (fb self) (remove-fact (e/event:data e) (fb self)))
                 (@send self :fb (fb self)))
             (if (eq action :string-fact)
                 (add-string-fact self (e/event:data e))
               (if (eq action :lisp-fact)
                   (add-lisp-fact self (e/event:data e))
                 (if (eq action :go)
                     (assert nil)
                   (if (eq action :show)
		       (setf (show-additions self) (e/event:data e))
                     (if (eq action :fb-request)
                         (@send self :fb (fb self))
                       (if (eq action :iterate)
                           (progn
                             (begin-iteration self)
                             (setf (state self) :iterating))
                         (if (eq action :reset)
                             (progn
                               (e/part::first-time self))
                           (@send self :error
                                  (format nil "FB in state :idle expected :retract, :string-fact, :lisp-fact, :go, :fb-request or :iterate, but got action ~S data ~S" action (e/event:data e)))))))))))))
         
           (let ((action (@pin self e))
                 (state (state self)))
             (ecase state
               (:idle
                (idle-handler action state))
               (:idle-with-cleanup ;; might get one more request after going back to :idle
                (if (eq action :get-next)
                    (e/part:first-time self)
                  (idle-handler action state)))
               (:iterating
		(if (eq action :get-next)
		    (send-next self)
		    (if (eq action :iterate) ;; restart iteration from beginning
			(begin-iteration self)
			(@send self :error
                               (format nil "FB in state :iterating expected :get-next or :iterate, but got action ~S data ~S"
                                       action (@data self e))))))))))
  
(defmethod begin-iteration ((self fb))
  (setf (fb-as-iterable-list self) (fb self))
  (send-next self))

(defmethod send-next ((self fb))
  (let ((fact-list (fb-as-iterable-list self)))
    (let ((fact (pop fact-list)))
      (setf (fb-as-iterable-list self) fact-list)
      (if (null fact)
          (progn
            (@send self :no-more t)
            (e/part:first-time self))
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
           (setf (fb self) (cons
                            (cons fact nil) ;; rules are lists of lists, facts are a list of a list
                            fb))))
    (when (show-additions self)
      (format *standard-output* "~&add-fact ~S~%" fact))
    (let ((fb (fb self)))
      (let ((existing-fact-lis (find-fact fact fb)))
        (if existing-fact-lis
            (let ((existing-fact (first existing-fact-lis)))
              (if (equal existing-fact fact)
                  (fb-warning self "fact already exists ~A" fact)
                (progn
                  (writefb fb))))
          (writefb fb))))))

(defmethod fb-warning ((self fb) format-string &rest format-args)
  (@send self :error (apply #'cl:format
                            nil
                            (concatenate 'string "WARNING FB (pt only): " format-string)
                            format-args)))

(defmethod fb-error ((self fb) format-string &rest format-args)
  (@send self :error (apply #'cl:format
                            nil
                            (concatenate 'string "ERROR FB (tell pt): " format-string)
                            format-args)))


(defun find-fact (fact factbase)
  (find-if #'(lambda (f-list)
               (when (= 1 (length f-list))) ;; skip over rules, examine only facts
               (let ((f (first f-list)))
                 (and (equal (first fact) (first f))
                      (equal (second fact) (second f)))))
           factbase))
