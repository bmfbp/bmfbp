(defmacro @loop (&body body) `(loop ,@body))
(defmacro @exit-when (expr) `(when ,expr (return)))

(defmacro new-string-hashmap () `(make-hash-table :test 'equal))

(defmacro source-name (w) `(if (eq 'NULL (second ,w)) "self" (second ,w))) ;; part
(defmacro source-pin-name (w) `(third ,w)) ;; pin
(defmacro sink-name (w) `(if (eq 'NULL (seventh ,w)) "self" (seventh ,w))) ;; part
(defmacro sink-pin-name (w) `(eighth ,w)) ;; pin
(defmacro source-id (w) `(first ,w))
(defmacro sink-id (w) `(sixth ,w))
(defmacro wire-number (w) `(fifth ,w))


