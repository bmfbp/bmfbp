#|
Part=id373 in  PortID=id382 WireIndex=1 Pin=0
Part=id373 in  PortID=id377 WireIndex=0 Pin=3
Part=id369 out PortID=id381 WireIndex=1 Pin=1
Part=id371 out PortID=id376 WireIndex=0 Pin=1
|#

;;; mechanisms
(defparameter %script% nil)
(defparameter %table% nil)

(defun @read-script-from-file ()
  (with-open-file (f "/Users/tarvydas/projects/bmfbp/svg/compiler/temp.lisp" :direction :input)
    (setf %script% (read f)))) ;; TODO: needs more error checking
    
(defun @create-parts-table ()
  (setf %table% (make-hash-table)))

(defun @preamble ()
  (format *standard-output* "{~%  \"name\" : ~S,~%" (getf %script% 'name))
  (format *standard-output* "  \"wirecount\" : ~d,~%" (getf %script% 'wirecount))
  (format *standard-output* "  \"parts\" : [~%"))

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

(defun @emit-parts ()
  (let ((first t))
    (maphash #'(lambda (key val)
                 (unless first
                   (format *standard-output* ",~%"))
                 (setf first nil)
                 (format *standard-output* "    {~%")
                   (format *standard-output* "      \"partName\" : \"~S\",~%" key)
                   (format *standard-output* "      \"exec\" : ~S~%" (gethash :exec val))
                 (format *standard-output* "    }"))
             %table%)))

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
      (multiple-value-bind (part-id port-id wire-index pin-index) in
        (@add-part-tuple-to-input-list part-id port-id wire-index pin-index)))))

(defun @make-outputs-for-each-part ()
  ;; for each part in the table, add a list of inputs ; each input is a tuple {port-id, wire-index, input-pin-index}
  (let ((output-list (getf (getf %script% 'parts) 'outs)))
    (dolist (out output-list)
      (multiple-value-bind (part-id port-id wire-index pin-index) out
        (@add-part-tuple-to-output-list part-id port-id wire-index pin-index)))))

(defun @get-max-pin (pin-list)
  (let ((max-so-far 0))
    (dolist (tuple pin-list)
      (multiple-value-bind (port-id wire-index pin-index) tuple (declare (ignore port-id wire-index))
        (setf max-so-far (max max-so-far pin-index))))
    max-so-far))

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


;;; end mechanisms


(defun test ()
  (@read-script-from-file)
  (@create-parts-table)
  (@preamble)
    (@put-parts-into-table)
    (@put-part-execs-into-table)
    (@make-inputs-for-each-part)
    (@compute-number-of-input-pins-for-each-part)
    (@make-outputs-for-each-part)
    (@compute-number-of-output-pins-for-each-part)
    (@emit-parts)
  (@postamble)
  (values))


#|
  (with-open-file (f "/Users/tarvydas/projects/bmfbp/svg/compiler/temp.lisp" :direction :input) 
    (let ((script (read f))
          (table (make-hash-table))) ;; part: id..execs
      (process-execs table script)
      (format *standard-output* "{~%  \"name\" : ~S,~%" (getf script 'name))
      (format *standard-output* "  \"wirecount\" : ~d,~%" (getf script 'wirecount))
      (format *standard-output* "  \"parts\" : [~%")
      (maphash #'(lambda (id plist)
                   (declare (ignorable id))
                   (format *standard-output* "key=~S plist=~A~%" id plist)
                   (format *standard-output* "  {~%")
                   (format *standard-output* "    \"exec\" : ~S,~%" (getf plist 'exec))
                   (format *standard-output* "  },~%"))
               table)
      (format *standard-output* "  ]~%")
      (format *standard-output* "}~%"))))

(defun process-execs (table script)
  ;; side-effect: modifies table to contain one exec function for each part
  (let ((parts (getf script 'parts))
    (let ((execs (getf parts 'execs)))
      (format *standard-output* "execs=~S~%" execs)
      (mapc #'(lambda (part-pair)
                (setf (getf (first part-pair) table) ;; part id
                      (list 'exec (second part-pair)))) ;; exec function
            execs))))

|#

  