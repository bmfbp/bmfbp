(in-package :arrowgram)

(trace paip::prolog-compile-symbols)

(defun rtest ()
  (paip::?-
   (rect ?id)
   (geometry_top_y ?id ?Y)
   (geometry_left_x ?id ?X)
   (geometry_w ?id ?W)
   (geometry_h ?id ?H)))
