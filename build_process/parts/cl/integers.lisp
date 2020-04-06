(in-package :arrowgrams/build)

;; each leaf part must inherit from node and define two methods:
;; 1) intially
;; 2) react
;; (see below for signatures)

(defclass integers (node)
  ((buffer :accessor buffer)
   (start-position :accessor start-position)
   (start-linen :accessor start-line)
   (nposition :accessor nposition)
   (nline :accessor nline)
   (state :accessor state)))

(defmethod initially ((self integers))
  (setf (state self) :idle)
  (setf (start-position self) 0)
  (setf (nline self) 0)
  (setf (buffer self) nil))

(defmethod react ((self integers) (e e/event:event))
  (format *standard-output* "~&integers gets ~S ~S~%" (@pin self e) (@data self e))

  ;; some (local) utility functions
  (labels ((push-char-into-buffer () (push (token-text (@data self e)) (buffer self)))
           (pull () (@send self :pull :integers))
           (forward-token (&key (pulled-p nil))
             (let ((tok (@data self e)))
               (let ((new-token (make-token :kind (token-kind tok)
                                            :text (token-text tok)
                                            :line (token-line tok)
                                            :position (token-position tok)
                                            :pulled-p (or pulled-p (token-pulled-p tok)))))
                 (@send self :out new-token))))
           (start-char-p () 
             (when (eq :character (token-kind (@data self e)))
               (let ((c (token-text (@data self e))))
                 (and (char>= c #\0) (char<= c #\9)))))
           (follow-char-p ()
             (when (eq :character (token-kind (@data self e)))
               (let ((c (token-text (@data self e))))
                 (and (char>= c #\0) (char<= c #\9)))))
           (action () (@pin self e))
           (next-state (x) (setf (state self) x))
           (eof-p () (eq :eof (token-kind (@data self e))))
           (record ()
             (setf (nline self) (token-line (@data self e)))
             (setf (nposition self) (token-position (@data self e))))
           (clear-buffer ()
             (setf (buffer self) nil)
             (setf (start-position self) (token-position (@data self e))))
           (release-buffer ()
             (@send self :out (make-token :kind :integer :text (integers-get-buffer self) :position (start-position self) :line (start-line self) :pulled-p t)))
           (release-and-clear-buffer ()
             (release-buffer)
             (clear-buffer))
         )

    (ecase (state self)
      (:idle
       (ecase (action)
         (:token
          (record)
          (cond ((eof-p)
                 (forward-token)
                 (next-state :done))
		((start-char-p)
                 (setf (start-position self) (nposition self))
                 (setf (start-line self) (nline self))
                 (push-char-into-buffer)
                 (pull)
                 (next-state :collecting-integer))
		(t (forward-token))))))
      (:collecting-integer
       (ecase (action)
         (:token
          (record)
          (cond ((eof-p)
                 (release-and-clear-buffer)
                 (forward-token)
                 (next-state :done))
		((follow-char-p)
                 (push-char-into-buffer)
                 (pull))
		(t
                 (release-and-clear-buffer)
                 (forward-token)
                 (next-state :idle))))))
      (:done
       (@send self :error (format nil "integers finished, but received ~S" e))))))

;; utility functions

(defmethod integers-get-buffer ((self integers)) (coerce (reverse (buffer self)) 'string))
(defmethod integers-get-position ((self integers)) (start-position self))

