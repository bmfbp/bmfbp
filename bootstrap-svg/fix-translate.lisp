;; apply all translations in lisp - probably could be done in Prolog

(defun fix-one-translate (x y list)
  (assert (listp list))
  (case (car list)
    (translate
     (let ((pair (second list))
           (tail (third list)))
       (assert (list-of-lists-p tail))
       (mapcar #'(lambda (item) (fix-one-translate (first pair) (second pair) item)) tail)))
    
    (rect
     (destructuring-bind (sym x1 y1 x2 y2)
         list
       (declare (ignore sym))
       `(rect ,(+ x x1) ,(+ y y1) ,(+ x x2) ,(+ y y2))))

    (line
     (destructuring-bind (line-sym begin end)
         list
       (declare (ignore line-sym))
       (destructuring-bind (begin-sym x1 y1)
           begin
         (declare (ignore begin-sym))
         (destructuring-bind (end-sym x2 y2)
             end
           (declare (ignore end-sym))
           `(line (begin-line ,(+ x x1) ,(+ y y1))
                  (end-line ,(+ x x2) ,(+ y y2)))))))

    (arrow
     (destructuring-bind (arrow-sym x1 y1)
         list
       (declare (ignore arrow-sym))
       `(arrow ,(+ x x1) ,(+ y y1))))

    (text
     (destructuring-bind (text-sym str x1 y1 w h)
         list
       (declare (ignore text-sym))
       `(text ,str ,(+ x x1) ,(+ y y1) ,w ,h)))
    
    (otherwise
     (error (format nil "bad format in fix-one-translate /~A ~A ~A/" x y list)))))

(defun fix-translates (list)
  (assert (listp list))

  (case (car list)

    (translate
     (let ((pair (second list))
           (tail (third list)))
       (assert (list-of-lists-p tail))
       (mapcar #'(lambda (item) (fix-one-translate (first pair) (second pair) item)) tail)))

    ((rect text arrow line)
     (assert nil))

    (otherwise
     (error (format nil "bad format in fix-translates /~A/" list)))))

