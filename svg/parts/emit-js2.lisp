;;; mechanisms
(defparameter %script% nil)
(defparameter %table% nil)

(defun @read-script-from-file ()
  (setf %script% (read *standard-input*))) ;; TODO: needs more error checking
    
(defun @create-parts-table ()
  (setf %table% (make-hash-table)))

(defun @preamble ()
  (format *standard-output* "{~%  \"name\" : ~S,~%" (getf %script% 'name))
  (format *standard-output* "  \"wirecount\" : ~d,~%" (getf %script% 'wirecount))
  (format *standard-output* "  \"self\" : ~%"))

(defun @preamble-for-children-parts ()
  (format *standard-output* "~%  \"parts\" : [~%"))

(defun @postamble ()
  (format *standard-output* "~%  ]~%")
  (format *standard-output* "}~%"))

(defun @must-not-exist-in-table (id)
  (when (gethash id %table%)
    (error "part (~A) defined more than once~%" id)))

(defun @must-exist-in-table (id)
  (multiple-value-bind (val success)
      (gethash id %table%)
    (declare (ignore val))
    (unless success
      (error "part ~A not defined~%" id))))

(defun @put-part-in-table (id)
  ;; at each part-id, there is a hash table with 6 keys: id, exec, ins-max, outs-max, ins (list), outs (list)
  (let ((ht (make-hash-table)))
    (setf (gethash :id ht) id
          (gethash :exec ht) nil
          (gethash :ins ht) nil
          (gethash :outs ht) nil)
    (setf (gethash id %table%) ht)))

(defun @put-parts-into-table ()
  (let ((parts (getf %script% 'parts)))
    (let ((execs (getf parts 'execs)))
      (mapc #'(lambda (part-pair)
                (let ((part-id (first part-pair))
                      (part-exec (second part-pair)))
                  (declare (ignorable part-exec))
                  (@must-not-exist-in-table part-id)
                  (@put-part-in-table part-id)))
            execs))))

(defun @put-exec-into-table (id exec-function)
  (@must-exist-in-table id)
  (let ((ht (gethash id %table%)))
    (setf (gethash :exec ht) exec-function)))

(defun @put-part-execs-into-table ()
  (let ((parts (getf %script% 'parts)))
    (let ((execs (getf parts 'execs)))
      (mapc #'(lambda (part-pair)
                (let ((part-id (first part-pair))
                      (part-exec (second part-pair)))
                  (@must-exist-in-table part-id)
                  (@put-exec-into-table part-id part-exec)))
            execs))))

(defun @add-part-tuple-to-input-list (part-id port-id wire-index pin-index)
  (@must-exist-in-table part-id)
  (let ((part-ht (gethash part-id %table%))
        (new-tuple (list port-id wire-index pin-index)))
    (let ((old-list (gethash :ins part-ht)))
      (setf (gethash :ins part-ht)
            (cons new-tuple old-list)))))
  
(defun @add-part-tuple-to-output-list (part-id port-id wire-index pin-index)
  (@must-exist-in-table part-id)
  (let ((part-ht (gethash part-id %table%))
        (new-tuple (list port-id wire-index pin-index)))
    (let ((old-list (gethash :outs part-ht)))
      (setf (gethash :outs part-ht)
            (cons new-tuple old-list)))))
  
                 
(defun @make-inputs-for-each-part ()
  ;; for each part in the table, add a list of inputs ; each input is a tuple {port-id, wire-index, input-pin-index}
  (let ((input-list (getf (getf %script% 'parts) 'ins)))
    (dolist (in input-list)
      (destructuring-bind (part-id port-id wire-index pin-index) in
        (@add-part-tuple-to-input-list part-id port-id wire-index pin-index)))))

(defun @make-outputs-for-each-part ()
  ;; for each part in the table, add a list of inputs ; each input is a tuple {port-id, wire-index, input-pin-index}
  (let ((output-list (getf (getf %script% 'parts) 'outs)))
    (dolist (out output-list)
      (destructuring-bind (part-id port-id wire-index pin-index) out
        (@add-part-tuple-to-output-list part-id port-id wire-index pin-index)))))

(defun @get-max-pin (pin-list)
  (let ((max-so-far -1))
    (dolist (tuple pin-list)
      (destructuring-bind (port-id wire-index pin-index) tuple (declare (ignore port-id wire-index))
        (setf max-so-far (max max-so-far pin-index))))
    (1+ max-so-far)))

(defun @compute-number-of-input-pins-for-each-part ()
  ;; set the ins-max hashtable field for each part
  (maphash #'(lambda (part-id properties-hash) (declare (ignore part-id))
               (let ((max-pin (@get-max-pin (gethash :ins properties-hash))))
                 (setf (gethash :ins-max properties-hash) max-pin)))
           %table%))

(defun @compute-number-of-output-pins-for-each-part ()
  ;; set the ins-max hashtable field for each part
  (maphash #'(lambda (part-id properties-hash) (declare (ignore part-id))
               (let ((max-pin (@get-max-pin (gethash :outs properties-hash))))
                 (setf (gethash :outs-max properties-hash) max-pin)))
           %table%))

(defun emit-parts (&key self)
  (labels ((emit-wires-for-pin (i pinlist)
             (let ((first t))
               (mapc #'(lambda (tuple)
                         (destructuring-bind (port wire pin)
                             tuple
                           (declare (ignore port))
                           (when (= i pin)
                             (unless first
                               (format *standard-output* ","))
                             (setq first nil)
                             (format *standard-output* "~a" wire))))
                     pinlist)))
           (emit-pin-list (count pinlist)
             (let ((first t))
                 (dotimes (i count)
                   (unless first
                     (format *standard-output* ","))
                   (setq first nil)
                   (format *standard-output* "[")
                   (emit-wires-for-pin i pinlist)
                   (format *standard-output* "]"))))
           (emit-ins (properties)
             (let ((ins (gethash :ins properties))
                   (count (gethash :ins-max properties)))
               (format *standard-output* "      \"inPins\" : [")
               (emit-pin-list count ins)
               (format *standard-output* "],~%")))
           (emit-outs (properties)
             (let ((outs (gethash :outs properties))
                   (count (gethash :outs-max properties)))
               (format *standard-output* "      \"outPins\" : [")
               (emit-pin-list count outs)
               (format *standard-output* "],~%")))
           (emit-input-pins (properties)
             (format *standard-output* "      \"in-count\" : ~A,~%" (gethash :ins-max properties))
             (format *standard-output* "      \"out-count\" : ~A,~%" (gethash :outs-max properties))
             (emit-ins properties)
             (emit-outs properties))
           (emit-pins (properties)
             (emit-input-pins properties))
           (emit-part (part-id val)
             (format *standard-output* "    {~%")
               (format *standard-output* "      \"partName\" : \"~S\",~%" part-id)
               (emit-pins val)
               (format *standard-output* "      \"exec\" : ~S~%" (gethash :exec val))
             (format *standard-output* "    }")))
    (let ((first t))
      (labels ((emit (part-id val)
                    (unless first
                      (format *standard-output* ",~%"))
                    (setf first nil)
                    (emit-part part-id val)))
	(maphash #'(lambda (part-id val)
		     (if (and self (eq 'self part-id))
			 (emit part-id val)
			 (when (and (not self) 
				    (not (eq 'self part-id)))
			   (emit part-id val))))
		 %table%)))))

(defun @emit-self-part ()
  (emit-parts :self t))

(defun @emit-children-parts ()
  (emit-parts :self nil))



;;; end mechanisms

(defun main (argv)
  (declare (ignore argv))
  (@read-script-from-file)
  (@create-parts-table)
  (@preamble)
    (@put-parts-into-table)
    (@put-part-execs-into-table)
    (@make-inputs-for-each-part)
    (@compute-number-of-input-pins-for-each-part)
    (@make-outputs-for-each-part)
    (@compute-number-of-output-pins-for-each-part)
    (@emit-self-part)
    (@preamble-for-children-parts)
    (@emit-children-parts)
  (@postamble)
  (values))
