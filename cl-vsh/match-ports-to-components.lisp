;;; Copyright (c) 2012, Paul Tarvydas
;;; All rights reserved.

;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions
;;; are met:

;;;    Redistributions of source code must retain the above copyright
;;;    notice, this list of conditions and the following disclaimer.

;;;    Redistributions in binary form must reproduce the above
;;;    copyright notice, this list of conditions and the following
;;;    disclaimer in the documentation and/or other materials provided
;;;    with the distribution.

;;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
;;; CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
;;; INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
;;; MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
;;; DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
;;; BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
;;; EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
;;; TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
;;; DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
;;; ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
;;; TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
;;; THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
;;; SUCH DAMAGE.

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
