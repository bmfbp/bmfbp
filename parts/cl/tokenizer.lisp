;; inputs: 
;; - filename - string name of file to be tokenized
;; - request  - a trigger (anything) asks for one token to be output

;; outputs:
;; - token  - one token for each trigger, if file not EOF
;; - eof    - a trigger that fires when a request comes in and the file is EOF
;; - error  - a message when EOF has been issued once and another request arrives, or if the filename is illegal or cannot be opened

(defstruct token
  kind
  text
  position
  line)

(defclass tokenizer (node)
  ((nline :accessor nline)
   (nposition :accessor nposition)
   (state :accessor state)
   (file-stream :accessor file-stream)))


(defmethod initially ((self tokenizer))
  (reset self))

(defmethod react ((self tokenizer) (e event))
  (ecase (state self)
    (:idle
     (ecase (pin-name (partpin e))
       (:filename 
        (let ((filename (data e)))
          (cond ((not (stringp filename))
                 (send-to-pin self "error" (format nil ":filename input was not given a string (~a)" filename)))
                ((not (cl:probe-file filename))
                 (send-to-pin self "error" (format nil ":filename ~a not found" filename)))
                (t
                 (let ((f nil))
                   (ignore-errors
                       (progn
                         (setf f (cl:open filename :direction :input))
                         (setf err nil)))
                   (unless f
                     (send-to-pn self "error" (format nil ":filename ~a could not be opened for input" filename))))))))
     (otherwise
        (send-to-pin self "error" (format nil "tokenizer in state :idle did not receive a filename (but received ~a)" (pin (partpin e)))))))

    (:reading
     (ecase (pin-name (partpin e))
       (:request
        (cond ((null (file-stream self))
               (send-to-pin self "error" "tokenizer: file closed")
               (setf (state self) :idle))
              (t (let ((c nil))
                   (ignore-errors
                     (progn
                       (setf c (readchar (filestream self) nil :eof))
                       (if (eq :eof c)
                           (progn
                             (cl:close (filestream self))
                             (setf (filestream self) nil)
                             (send-to-pin self "eof" (make-eof-token self) t)
                             (setf (state self) :idle))
                         (send-to-pin self "token" (make-character-token self c))))))
                 (unless c
                   (send-to-pin self "error" (format nil "read error"))))))
       (otherwise
        (send-to-pin self "error" (format nil "tokenizer in state :request did not receive a :request (but received ~a)" (pin (partpin e)))))))

    (otherwise
     (send-to-pin self "error" (format nil "tokenize in state ~a received an illegal event (~a)" (pin (partpin e))))
     (setf (state self) :idle))))

(defmethod reset ((self tokenizer))
  (setf (state self) :idle)
  (setf (nline self) 1)
  (setf (nposition self) 1)
  (setf (file-stream self) nil))

(defmethod make-eof-token ((self tokenizer))
  (make-token :kind :eof
              :text ""
              :line (nline self)
              :position 0))

(defun newline-p (c)
  (eq #\Newline c))

(defmethod make-character-token ((self tokenizer) c)
  (if (newline-p c)
      (progn
        (incf (nline self))
        (setf (nposition self) 1))
    (incf (nposition self)))    
  (make-token :kind :character
              :text c
              :line (nline self)
              :position 0))

(defmethod send-to-pin ((self tokenizer) pin-string data)
  (let ((e (make-instance 'event))
        (pp (make-instance 'part-pin)))
    (setf (part-name pp) (name-in-container self))
    (setf (pin-name pp) pin-string)
    (setf (partpin e) pp)
    (setf (data    e) data)
    (send self e)))


