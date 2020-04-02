(in-package :arrowgrams/esa)

; (:code event-passing-parser (:start :token) (:pull :out :error))

(defclass esa-parser (parser)
  ((state :accessor state)))

(defmethod e/part:busy-p ((self esa-parser))
  (call-next-method))

(defmethod e/part:first-time ((self esa-parser))
  (setf (state self) :idle))

(defmethod e/part:react ((self esa-parser) (e e/event:event))
  #+nil(format *standard-output* "~&esa-parser in state ~s gets ~s ~s~%" (state self) (@pin self e) (@data self e))
  (ecase (state self)
    (:idle
     (ecase (@pin self e)
      (:start
       (@send self :pull :parser1)
       (setf (state self) :collecting))))

    (:collecting
     (ecase (@pin self e)
       (:token
        (append-token self (@data self e))
        (if (eq :eof (token-kind (@data self e)))
            (progn
              (initialize-parsing self)
              (esa-dsl self)
              (@send self :out (get-output-stream-string (output-stream self)))
              (setf (state self) :done))
          (unless (token-pulled-p (@data self e))
            (@send self :pull :parser2))))))

    (:done
     (format *error-output* "~&esa-parser done, but received ~s ~s~%" (@pin self e) (@data self e)))))
     
(defmethod append-token ((p esa-parser) token)
  (unless (eq :ws (token-kind token))
    (push token (token-stream p))))

(defmethod initialize-parsing ((p esa-parser))
  ;; the tokens were pushed LIFO, reverse the list to make it FIFO
  (setf (token-stream p) (reverse (token-stream p)))
  (initialize p))
