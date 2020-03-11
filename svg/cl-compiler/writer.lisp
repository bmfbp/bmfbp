(in-package :arrowgrams/compiler)

(defclass writer (compiler-part)
  ((filename :accessor filename)
   (chstream :accessor chstream)))

(defmethod e/part:busy-p ((self writer)) (call-next-method))
(defmethod e/part:clone ((self writer)) (call-next-method))
; (:code writer (:filename :start :next :no-more) (:request :error))

(defmethod e/part:first-time ((self writer))
  (setf (filename self) nil)
  (setf (chstream self) *standard-output*)
  (call-next-method))

(defmethod e/part:react ((self writer) (e e/event:event))
  (let ((action (e/event::sym e))
        (state (state self)))
    (ecase state
      (:idle
       (ecase action
         (:filename
          (setf (filename self) (e/event:data e))
          (open-stream self))
         
         (:start
          (@send self :request t)
          (setf (state self) :writing))))

      (:writing
       (ecase action
         (:no-more
          (close-stream self)
          (e/part:first-time self))
         (:next
          (write-fact self (e/event:data e))
          (@send self :request t)))))))

(defmethod open-stream ((self writer))
  (let ((filename (filename self)))
    (when filename
      (let ((chstream (open filename :direction :output :if-exists :supersede)))
        (if chstream
            (setf (chstream self) chstream)
          (@send self :error (format nil "can't open file ~S" filename)))))))

(defmethod close-stream ((self writer))
  (let ((filename (filename self))
        (chstream (chstream self)))
    (when (and filename
               chstream
               (not (eq *standard-output* chstream)))
      (close chstream))))
  

(defmethod write-fact ((self writer) lfact)
  (let ((chstream (chstream self)))
    (unless (listp lfact)
      (@send self :error (format nil "facts must be a list, but got ~S" lfact)))
    (let ((fact (car lfact)))
      (if (not (or (= 3 (length fact)) (= 2 (length fact))))
          (progn
            (@send self :error (format nil "WRITER warning: facts must be length 2 or 3, but got ~S" lfact))
            (ecase (length fact)
              (4 (format chstream "~a(~s,~s,~s).~%" (first fact) (second fact) (third fact) (fourth fact) (fifth fact)))
              (5 (format chstream "~a(~s,~s,~s,~s).~%" (first fact) (second fact) (third fact) (fourth fact) (fifth fact)
                         (sixth fact)))
              (6 (format chstream "~a(~s,~s,~s,~s,~s).~%" (first fact) (second fact) (third fact) (fourth fact) (fifth fact)
                         (sixth fact) (seventh fact)))
              (7 (format chstream "~a(~s,~s,~s,~s,~s,~s).~%" (first fact) (second fact) (third fact) (fourth fact) (fifth fact)
                         (sixth fact) (seventh fact) (eighth fact)))
              (8 (format chstream "~a(~s,~s,~s,~s,~s,~s,~s).~%" (first fact) (second fact) (third fact) (fourth fact) (fifth fact)
                         (sixth fact) (seventh fact) (eighth fact) (ninth fact)))
              (9 (format chstream "~a(~s,~s,~s,~s,~s,~s,~s,~s).~%" (first fact) (second fact) (third fact) (fourth fact) (fifth fact)
                         (sixth fact) (seventh fact) (eighth fact) (ninth fact) (tenth fact)))))
        (if (= 2 (length fact))
            (format chstream "~a(~s).~%" (first fact) (second fact))
          (if (= 3 (length fact))
              (format chstream "~a(~s,~s).~%" (first fact) (second fact) (third fact))))))))
