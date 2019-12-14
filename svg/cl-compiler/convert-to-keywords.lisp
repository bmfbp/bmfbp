(in-package :arrowgrams/compiler/convert-to-keywords)

; (:code reader (:string-fact) (:converted :error) #'arrowgrams/compiler/reader::react #'arrowgrams/compiler/reader::first-time)

;; read a string fact, output as a lisp fact with all symbols converted to keywords

(defmethod first-time ((self e/part:part))
  ;; nothing
  )

(defmethod react ((self e/part:part) e)
  (let ((pin (e/event::sym e))
        (string-fact (e/event:data e))
        (new-list nil))
    (assert (eq pin :string-fact))
    (with-input-from-string (str string-fact)
      (let ((flat-list (read str nil nil)))
        (assert (and (not (null flat-list))
                     (listp flat-list)))
        (let ((len (length flat-list)))
          (assert (or (= 3 len) (= 2 len)))
          (if (eq 3 len)
              (setf new-list `(,(keyword-ize (first flat-list)) ,(keyword-ize (second flat-list)) ,(keyword-ize (third flat-list))))
            (setf new-list `(,(keyword-ize (first flat-list)) ,(keyword-ize (second flat-list)))))
          (cl-event-passing-user::@send self :converted new-list))))))

(defun keyword-ize (x)
  (if (symbolp x)
      (intern (symbol-name x) "KEYWORD")
    x))