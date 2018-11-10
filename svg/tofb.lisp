(defun dash-to-u (str)
  (flet ((dtu (x) (substitute #\_ #\- x)))
    (if (stringp str)
        (dtu str)
      (if (symbolp str)
          (let ((s (symbol-name str)))
            (intern (dtu s)))
        (error "not string or symbol")))))
        

(defun xy (f lis id)
  (format f "~a_x(~a,~a).~%" (string-downcase (dash-to-u (first lis))) id (second lis))
  (format f "~a_y(~a,~a).~%" (string-downcase (dash-to-u (first lis))) id (third lis)))

(defparameter *default-font-width* 12)
(defparameter *default-font-height* 12)

(defun to-fb-1 (f item id)
  (assert (listp item))
  (case (car item)
    (line
     (format f "line(~a, '').~%" id)
     (mapc #'(lambda (lis) (xy f lis id))
           (rest item)))
      
    (arrow
     (format f "arrow(~a, '').~%" id)
     (mapc #'(lambda (lis) (xy f lis id))
           (subseq item 1 (1- (length item)))))

    (text
     (let ((txt (string-downcase (fourth item))))
       (format f "text(~a, '~a').~%" id txt)
       (format f "geometry_x(~a, ~a).~%" id (second item))
       (format f "geometry_y(~a, ~a).~%" id (third item))
       (format f "geometry_w(~a, ~a).~%" id (* *default-font-width* (length txt)))
       (format f "geometry_h(~a, ~a).~%" id *default-font-height*)))

    (rect
     (format f "rect(~a, '').~%" id)
     (format f "geometry_x(~a, ~a).~%" id (second item))
     (format f "geometry_y(~a, ~a).~%" id (third item))
     (format f "geometry_w(~a, ~a).~%" id (fourth item))
     (format f "geometry_h(~a, ~a).~%" id (fifth item)))

    (otherwise
     (error "bad item /~a/~%" item))))

(defun tofb (f list)
  (let ((n (1- (length list))))
    (dotimes (id n)
      (to-fb-1 f (nth id list) id)))
  (values))
