#|
Part=id373 in  PortID=id382 WireIndex=1 Pin=0
Part=id373 in  PortID=id377 WireIndex=0 Pin=3
Part=id369 out PortID=id381 WireIndex=1 Pin=1
Part=id371 out PortID=id376 WireIndex=0 Pin=1
|#

;;; mechanisms
(defmacro @with-handles (handle-list @body body)
  `(let ,handle-list
     ,@body))

(defmacro @create-script-from-file-into (script-handle)
  `(with-open-file (f "/Users/tarvydas/projects/bmfbp/svg/compiler/temp.lisp" :direction :input) 
    (setf ,script-handle (read f)))) ;; TODO: needs more error checking
    
(defmacro @create-hash-table-into (table-handle)
  `(setf ,table-handle (make-hash-table))

(defmacro @must-not-exist (id table-handle)
  `(when (gethash ,table-handle ,id)
    (error "part (~A) defined more than once~%" ,id)))

(defmacro @put-part-in-table (id table-handle)
  ;; at each part-id, there 3 properties: exec, ins (list), outs (list)
  (setf (gethash ,id ,table-handle) nil))

(defmacro @put-parts-list-into-table (table-handle script-handle)
  `(let ((parts (getf ,script-handle 'parts)))
     (let ((execs (getf parts 'execs)))
       (mapc #'(lambda (part-pair)
                 (let ((part-id (first part-pair))
                       (part-exec (second part-pair)))
                   (declare (ignorable part-exec))
                   (@must-not-exist-in-table part-id table-handle)
                   (@put-part-in-table part-id table-handle)))
             execs))))

(defmacro @put-exec-into-table (id exec table-handle)
  `(push (gethash ,id ,table-handle)
         `(exec ,exec)))

(defmacro @put-part-execs-into-table (table-handle script-handle)
  `(let ((parts (getf ,script-handle 'parts)))
     (let ((execs (getf parts 'execs)))
       (mapc #'(lambda (part-pair)
                 (let ((part-id (first part-pair))
                       (part-exec (second part-pair)))
                   (@must-not-exist-in-table part-id table-handle)
                   (@put-exec-into-table part-id part-exec table-handle)))
             execs))))

(defun test ()
  (@with-handles (%script% %table%)
    (@create-script-from-file-into %script%)
    (@create-hash-table-into %table%)
    (@put-parts-list-into-table %table% %script%)
    (@put-part-execs-into %table% %script%)))


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
  