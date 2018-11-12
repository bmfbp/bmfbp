;; accessors to list-based data structures

(defclass rect ()
  ((x :accessor x)
   (y :accessor y)
   (w :accessor w)
   (h :accessor h)))

(defclass move ()
  ((absolute-p :accessor absolute-p)
   (x :accessor x)
   (y :accessor y)))

(defclass line-segment ()
  ((absolute-p :accessor absolute-p)
   (x :accessor x)
   (y :accessor y)))

(defclass line ()
  ((children :accessor children)))

(defclass arrow ()
  ((children :accessor children)))

(defclass translation ()
  ((x :accessor x)
   (y :accesor y)
   (children :accessor children)))

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

(defun text-p (item)
  (and
   (listp item)
   (listp (third item)) ;; text item is (translate (x y) ("str"))
   (= 1 (length (third item)))
   (stringp (first (third item)))))
