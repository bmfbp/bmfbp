(in-package :paip)

(defun fetch-value (var alist)
  (let ((cell (assoc var alist)))
    (when cell
      (cdr cell))))

(defun create-bb (id x y right bottom)
  (unless id (break))
  (paip::add-clause `((bounding_box_left ,id ,x)))
  (paip::add-clause `((bounding_box_top ,id ,y)))
  (paip::add-clause `((bounding_box_right ,id ,right)))
  (paip::add-clause `((bounding_box_bottom ,id ,bottom))))
    
(defun create-rect-bb (alist)
  (let ((x (fetch-value '?x alist))
        (y (fetch-value '?y alist)) 
        (w (fetch-value '?w alist)) 
        (h (fetch-value '?h alist))
        (id (fetch-value '?id alist)))
    (let ((right (+ x w))
          (bottom (+ y h)))
      (create-bb id x y right bottom))))

(defun make-bounding-boxes-for-rectangles ()
  (prolog-compile-symbols)
  (let ((rect-list (all-solutions (rect ?id)
                                  (geometry_top_y ?id ?Y)
                                  (geometry_left_x ?id ?X)
                                  (geometry_w ?id ?W)
                                  (geometry_h ?id ?H))))
    (let ((rectangle-count (length rect-list)))
      (format *error-output* "~&rect-list=~S" rectangle-count)
      (values 
       (mapc #'(lambda (alist)
                 (create-rect-bb alist))
             rect-list)
       rectangle-count))))


(defun make-bounding-boxes-for-speech-bubbles ()
  (let ((speech-list (all-solutions (speechbubble ?id)
                                    (geometry_top_y ?id ?Y)
                                    (geometry_left_x ?id ?X)
                                    (geometry_w ?id ?W)
                                    (geometry_h ?id ?H))))
    (let ((speech-list-count (length speech-list)))
      (format *error-output* "~&speech-list=~S" speech-list-count)
      (values
       (mapc #'(lambda (alist)
                 (create-rect-bb alist))
             speech-list)
       speech-list-count))))

(defun create-text-bb (alist)
  (let ((x (fetch-value '?x alist))
        (y (fetch-value '?y alist)) 
        (w (fetch-value '?w alist)) 
        (h (fetch-value '?h alist))
        (id (fetch-value '?id alist)))
    (let ((right (+ x w))
          (bottom (+ y h))
	  (left (- x w))
	  (top (- y h)))
      (create-bb id left top right bottom))))
       
(defun make-bounding-boxes-for-text ()
  (let ((text-list (all-solutions (text ?id ?str)
                                  (geometry_top_y ?id ?Y)
                                  (geometry_center_x ?id ?X)
                                  (geometry_w ?id ?W)
                                  (geometry_h ?id ?H))))
    (let ((bounding-box-count (length text-list)))
      (format *error-output* "~&text-list=~S" bounding-box-count)
      (values
       (mapc #'(lambda (alist)
                 (create-text-bb alist))
             text-list)
       bounding-box-count))))

(defun create-ellipse-bb (alist)
  (let ((x (fetch-value '?x alist))
        (y (fetch-value '?y alist)) 
        (w (fetch-value '?w alist)) 
        (h (fetch-value '?h alist))
        (id (fetch-value '?id alist)))
    (let ((right (+ x w))
          (bottom (+ y h))
	  (left (- x w))
	  (top (- y h)))
      (create-bb id left top right bottom))))
       
(defun make-bounding-boxes-for-ellipses ()
  (let ((ellipse-list (all-solutions (ellipse ?id)
                                     (geometry_center_y ?id ?Y)
                                     (geometry_center_x ?id ?X)
                                     (geometry_w ?id ?W)
                                     (geometry_h ?id ?H))))
    (let ((ellipse-count (length ellipse-list)))
      (format *error-output* "~&ellipse-list=~S" ellipse-count)
      (values
       (mapc #'(lambda (alist)
                 (create-ellipse-bb alist))
             ellipse-list)
       ellipse-count))))

(defun bounding-boxes ()
  (loop
     :for routine
     :in 
       '(make-bounding-boxes-for-rectangles
         make-bounding-boxes-for-text
         make-bounding-boxes-for-speech-bubbles
         make-bounding-boxes-for-ellipses)
     :collecting
       (multiple-value-bind (results count)
           (funcall routine)
         (if results
             count
             0))))


             
