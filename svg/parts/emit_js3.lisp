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
  (let ((md (getf %script% 'metadata)))
    (when md
      (format *standard-output* "  \"metadata\" : ~d,~%" md)))
  (format *standard-output* "  \"self\" : "))

(defun @preamble-for-children-parts ()
  (format *standard-output* "~%  \"parts\" : [~%"))

(defun @postamble ()
  (format *standard-output* "~%  ]~%")
  (format *standard-output* "}~%"))

(defun @must-not-exist-in-table (id)
  (when (gethash id %table%)
    (die (format nil "part (~A) defined more than once~%" id))))

(defun @must-exist-in-table (id)
  (multiple-value-bind (val success)
      (gethash id %table%)
    (declare (ignore val))
    (unless success
      (die (format nil "part ~A not defined~%" id)))))

(defun @put-part-in-table (id)
  ;; at each part-id, there is a hash table with 6 keys: id, exec, ins-enumeration, outs-enumeration, ins (list), outs (list)
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

(defun iota (n) 
  (declare (integer n))
  (let ((result nil))
    (dotimes (i n)
      (push i result))
    (reverse result)))

(defun positive-maximum (lis)
  (let ((r 0))
    (mapc #'(lambda(x)
	      (when (> x r)
		(setf r x)))
	  lis)
    r))
	  
(defun every-item-is-a-number-p (lis)
  (let ((result t))
    (dolist (item lis)
      (unless (numberp item)
	(setf result nil)))
    result))

(defun @get-pin-enumeration (pin-list)
  (let ((pin-ids (mapcar #'(lambda (pin-descriptor)
			      (third pin-descriptor))
			  pin-list)))
    (if (every-item-is-a-number-p pin-ids)
	(iota (positive-maximum pin-ids))
	pin-ids)))

(defun @compute-number-of-input-pins-for-each-part ()
  ;; set the ins-enumeration hashtable field for each part
(maphash #'(lambda (part-id properties-hash)
	     (declare (ignore part-id))
             (let ((enumeration (@get-pin-enumeration (gethash :ins properties-hash))))
               (setf (gethash :ins-enumeration properties-hash) enumeration)))
         %table%))

(defun @compute-number-of-output-pins-for-each-part ()
  ;; set the outs-enumeration hashtable field for each part
  (maphash #'(lambda (part-id properties-hash) (declare (ignore part-id))
               (let ((enumeration (@get-pin-enumeration (gethash :outs properties-hash))))
                 (setf (gethash :outs-enumeration properties-hash) enumeration)))
           %table%))

(defun as-json-map (name-list)
  (let ((first-time t)
	(i 0))
    (with-output-to-string (s)
      (format s "{ ")
      (@loop
       (@exit-when (null name-list))
       (unless first-time
	 (format s ", "))
       (setf first-time nil)
       (format s "~S : ~S" (first name-list) i)
       (incf i)
       (pop name-list))
      (format s " }"))))

(defun emit-parts (&key self)
  (labels ((emit-wires-for-pin (pin-id pinlist)
             (let ((first t))
               (mapc #'(lambda (tuple)
                         (destructuring-bind (port wire pin)
                             tuple
                           (declare (ignore port))
                           (when (eq pin-id pin)
                             (unless first
                               (format *standard-output* ","))
                             (setq first nil)
                             (format *standard-output* "~a" wire))))
                     pinlist)))
           (emit-pin-list (pin-name-enumeration pinlist)
             (let ((first t))
                 (dolist (pin-id pin-name-enumeration)
                   (unless first
                     (format *standard-output* ","))
                   (setq first nil)
                   (format *standard-output* "[")
                   (emit-wires-for-pin pin-id pinlist)
                   (format *standard-output* "]"))))
           (emit-ins (properties)
             (let ((ins (gethash :ins properties))
                   (enumeration (gethash :ins-enumeration properties)))
               (format *standard-output* "      \"inPins\" : [")
               (emit-pin-list enumeration ins)
               (format *standard-output* "],~%")))
           (emit-outs (properties)
             (let ((outs (gethash :outs properties))
                   (enumeration (gethash :outs-enumeration properties)))
               (format *standard-output* "      \"outPins\" : [")
               (emit-pin-list enumeration outs)
               (format *standard-output* "],~%")))
           (emit-pins (properties)
             (format *standard-output* "      \"inCount\" : ~A,~%" (length (gethash :ins-enumeration properties)))
             ;(format *standard-output* "      \"inOrdering\" : ~A,~%" (as-json-map (gethash :ins-enumeration properties)))
             (format *standard-output* "      \"outCount\" : ~A,~%" (length (gethash :outs-enumeration properties)))
             ;(format *standard-output* "      \"outOrdering\" : ~A,~%" (as-json-map (gethash :outs-enumeration properties)))
             (emit-ins properties)
             (emit-outs properties))
           (emit-self-pins (properties)
             (format *standard-output* "      \"inCount\" : ~A,~%" (length (gethash :ins-enumeration properties)))
             ;(format *standard-output* "      \"inOrdering\" : ~A,~%" (as-json-map (gethash :ins-enumeration properties)))
             (format *standard-output* "      \"outCount\" : ~A,~%" (length (gethash :outs-enumeration properties)))
             ;(format *standard-output* "      \"outOrdering\" : ~A,~%" (as-json-map (gethash :outss-enumeration properties)))
             (emit-ins properties)
             (emit-outs properties))
           (emit-part (part-id val)
	     (let ((self-p (eq 'self part-id)))
               (if self-p
		   (format *standard-output* "{~%")
		  (format *standard-output* "    {~%"))
               (format *standard-output* "      \"partName\" : \"~S\",~%" part-id)
               (if self-p
		   (emit-self-pins val)
		  (emit-pins val))
               (format *standard-output* "      \"kindName\" : ~S~%" (gethash :exec val))
             (format *standard-output* "    }"))))
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

(defun main1 ()
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

#-lispworks
(defun main (argv)
  (declare (ignore argv))
  (handler-case
      (progn
	  (main1))
    (end-of-file (c)
      (format *error-output* "FATAL 'end of file error' in emit_js3 /~S/~%" c))
    (simple-error (c)
      (format *error-output* "FATAL error b in emit_js3 /~S/~%" c))
    (error (c)
      (format *error-output* "FATAL error c in emit_js3 /~S/~%" c))))


#+lispworks
(defun main ()
  (main1))
  
