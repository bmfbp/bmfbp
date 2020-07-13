(in-package :e/schematic)

(defun new-schematic (&key (name "") (input-pins nil) (output-pins nil) (first-time-handler nil))
  (let ((self (make-instance 'e/part:schematic :debug-name name :input-handler #'e/schematic::schematic-input-handler)))
    (setf (e/part:namespace-input-pins self) (e/part::make-in-pins self input-pins))
    (setf (e/part:namespace-output-pins self) (e/part::make-out-pins self output-pins))
    #+nil(setf (e/part:first-time-handler self) first-time-handler)
    self))

(defmethod ensure-source-not-already-present ((self e/part:schematic) (s e/source:source))
  (e/util:ensure-not-in-list (e/part:sources self) s #'equal
                             "source ~S already present in schematic ~S" s (e/part::debug-name self)))

(defmethod add-source ((self e/part:schematic) (s e/source:source))
  (push s (e/part:sources self)))

(defmethod add-source-with-ensure ((self e/part:schematic) (s e/source:source))
    (ensure-source-not-already-present self s)
    (add-source self s))

(defmethod set-source-list ((self e/part:schematic) lis)
  (setf (e/part:sources self) lis))

(defmethod ensure-part-not-already-present ((self e/part:schematic) (p e/part:part))
  (e/util:ensure-not-in-list (e/part:internal-parts self) p #'equal
                             "part ~S already present in schematic ~S" p (e/part::debug-name self)))

(defmethod add-part ((self e/part:schematic) (p e/part:part))
  (setf (e/part:parent-schem p) self)
  (push p (e/part:internal-parts self)))

(defmethod lookup-source-in-parent ((parent e/part:schematic) (self e/part:part) (e e/event:event))
  ;; find part-pin in parent's source list
  (dolist (s (e/part:sources parent))
    (when (e/source::source-pin-equal s (e/event:event-pin e))
      (return-from lookup-source-in-parent s)))
  nil) ;; NC (no connection)

(defmethod lookup-source-in-self ((self e/part:schematic) (e e/event:event))
  ;; find part-pin in self's source list
    (dolist (s (e/part:sources self))
      (when (e/source::source-pin-equal s (e/event:event-pin e))
        (return-from lookup-source-in-self s)))
    (let ((ipin (e/part::get-input-pin self (e/event::sym e))))
      (unless ipin ;; ipin N/C
        (error "input pin ~a not found in schematic ~s" (e/event::sym e) self)))) ;; shouldn't happen


(defmethod schematic-input-handler ((self e/part:schematic) (e e/event:event))
  (let ((s (lookup-source-in-self self e)))
    (when s
      (e/source::source-event s e))))

(defmethod ensure-sanity ((self e/part:schematic) (part e/part:part))
  (unless (eq self part)
    (e/util:ensure-in-list (e/part:internal-parts self) part #'equal
                           "part ~S does not appear in its parent schematic ~S (check parts-list of schematic)" (e/part::debug-name part) (e/part::debug-name self))))

(defmethod ensure-source-sanity ((self e/part:schematic))
  (mapc
   #'(lambda (source)
       (e/source::ensure-source-sanity self source))
   (e/part:sources self)))

(defmethod e/part:first-time ((self e/part:schematic))
  (declare (ignore self))
  )

(defmethod e/part:react ((self e/part:schematic) (e e/event:event))
  (schematic-input-handler self e))

