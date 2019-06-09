(defparameter *default-font-width* 2) ;; kludge - Draw.IO should be able to tell us the extent of the string, but doesn't
(defparameter *default-font-height* 12)


(defun matches-text-item-p (tail)
  (stringp (first tail)))

(defun text-part (tail)
  (first tail))

(defun matches-metadata-p (tail)
  "return t if tail looks like metada"
  (and 
   (>= (length tail) 2)
   (eq 'metadata (first tail))
   (stringp (second tail))))

(defun match-metadata (tail)
  "return text part of metadata"
  (second tail))

(defun get-metadata-len (text)
  ;; faking it for now, too hard to calculate, let's wait for a better editor
  ;; in prolog, the text will match a rounded rectangle if its upper-left
  ;; corner is in the rounded rectangle (and we will mostly ignore the width)
  (declare (ignore text))
  1)

(defun create-text-objects (list)
  (assert (listp list))
  (case (car list)
    
    (translate
     (flet ((failure () (die (format nil "badly formed translate /~A/~%" list))))
       (let ((pair (second list))
             (tail (third list)))
	 
	 (format *error-output* "in translate: /~S/~%" list)

	 (cond ((list-of-lists-p tail)
                `(translate ,pair ,(mapcar #'create-text-objects tail)))

               ((matches-text-item-p tail)
                ;; (translate (N M) ("emit")) --> ((translate (N M) ((text "emit" 0 0 w/2 h))))
                (let ((text (text-part tail)))
                  (let ((half-width (/ (* (length text) *default-font-width*) 2)))
                    `((translate ,pair
                                 ((text ,text 
                                        0
                                        0
                                        ,half-width
                                        ,*default-font-height*)))))))

               ((matches-metadata-p tail)
                (let ((text (match-metadata tail)))
                  ;; (translate (N M) ((metadata "[lotsofstrings]")) --> ((translate (N M) ((metadata "[lotsofstrings]" 0 0 w/2 h))))
                  ;; if formatted correctly, this will contain sets of 5 strings - width is max in fives plus NN chars ("[{...}]" and quotes)
                  (let ((len (get-metadata-len text)))
                    (let ((half-width (/ (* len *default-font-width*) 2)))
                      `((translate ,pair
                                   ((metadata ,text 
                                              0
                                              0
                                              ,half-width
                                              ,*default-font-height*))))))))
               (t (failure))))))
    
    ((line rect component ellipse dot speechbubble)
     list)

    (otherwise
     (die (format nil "~%bad format in create-text-object /~A/~%" list)))))

