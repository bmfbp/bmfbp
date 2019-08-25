(defmacro @loop (&body body) `(loop ,@body))
(defmacro @exit-when (expr) `(when ,expr (return)))

(defmacro child-id (w) `(first ,w))
(defmacro child-name (w) `(second ,w))

(defun main ()
  (with-open-file (t27 "~/projects/bmfbp/svg/js-compiler/temp27.lisp" :direction :input)
    (let ((whole (read t27))
          (hashmap (make-hash-table))
          (source-ids (make-hash-table))
          (source-names (make-hash-table))
          (sink-ids (make-hash-table))
          (sink-names (make-hash-table))
          (out *standard-output*))

      ;; top level hashmap contains component Name, Metadata, Wirecount and Wires
      (@loop
        (@exit-when (null whole))
        (setf (gethash (first whole) hashmap)
              (second whole))
        (pop whole)
        (pop whole))







      (let ((wire-list (gethash 'wires hashmap)))
        (@loop
          (@exit-when (null wire-list))
          

          (let ((wire (first wire-list)))
            (let ((id (wire-id wire))
                  (name
            (setf (gethash 
            )
          (pop wire-list)))

        (let ((wcount (length wire-list))
              (i 0))
          (@loop
            (@exit-when (> i wcount))
            (setf (gethash 
            (incf i))
      )))

#|
    {
      "partname" : " js_test6_emitter",
      "wireCount" : 6,
      "metadata" : [...],
      "self" : {
          "partName" : "self",
          "kindName" : "js_test6_emitter",
          "inCount" : 1,
          "outCount" : 1,
          "inPins" :  [[],[],[],[wire 0],[],[]],
          "outPins" : [[],[],[],[],[],[wire 5]]
        },
        "parts" : [
          {
            "kindName" : "assign_wire_numbers_to_inputs",
            "partName" : "ID397",
            "inCount"  : ,
            "outCount" : ,
            "inPins"   : ,
            "outPins"  : ,
          },
          {
            "kindName" : "assign_wire_numbers_to_output",
            "partName" : "ID397",
            "inCount"  : ,
            "outCount" : ,
            "inPins"   : ,
            "outPins"  : ,
          },
          {
            "kindName" : "assign_port_indices",
            "partName" : "ID374",
            "inCount"  : ,
            "outCount" : ,
            "inPins"   : ,
            "outPins"  : ,
          },
          {
            "kindName" : "emit",
            "partName" : "ID369",
            "inCount"  : ,
            "outCount" : ,
            "inPins"   : ,
            "outPins"  : ,
          }
        ]
      }
    }
|#

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