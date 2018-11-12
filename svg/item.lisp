;; accessors to list-based data structures

(defun parse-rect (item)
  (multiple-value-bind (cmd x y w h) item
    (assert (eq cmd 'rect))
    (values cmd x y w h)))

(defun parse-text-item (item)
  (multiple-value-bind (cmd x y text-as-list) item
    (assert (and
	     (eq cmd 'text)
	     (listp text-as-list)
	     (= 1 (length text-as-list))
	     (stringp (first text-as-list))))
    (values cmd x y (string-downcase (first text-as-list)))))
