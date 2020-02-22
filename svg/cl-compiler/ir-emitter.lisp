(in-package :arrowgrams/compiler)

(defclass ir-emitter (e/part:code) ())
(defmethod e/part:busy-p ((self ir-emitter)) (call-next-method))
(defmethod e/part:clone ((self ir-emitter)) (call-next-method))
; (:code IR-EMITTER (:fb :go) (:ir :basename :add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self ir-emitter))
  (@set self :state :idle))

(defmethod e/part:react ((self ir-emitter) e)
  (let ((pin (e/event::sym e))
        (data (e/event:data e)))
    (ecase (@get self :state)
      (:idle
       (if (eq pin :fb)
           (@set self :fb data)
         (if (eq pin :go)
             (progn
               (@send self :request-fb t)
               (@set self :state :waiting-for-new-fb))
           (@send
            self
            :error
            (format nil "EMITTER in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (@set self :fb data)
             (format *standard-output* "~&emitter~%")
             (emitter self)
             (@send self :done t)
             (@set self :state :idle))
         (@send
          self
          :error
          (format nil "EMITTER in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod emitter ((self ir-emitter))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (@get self :fb)))
        (parts (make-hash-table :test 'equal))
        (wires nil)
        (ellipses nil))

    (let ((goal '((:match_top_name (:? N)))))
      (let ((result (arrowgrams/compiler/util::run-prolog self goal fb)))
        (unless (and (listp result) (= 1 (length (car result))))
          (error "~&rule :match_top-name failed"))
        (let ((top-name (cdr (assoc 'N (car result)))))
          (let ((goal '((:fetch_metadata (:? ID) (:? TextID) (:? Str)))))
            (let ((result (arrowgrams/compiler/util::run-prolog self goal fb)))
              (let (( metadata (cdr (assoc 'Str (car result))))
                    (inputs nil)
                    (outputs nil))
                (let ((goal '((:find_self_input_pins (:? PortID) (:? Strid)))))
                  (let ((results (arrowgrams/compiler/util::run-prolog self goal fb)))
                    (dolist (result results)
                      (let ((id (cdr (assoc 'PortID result)))
                            (strid (cdr (assoc 'Strid result))))
                        (declare (ignore id))
                        (pushnew strid inputs)))))
                (let ((goal '((:find_self_output_pins (:? PortID) (:? Strid)))))
                  (let ((results (arrowgrams/compiler/util::run-prolog self goal fb)))
                    (dolist (result results)
                      (let ((id (cdr (assoc 'PortID result)))
                            (strid (cdr (assoc 'Strid result))))
                        (declare (ignore id))
                        (pushnew strid outputs)))))
                (setf (gethash :self parts) `(:id self :name ,top-name :metadata ,metadata :inputs ,inputs :outputs ,outputs)))))

          (let ((goal '((:find_ellipse (:? E)))))
            (let ((result (arrowgrams/compiler/util::run-prolog self goal fb)))
              (mapc #'(lambda (lecons)
                        (assert (and (listp lecons) (= 1 (length lecons))))
                        (let ((econs (car lecons)))
                          (pushnew (cdr econs) ellipses)))
                    result)))
          
          (let ((goal '((:find_parts (:? ID) (:? Strid)))))
            (let ((results (arrowgrams/compiler/util::run-prolog self goal fb)))
              (dolist (result results)
                (let ((id (cdr (assoc 'ID result)))
                      (str (cdr (assoc 'Strid result))))
                  (setf (gethash id parts) `(:id ,id :kind ,str))))))
          
          
          (let ((goal '((:find_part_input_pins (:? RectID) (:? PortID) (:? Strid)))))
            (let ((results (arrowgrams/compiler/util::run-prolog self goal fb)))
              (dolist (result results)
                (let ((rectid (cdr (assoc 'RectID result)))
                      (PortID (cdr (assoc 'PortID result)))
                      (strid (cdr (assoc 'Strid result))))
                  (declare (ignore PortID))
                  (let ((plist (gethash rectid parts)))
                    (let ((inputs (getf plist :inputs))
                          (outputs (getf plist :outputs))
                          (id (getf plist :id))
                          (kind (getf plist :kind)))
                      (setf (gethash rectid parts) `(:id ,rectid :kind ,kind :inputs ,(pushnew strid inputs) :outputs ,outputs))))))))
          
          (let ((goal '((:find_part_output_pins (:? RectID) (:? PortID) (:? Strid)))))
            (let ((results (arrowgrams/compiler/util::run-prolog self goal fb)))
              (dolist (result results)
                (let ((rectid (cdr (assoc 'RectID result)))
                      (PortID (cdr (assoc 'PortID result)))
                      (strid (cdr (assoc 'Strid result))))
                  (declare (ignore PortID))
                  (let ((plist (gethash rectid parts)))
                    (let ((id (getf plist :id))
                          (kind (getf plist :kind))
                          (inputs (getf plist :inputs))
                          (outputs (getf plist :outputs)))
                      (setf (gethash rectid parts) `(:id ,id :kind ,kind :inputs ,inputs :outputs ,(pushnew strid outputs)))))))))
          
          (let ((goal '((:find_wire (:? RectID1) (:? PortID1) (:? PortName1) (:? RectID2) (:? PortID2) (:? PortName2)))))
            (let ((results (arrowgrams/compiler/util::run-prolog self goal fb))
                  (edges nil))
              (dolist (result results)
                (let ((rectid1 (cdr (assoc 'RectID1 result)))
                      (PortID1 (cdr (assoc 'PortID1 result)))
                      (name1 (cdr (assoc 'PortName1 result)))
                      (rectid2 (cdr (assoc 'RectID2 result)))
                      (PortID2 (cdr (assoc 'PortID2 result)))
                      (name2 (cdr (assoc 'PortName2 result))))
                  (let ((id1 (replace-ellipse rectid1 ellipses))
                        (id2 (replace-ellipse rectid2 ellipses)))
                    (let ((edge `(,id1 ,name1 ,id2 ,name2)))
                      (push edge edges)))))
              
              (let ((wires (insert-wire-number (collapse-fan-out edges))))
                
                (let ((self-plist (gethash :self parts)))
                  (let (( final `(,(symbol-name (getf self-plist :name))
                                  ,(getf self-plist :metadata)
                                  ,(getf self-plist :inputs)
                                  ,(getf self-plist :outputs)
                                  "react"
                                  "first-time"
                                  ,(make-parts-list parts) ,wires)))
                    (let ((filename (asdf:system-relative-pathname :arrowgrams (format nil "svg/cl-compiler/~a.ir" top-name)))) ;; redundant write ir to file for debug
                      (with-open-file (f filename :direction :output :if-exists :supersede)
                        (let ((*print-right-margin* 120))
                          (pprint final f)))
                      (@send self :basename top-name)
                      (@send self :ir final))))))))))))

(defun replace-ellipse (id ellipse-list)
  (if (member id ellipse-list)
      "self"
    (symbol-name id)))

(defun make-parts-list (parts-hash)
  (let ((result nil))
    (delete nil (maphash #'(lambda (key plist)
                             (if (eq key :self)
                                 nil
                               (let ((id (getf plist :id))
                                     (kind (getf plist :kind))
                                     (inputs (getf plist :inputs))
                                     (outputs (getf plist :outputs)))
                                 (push (list (stringify key) kind inputs outputs "react" "first-time") result))))
                         parts-hash))
    result))

(defun stringify (x)
  (symbol-name x))

(defclass memo-bag ()
  ((seen-cons-list :initform nil :accessor seen-cons-list)))

(defmethod seen-p ((self memo-bag) part pin)
  (member-if #'(lambda (cns)
                 (and (eq (car cns) part)
                      (eq (cdr cns) pin)))
             (seen-cons-list self)))

(defmethod memorize ((self memo-bag) part pin)
  (push (cons part pin) (seen-cons-list self)))

(defun return-all-matching-edge-sinks (edge-list part pin)
  (delete nil
          (mapcar #'(lambda (edge)
                      (if (and (eq part (first edge))
                               (eq pin (second edge)))
                          (list (third edge) (fourth edge))
                        nil))
                  edge-list)))
                               
(defun collapse-fan-out (edges)
  ;; combine all edges into one, that have the same source part+pin
  ;;return a list of lists ((source-part source-pin) ((sink-part sink-pin) (sink-part sink-pin) ...))
  (let ((result nil)
        (edge-list edges)
        (memo (make-instance 'memo-bag)))
    (@:loop
      (@:exit-when (null edge-list))
      (let ((edge (pop edge-list)))
        (let ((source-part (first edge))
              (source-pin  (second edge)))
          ;(format *standard-output* "~&source-part ~S source-pin~S~%" source-part source-pin)
          (when (not (seen-p memo source-part source-pin))
            (memorize memo source-part source-pin)
            (let ((wire (return-all-matching-edge-sinks edges source-part source-pin)))
              (push (list (list (list source-part source-pin)) wire)
                    result))))))
    result))

              
(defun insert-wire-number (wires)
  (let ((i -1))
    (let ((result (mapcar #'(lambda (w)
                              (incf i)
                              (cons i w))
                          wires)))
      result)))
      

