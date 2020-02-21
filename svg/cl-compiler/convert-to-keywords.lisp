(in-package :arrowgrams/compiler)

(defclass convert-to-keywords (e/part:part) ())

; (:code convert-to-keywords (:string-fact :eof) (:done :converted :error))

;; read a string fact, output as a lisp fact with all symbols converted to keywords

(defmethod e/part:busy-p ((self convert-to-keywords))
  (call-next-method))

(defmethod e/part:first-time ((self convert-to-keywords)))

(defmethod e/part:react ((self convert-to-keywords) e)
  (let ((pin (@pin self e))
        (string-fact (e/event:data e))
        (new-list nil))
    (if (eq pin :string-fact)
        (unless (string= "" string-fact)
          (with-input-from-string (str string-fact)
            (let ((flat-list (read str nil nil)))
              (assert (and (not (null flat-list))
                           (listp flat-list)))
              (let ((len (length flat-list)))
                (assert (or (= 3 len) (= 2 len)))
                (if (eq 3 len)
                    (setf new-list `(,(keyword-ize (first flat-list)) ,(keyword-ize (second flat-list)) ,(keyword-ize (third flat-list))))
                  (setf new-list `(,(keyword-ize (first flat-list)) ,(keyword-ize (second flat-list)))))
                (@send self :converted new-list)))))
      (if (eq pin :eof)
          (@send self :done t)
        (@send self :error (format nil "~&convert to keywords unexpected input pin ~S~%" pin))))))

(defun keyword-ize (x)
  (if (symbolp x)
      (intern (symbol-name x) "KEYWORD")
    x))
