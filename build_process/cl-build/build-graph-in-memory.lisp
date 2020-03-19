(in-package :arrowgrams/build)

(defparameter *script* nil)

(defclass build-graph-in-memory (builder) 
  ((kinds-by-name :accessor kinds-by-name)
   (code-stack :accessor code-stack)))

(defmethod e/part:busy-p ((self build-graph-in-memory))
  (call-next-method))

(defmethod e/part:clone ((self build-graph-in-memory))
  (call-next-method))

(defmethod e/part:first-time ((self build-graph-in-memory))
  (setf (kinds-by-name self) (make-hash-table :test 'equal))
  (setf (code-stack self) nil))

(defmethod e/part:react ((self build-graph-in-memory) e)
  ;(format *standard-output* "~&build-graph-in-memory gets ~s ~s~%" (@pin self e) (chop-str (@data self e)))
  (ecase (@pin self e)
    (:json-script
     (let ((script-as-alist (json-to-alist (@data self e))))
       (push script-as-alist (code-stack self))))

    (:done
     (dolist (script-as-alist (code-stack self))
       (setf *script* script-as-alist)
       (alist-to-graph self script-as-alist)))))

(defmethod alist-to-graph ((self build-graph-in-memory) code-chunks-as-alist)
  (dolist (a code-chunks-as-alist)
    (let ((item-kind (get-item-kind a))
          (name  (get-name a)))
      (if (string= "graph" item-kind)
          (build-graph-in-mem self name a)
        (build-leaf-in-mem self name a)))))





(defun get-name (alist)
  (cdr (assoc :name alist)))

(defun get-item-kind (alist)
  (cdr (assoc :item-kind alist)))

(defun get-graph (alist)
  (cdr (assoc :graph alist)))

(defun get-leaf (alist)
  (cdr (assoc :leaf alist)))

(defun get-inputs (graph-alist)
  (cdr (assoc :inputs graph-alist)))

(defun get-outputs (graph-alist)
  (cdr (assoc :outputs graph-alist)))

(defun get-parts-list (graph-alist)
  (cdr (assoc :parts graph-alist)))

(defun get-part-name (part-alist)
  (cdr (assoc :part-name part-alist)))

(defun get-part-kind (part-alist)
  (cdr (assoc :kind-name part-alist)))

(defun get-wiring (graph-alist)
  (cdr (assoc :wiring graph-alist)))

(defun get-wire-index (wire-alist)
  (cdr (assoc :wire-index wire-alist)))

(defun get-sources (wire-alist)
  (cdr (assoc :sources wire-alist)))

(defun get-destinations-list (wire-alist)
  (cdr (assoc :receivers wire-alist)))

(defun get-part (x)
  (string-downcase (cdr (assoc :part x))))

(defun get-pin (x)
  (string-downcase (cdr (assoc :pin x))))


(defmethod build-graph-in-mem ((self build-graph-in-memory) name full-graph)
  (let ((graph (get-graph full-graph))) ;; strip noise
    (let ((kind (make-instance 'kind)))
      (format *standard-output* "~&define graph name ~s~%" name)
      (setf (kind-name kind) name)
      (setf (gethash name (kinds-by-name self)) kind)
      (dolist (input-name (get-inputs graph))
        (add-input-pin kind input-name))
      (dolist (output-name (get-outputs graph))
        (add-output-pin kind output-name))
      (dolist (part-as-alist (get-parts-list graph))
        (let ((kind-name (string-downcase (get-part-kind part-as-alist)))
              (part-name (string-downcase (get-part-name part-as-alist))))
          (format *standard-output* "~&need name ~s~%" kind-name)
          (add-part kind part-name (gethash kind-name (kinds-by-name self)))))
      ;; the wiring table is an array [] of wires
      ;; each wire is defined by: 1. index, 2. (list of) sources, 3. (list of) destinations
      (dolist (wire-as-alist (get-wiring graph))
        (let ((w (make-instance 'wire)))
          (set-index w (get-wire-index wire-as-alist))
          (dolist (source (get-sources wire-as-alist))
            (add-source w (get-part source) (get-pin source)))
          (dolist (dest (get-destinations-list wire-as-alist))
            (add-destination w (get-part dest) (get-pin dest)))
          (add-wire kind w)))
      (setf (gethash name (kinds-by-name self)) kind)  ;; this should be per diagram/graph, not global
      kind)))

(defun get-file-name (a)
  (cdr (assoc :file-name a)))

(defun get-in-pins (a)
  (cdr (assoc :in-pins a)))

(defun get-out-pins (a)
  (cdr (assoc :out-pins a)))

(defmethod build-leaf-in-mem ((self build-graph-in-memory) manifest-name leaf-as-alist)
  (let ((name (string-downcase manifest-name)))
(format *standard-output* "~&define leaf name ~s~%" name)
    (let ((filename (get-file-name leaf-as-alist)))
      (let ((json-str (alexandria:read-file-into-string filename)))
        (let ((manifest-as-alist (json-to-alist json-str)))
          (let ((kind (make-instance 'kind))
                (in-pins (get-in-pins manifest-as-alist))
                (out-pins (get-out-pins manifest-as-alist)))
            (setf (kind-name kind) name)
            (dolist (ipin in-pins)
              (add-input-pin kind ipin))
            (dolist (opin out-pins)
              (add-output-pin kind opin))
            (setf (gethash name (kinds-by-name self)) kind)  ;; this should be per diagram/graph, not global
            leaf-as-alist ))))))
