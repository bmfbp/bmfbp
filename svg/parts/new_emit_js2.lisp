(defmacro @loop (&body body) `(loop ,@body))
(defmacro @exit-when (expr) `(when ,expr (return)))

(defmacro child-id (w) `(first ,w))
(defmacro child-name (w) `(second ,w))

(defun main ()
  (with-open-file (t27 "~/projects/bmfbp/svg/js-compiler/temp27.lisp" :direction :input)
    (let ((whole (read t27))
          (hashmap (make-hash-table))
          (out *standard-output*))
      (@loop
       (@exit-when (null whole))
       (let ((property (pop whole)))
         (let ((value (pop whole)))
           (setf (gethash property hashmap) value))))
      (format out "~&{~%\"name\" : ~s,~%" (gethash 'name hashmap))
      (format out "\"wirecount\" : ~s,~%" (gethash 'wirecount hashmap))
      (format out "\"metadata\" : ~a,~%" (gethash 'metadata hashmap))
      (emit-self-part out hashmap)
      (format out "\"parts\" :[~%")
      (let ((wire-list (gethash 'wires hashmap))
            (first-time t))
        #+nil(@loop
          (@exit-when (null wire-list))
          (let ((wire (pop wire-list)))
            (unless first-time
              (format out ",~%"))
            (setf first-time nil)
            (print-part out (child-id wire) (child-name wire) hashmap))))
      (format out "~&]~%")
      (format out "}~%")
      )))

(defun print-part (out id name hashmap)
  (unless (eq name 'null)
    (let ((first-time t))
      (format out "  {~%")
      (unless first-time
        (format out ",~%"))
      (setf first-time nil)
      (format out "    \"partName\" : \"~A\",~%" id)
      (format out "    \"kindName\" : ~S" name)
      (format out "~&  }"))))

(defun emit-self-part (out hashmap)
  (format out "\"self\" : {~%")
  (format out "  \"kindName\" : ~S,~%" (gethash 'name hashmap))
  (let ((wire-list (gethash 'wires hashmap)))
    (let ((ins (getins 'null wire-list))
          (outs (getouts 'null wire-list)))
      (format out "  \"inCount\" : ~S,~%" (length ins))
      (format out "  \"outCount\" : ~S,~%" (length outs))
      (format out "  \"ins\" : [")
      (print-outports 'null wire-list out) ;; for SELF, ins == outports
      (format out "],~%")
      (format out "  \"outs\" : [")
      (print-inports 'null wire-list out)  ;; for SELF, outs == inports
      (format out "],~%")))
  (format out "},~%"))

(defun print-inports (name wlist out)
  (format out "[")
  (@loop
    (@exit-when (null wlist))
    (let ((wire (pop wlist))
          (first-time t))
      (unless first-time
        (format out ","))
      (setf first-time nil)
      (when (eq name (inname wire))
        (format out "~s" (inport wire)))))
  (format out "]"))

(defun print-outports (name wlist out)
  (format out "[")
  (@loop
    (@exit-when (null wlist))
    (let ((wire (pop wlist))
          (first-time t))
      (unless first-time
        (format out ","))
      (setf first-time nil)
      (when (eq name (outname wire))
        (format out "~s" (outport wire)))))
  (format out "]"))


(defmacro inname (w) `(seventh ,w))
(defmacro inport (w) `(eighth ,w))

(defun getins (name wires)
  (let ((result nil))
    (@loop
      (@exit-when (null wires))
      (let ((wire (pop wires)))
        (when (eq name (inname wire))
          (push (inport wire) result))))
    result))

(defmacro outname (w) `(second ,w))
(defmacro outport (w) `(third ,w))

(defun getouts (name wires)
  (let ((result nil))
    (@loop
      (@exit-when (null wires))
      (let ((wire (pop wires)))
        (when (eq name (outname wire))
          (push (outport wire) result))))
    result))

#|  
{
  "partName": "ID374",
  "wireCount": 4,
  "self": {
    "kindName": "pass_and_add",
    "inCount": 3,
    "outCount": 1,
    "inPins": [[0], [1], [2]],
    "outPins": [[0, 3]]
  },
  "parts": [
    {
      "kindName": "add_1",
      "inCount": 1,
      "outCount": 1,
      "inPins": [[1]],
      "outPins": [[3]],
    }
  ]
}
|#           