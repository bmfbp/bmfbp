(load "io.lisp")

(declaim (ftype function port-intersects-with intersects))

(defun match-ports-to-components (facts)
  (maphash #'(lambda (id info)
               (when-match (ty 'type info)
                   (when (eq (obj ty) 'port)
                     (when-match (bounds 'bounds info)
                         (let ((matches (port-intersects-with bounds facts)))
                           (cond ((= 1 (length matches))
                                  (let-match (input 'sink info)
                                      (let* ((parent (first matches))
                                             (parent-info (gethash parent facts))
                                             (kind (if input 'input 'output)))
                                        (setf (gethash 'parent info) (list 'parent id parent))
                                        (push-obj kind parent id parent-info))))
                                 ((< (length matches) 1)
                                  (vsherror "port ~A (~a) does not intersect with any component"
                                            (when-match (name-fact 'name info) (obj name-fact)) id))
                                 (t (vsherror "port ~a (~a) intersects with more than one component"
                                              (when-match (name-fact 'name info) (obj name-fact)) id))))))))
           facts))

(defun port-intersects-with (port-bounds facts)
  ;; return a list of all box id's that this port intersects with
  (let ((result nil))
    (maphash #'(lambda (box-id info)
                 (when-match (ty 'type info)
                   (when (eq (obj ty) 'box)
                     (when-match (box-bounds 'bounds info)
                       (when (intersects port-bounds box-bounds)
                         (push box-id result))))))
             facts)
    result))

(defun inside (x y lb tb rb bb)
  (and (<= x rb) (>= x lb) (<= y bb) (>= y tb)))

(defun intersects (port-bounds box-bounds)
  (destructuring-bind (ty box-id lb tb rb bb) box-bounds
    (declare (ignorable ty box-id))
    (destructuring-bind (typ port-id left top right bottom) port-bounds
      (declare (ignorable typ port-id))
      (or (inside left top lb tb rb bb)
          (inside right top lb tb rb bb)
          (inside left bottom lb tb rb bb)
          (inside right bottom lb tb rb bb)))))

(defun main (argv)
  (declare (ignorable argv))
  (read-write-facts #'match-ports-to-components *standard-input* *standard-output*)
  0)

;(main)
