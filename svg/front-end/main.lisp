;(in-package :arrowgrams/compiler/front-end)
(in-package :cl-user)
(defparameter *pname* "CL-USER")

(proclaim '(optimize (debug 3) (safety 3) (speed 0)))

#|
In temp1.lisp, we see 2 kinds of lines

1. lines which don't end with a trailing (Z)

2. lines which do end with a trailing (Z)

 (line (absm 3665.0 490.0) (absl 3865.0 490.0) (absl 3865.0 300.0) (absl 4048.63 300.0)) 
(line (absm 4053.88 300.0) (absl 4046.88 303.5) (absl 4048.63 300.0) (absl 4046.88 296.5) (Z))

Create-text-objects does not touch lines.

Fix-lines creates line-segments (x1,y1,x2,y2) for all pieces of the line and leaves (Z) alone

 (line (line-segment 3665 490 3865 490)
       (line-segment 3865 490 3865 300))
       (line-segment 3865 490 4048.63 300))

 (line (line-segment 4054.88 300 4046.88 303.5)
       (line-segment 4046.88 303.5 4048.63 300)
       (line-segment 4048.63 300 4046.88 296.5)
       (Z))

Fix-arrows converts lines with (Z) into arrowtips, assumning that the tip is the third line-segment.

 (line (line-segment 3665 490 3865 490)
       (line-segment 3865 490 3865 300))
       (line-segment 3865 490 4048.63 300))

 (arrow 4046.88 296.5)

Collapse-lines turns lines into beginings and ends

 (line (line-begin 3665 490)
       (line-end 4048.63 300)
       
 (arrow 4046.88 296.5)

Fix-translate doesn't affect lines (translations are only for text).

Toprolog is the final step.  For lines, it creates a source port 20x20 and a sink port 20x20

edge(edge-id).
source(edge-id,source-port-id).
eltype(source-port-id,port).
port(source-port-id).
bounding_box_left(source-port-id, x1 - 20).
bounding_box_top(source-port-id, y1 - 20).
bounding_box_right(source-port-id, x1 + 20).
bounding_box_bottom(source-port-id, y1 + 20).
sink(edge-id,sink-port-id).
eltype(sink-port-id,port).
port(sink-port-id).
bounding_box_left(sink-port-id, x2 - 20).
bounding_box_top(sink-port-id, y2 - 20).
bounding_box_right(sink-port-id, x2 + 20).
bounding_box_bottom(sink-port-id, y2 + 20).


Arrows are ignored.

Lines are collapsed to two points (x1,y1) and (x2,y2).  I discard all other polyline portions.  Lines are given a single Edge id and a 20 x 20 source port is created at (x1,y1) and a 20 x 20 sink port is created at (x2,y2).


METADATA:

temp1.pro contains metadata in a TRANSLATEd string (lisp)

 (translate (3524.5 1408.5) ((metadata "...")))

Create-text-objects translates the metadata string

default-width = 2
default-font-height = 12
half-width = (10 * default-width)

-->  (metadata strid 0 0 half-width default-height)

Fix-lines doesn't affect metadata.
Fix-arrows doesn't affect metadata.
Collapse-lines doesn't affect metadata.
Fix-translates doesn't affect metadata.

Toprolog:
0. Creates an id for the meta (meta-id).
00. Creates an id for the string (string-id).
1. Makes a struidGNN for the string.  Writes the string to the temp-string-map
2. Makes an id for the rounded rectangle.  This rectangle is faked and ignored later.
3. Make an text-id for the text.

emits:

metadata(meta-id,string-id).
eltype(meta-id,metadata).
used(text-id).           !!! bug, should be used(string-id).  Prolog skips this.
text(text-id,string-id).
geometry_center_x(text-id,x + w/2).
geometry_top_y(text-id,y).
geometry_w(text-id,w).
geometry_h(text-id,h).

;; Faked rounded rect (ignored, I think).
;; Later, I discovered that draw.io
;; emits a rect anyway.  This is "indistiguishable" from other rects, so
;; there is a prolog pass that matches the text bb to the rect bb.
roundedrect(rr-id).
eltype(rr-id,roundedrect).
geometry_left_x(rr-id, x - 10).
geometry_top_y(rr-id, y - 10).
geometry_w(rr-id, w + 10).
geometry_h(rr-id, h + 10).

So, for metadata, emit:
1. A Rect that surrounds the center-point of the meta string.
2. A bb for the rect.
3. A string. (with mapping, the usual string stuff).
3b. The string's bb.
4. text(text-id,string-id).
5. metadata(meta-id,text-id).

|#


(defun run (strm output-stream)
  (init-string-map)
  (let ((*package* (find-package *pname*)))
    (let ((lst (read strm nil nil)))
      ;; bug fix
      (let ((list (if
                      (and
                       (= 3 (length lst))
                       (null (third lst))
                       (listp (second lst)))
                      (progn
                        (format *error-output* "~%~%bug fixed in temp1.lisp~%~%")
                        (cons (first lst) (second lst)))
                    lst)))
        ;; end bug fix
        (assert (listp list) () "run not a list list=/~a/" list)
        (let ((fixed 
               (mapcar #'fix-translates
                       (mapcar #'collapse-lines
                               (mapcar #'fix-arrows
                                       (mapcar #'fix-lines
                                               (mapcar #'create-text-objects 
                                                       list)))))))
          (to-prolog fixed output-stream)
          ;; this does nothing in the V3 front-end - it used to remove strings from the gprolog factbase in V2
          ;; for V3, we simply leave the strings as strings - everything is handled in Lisp
          #+nil(write-string-map "temp-string-map.lisp" "strings.sed" "unmap-sed.sed"))))))

(defun front-end-main (svg-filename)
  (let ((command-svg-to-lisp "~/bin/hs_vsh_drawio_to_fb"))
    (let ((temp1-str (with-output-to-string (s)
                       (let ((status (system:call-system-showing-output
                                      (format nil "~a <~a" command-svg-to-lisp svg-filename)
                                      :output-stream s
                                      :show-cmd nil
                                      :prefix "")))
                         (unless (zerop status)
                           (error "~&call failed status=~a~%" status))))))
      ;; this is silly, but mimics the on-disk behaviour of the V2 compiler (which used temp files)
      ;; rewrite in the future
      (let ((*package* (find-package *pname*)))
        (let ((lis (read-from-string temp1-str nil nil)))
          (assert lis)
          (let ((top-name (pathname-name svg-filename)))
            (let ((new-lis (cons `(component ,top-name) lis)))
              (let ((temp2-str (with-output-to-string (s)
                                 (write new-lis :stream s))))
                (let ((instream (make-string-input-stream temp2-str)))
                  (let ((output-stream (make-string-output-stream)))
                    (run instream output-stream)
                    (let ((result-string (get-output-stream-string output-stream)))
                      result-string)))))))))))

;;;; util.lisp

(defun list-of-lists-p (tail)
  (and (listp tail)
       (listp (first tail))))

(defparameter *string-map* nil)

(defun gen-string-id ()
  (let ((id (format nil "struid~A" (gensym))))
    id))

(defun string-to-map (str)
  "return a unique id for given string, store string in map ; all to get
   around gprolog problems"

  str

  #+nil(let ((uid (gen-string-id)))
    (setf (gethash uid *string-map*)
	  str)
    uid))

(defun init-string-map ()
  (setf *string-map* (make-hash-table)))

(defun @escape-strings-for-sed (s)
  s)

(defun write-string-map (fname sed-fname pure-sed-fname)
  (declare (ignore fname sed-fname pure-sed-fname))
  #+nil(with-open-file (f fname :direction :output :if-exists :supersede)
    (with-open-file (sed sed-fname :direction :output :if-exists :supersede)
      (with-open-file (u pure-sed-fname :direction :output :if-exists :supersede)
	(maphash
	 #'(lambda (k v)
	     (format f "(~A ~S)~%" k v)
	     (let ((str (@escape-strings-for-sed v)))
	       (format sed "s@ ~A@[~A]@g~%" k str)
	       (format u   "s@~a@\~s@g~%" k str)))
	 *string-map*)
	(format sed "s@] @].@g~%")
	(format sed "s@null null null@N.C.@g~%")
	(format sed "s@ null @.self.@g~%")
	(format sed "s@parent_source_wire_parent_sink@@g~%")))))

(defun die (msg)
  (format *error-output* "~%~S~%" msg)
  #+lispworks (error msg) ;(lispworks:quit)
  #+sbcl (exit)
  )
  
(defmacro exit-loop ()
  `(return nil))

;;;;;;;; toprolog.lisp

(defun all-digits-p (str)
  (let ((i (1- (length str))))
    (loop
       (case (schar str i)
	 ((#\0 #\1 #\2 #\3 #\4 #\5 #\5 #\6 #\7 #\8 #\9)
	  (when (< (decf i) 0)
	    (return t)))	  
	 (otherwise
	  (return-from all-digits-p nil)))))
  t)

(defun next-id ()
  (gensym "id"))

(defparameter *p* 20)  ;; port width and height - play with this if you get "no parent for box" errors

(defun contains-junk-p (s)
  (notevery #'(lambda (c) (or 
			   (alphanumericp c)
			   (char= c #\_)))
	    s))

(defparameter *metadata-already-seen* nil)

(defun to-prolog (list strm)
  (unless (listp list)
    (die (format nil "to-prolog list=/~a/" list)))
  (if (listp (car list))

      (progn
        (to-prolog (car list) strm)
        (mapc #'(lambda (x) (to-prolog x strm)) (rest list)))

    (let ((new-id (next-id)))
      ;(format *error-output* "to-prolog list: ~S~%" list)
      (case (car list)

	(nothing nil)

	(component
	 (format strm "component(~A).~%" (second list)))

        (line
	 (let ((begin-id (next-id))
	       (end-id (next-id))
	       (edge-id (next-id)))
           (destructuring-bind (line-sym begin end)
               list
             (declare (ignore line-sym))
             (destructuring-bind (begin-sym x1 y1)
		 begin
               (declare (ignore begin-sym))
               (destructuring-bind (end-sym x2 y2)
                   end
		 (declare (ignore end-sym))
		 (format strm "line(~A).~%"	new-id)

		 (format strm "edge(~A).~%" edge-id)
		 (format strm "source(~A,~A).~%" edge-id begin-id)
		 (format strm "eltype(~A,port).~%" begin-id)
		 (format strm "port(~A).~%" begin-id)
		 (format strm "bounding_box_left(~A,~A).~%" begin-id (- x1 *p*))
		 (format strm "bounding_box_top(~A,~A).~%" begin-id (- y1 *p*))
		 (format strm "bounding_box_right(~A,~A).~%" begin-id (+ x1 *p*))
		 (format strm "bounding_box_bottom(~A,~A).~%" begin-id (+ y1 *p*))
		 
		 (format strm "sink(~A,~A).~%" edge-id end-id)
		 (format strm "eltype(~A,port).~%" end-id)
		 (format strm "port(~A).~%" end-id)
		 (format strm "bounding_box_left(~A,~A).~%" end-id (- x2 *p*))
		 (format strm "bounding_box_top(~A,~A).~%" end-id (- y2 *p*))
		 (format strm "bounding_box_right(~A,~A).~%" end-id (+ x2 *p*))
		 (format strm "bounding_box_bottom(~A,~A).~%" end-id (+ y2 *p*)))))))
        
        (rect
	 ;; rect is given as {top, left, width, height, stroke}
         (destructuring-bind (rect-sym x1 y1 w h stroke)
             list
           (declare (ignore rect-sym))
	   (unless (string= stroke "none")
             (format strm "rect(~A).~%eltype(~A,box).~%~%geometry_left_x(~A,~A).~%geometry_top_y(~A,~A).~%geometry_w(~A,~A).~%geometry_h(~A,~A).~%"
                     new-id new-id new-id x1 new-id y1 new-id w new-id h))))

        (metadata
	 ;; same as rect except with extra string
         (destructuring-bind (sym str x y w h)
             list
           (declare (ignore sym))
	   (flet ((do-meta ()
		    (let ((strid (string-to-map str))
			  (rr-id (next-id))
			  (text-id (next-id)))
		      (format strm "metadata(~A,~A).~%" new-id text-id)
		      (format strm "eltype(~A,metadata).~%" new-id)
		      (format strm "used(~A).~%" text-id)
		      
		      ;; rounded rect
		      (let ((fake-w (+ 10 w))
			    (fake-h (+ 10 h))
			    (fake-left-x (- x 10))
			    (fake-top-y (- y 10)))
			;; the actual coords of the rounded rect might come from the first pass, but we fake them here for
			;; ease of implementation of the POC
			(format strm "roundedrect(~A).~%" rr-id)
			(format strm "eltype(~A,roundedrect).~%" rr-id)
			(format strm "geometry_left_x(~A,~A).~%" rr-id fake-left-x)
			(format strm "geometry_top_y(~A,~A).~%" rr-id fake-top-y)
			(format strm "geometry_w(~A,~A).~%" rr-id fake-w)
			(format strm "geometry_h(~A,~A).~%" rr-id fake-h))
		      
		      ;; text
		      (format strm "text(~A,~S).~%" text-id strid)
		      (format strm "geometry_center_x(~A,~A).~%" text-id (+ x (/ w 2)))
		      (format strm "geometry_top_y(~A,~A).~%" text-id y)
		      (format strm "geometry_w(~A,~A).~%" text-id w)
		      (format strm "geometry_h(~A,~A).~%" text-id h))))
	     
	     (cond ((null *metadata-already-seen*)
		    (setf *metadata-already-seen* str)
		    ;(format *error-output* "doing new metadata~%")
		    (do-meta))
		   ((not (string= *metadata-already-seen* str))
		    (die "more than one different metadata"))
		   (t
		    (format *error-output* "~%skipping duplicate metadata~%")
					; skip
		    )))))


	(speechbubble
         (destructuring-bind (sym p1 p2 p3 p4 p5 p6 p7 zed)
             list
           (declare (ignore sym zed p4 p5 p6 p7))
	   (let ((x1 (second p1))
		 (y1 (third p1)))
	     (let ((w (- (second p2) x1))
		   (h (- (third p3) y1)))
           (format strm "speechbubble(~A).~%eltype(~A,speechbubble).~%~%geometry_left_x(~A,~A).~%geometry_top_y(~A,~A).~%geometry_w(~A,~A).~%geometry_h(~A,~A).~%"
                   new-id new-id new-id x1 new-id y1 new-id w new-id h)))))

        (text
	 ;; text is given as {center-x, top-y, width/2, height}
         (destructuring-bind (text-sym str x1 y1 w h)
             list
           (declare (ignore text-sym))
	   (let ((strid (if (all-digits-p str) 
			    str 
			    (string-to-map str))))
             (format strm "text(~A,~s).~%geometry_center_x(~A,~A).~%geometry_top_y(~A,~A).~%geometry_w(~A,~A).~%geometry_h(~A,~A).~%"
                     new-id strid new-id x1 new-id y1 new-id w new-id h))))

	(ellipse
         (destructuring-bind (sym x1 y1 w h)
             list
           (declare (ignore sym))
           (format strm "ellipse(~A).~%eltype(~A,ellipse).~%~%geometry_center_x(~A,~A).~%geometry_center_y(~A,~A).~%geometry_w(~A,~A).~%geometry_h(~A,~A).~%"
                   new-id new-id new-id x1 new-id y1 new-id w new-id h)))

	(dot
         (destructuring-bind (sym x1 y1 w h)
             list
           (declare (ignore sym))
           (format strm "dot(~A).~%eltype(~A,dot).~%~%geometry_center_x(~A,~A).~%geometry_top_y(~A,~A).~%geometry_w(~A,~A).~%geometry_h(~A,~A).~%"
                   new-id new-id new-id x1 new-id y1 new-id w new-id h)))


        (arrow
         (destructuring-bind (arrow-sym x1 y1)
             list
           (declare (ignore arrow-sym))
           (format strm "arrow(~A).~%arrow_x(~A,~A).~%arrow_y(~A,~A).~%"
                   new-id new-id x1 new-id y1)))

        (otherwise
         (die (format nil "bad format in toprolog /~A/" list))))))
      
  (values))

;;;;;;;;;;;;; fix-translate.lisp

;; apply all translations in lisp - probably could be done in Prolog

(defun fix-one-translate (x y list)
  (assert (listp list) () "fix-one-translate 1 x=~a y= ~a list=/~a/" x y list)

  (if (listp (car list))
      (mapcar #'(lambda (l)
                  (fix-one-translate x y l))
              list)
      (let ()
	(case (car list)
	  (translate
	   (let ((pair (second list))
		 (tail (third list)))
	     (assert (list-of-lists-p tail) () "fix-one-translate 2 x=~a y= ~a list=/~a/" x y list)
	     (mapcar #'(lambda (item) (fix-one-translate (+ x (first pair)) (+ y (second pair)) item)) tail)))

	  (rect
	   (destructuring-bind (sym x1 y1 w h)
               list
	     (declare (ignore sym))
	     `(rect ,(+ x x1) ,(+ y y1) ,w ,h)))

	  (metadata
	   (destructuring-bind (sym str x1 y1 w h)
               list
	     (declare (ignore sym))
	     `(metadata ,str ,(+ x x1) ,(+ y y1) ,w ,h)))

	  (speech-bubble
	   ;; speech-bubble is in (speech-bubble p1 p2 p3 p4 p5 p6 p7 (z)) format
	   ;; where p1 is (absm x y), other p's are (absl x y) format
	   ;; p1 is top-left, p2 if top-right, p3 is bottom-right, p7 is bottom-left
	   (destructuring-bind (text-sym p1 p2 p3 p4 p5 p6 p7 zed) 
               list
	     (declare (ignore text-sym zed p4 p5 p6 p7))
	     (let ((x1 (first p1))
		   (y1 (second p1)))
	       (let ((w (- (first p2) x1))
		     (h (- (second p3) y1)))
		 `(comment ,(+ x x1) ,(+ y y1) ,w ,h)))))

	  (ellipse
	   (destructuring-bind (sym x1 y1 x2 y2)
               list
	     (declare (ignore sym))
	     `(ellipse ,(+ x x1) ,(+ y y1) ,x2 ,y2)))

	  (dot
	   (destructuring-bind (sym x1 y1 x2 y2)
               list
	     (declare (ignore sym))
	     `(dot ,(+ x x1) ,(+ y y1) ,x2 ,y2)))

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
	   ;; text is in (x y w h) format
	   (destructuring-bind (text-sym str x1 y1 w h)
               list
	     (declare (ignore text-sym))
	     `(text ,str ,(+ x x1) ,(+ y y1) ,w ,h)))

	  (nothing
	   list)
	  
	  (otherwise
	   (die (format nil "bad format in fix-one-translate /~A ~A ~A/" x y list)))))))

(defun fix-translates (list)
  (assert (listp list) () "fix-translates 3 list=/~a/" list)

  (if (listp (car list))
      (mapcar #'fix-translates list)

      (case (car list)
	
	(translate
	 (let ((pair (second list))
               (tail (third list)))
	   (assert (list-of-lists-p tail) () "fix-translates 4 list=/~a/" list)
	   (mapcar #'(lambda (item) (fix-one-translate (first pair) (second pair) item)) tail)))
	
	((rect text arrow line component ellipse dot speechbubble metadata)
	 list)
	
	(otherwise
	 (die (format nil "bad format in fix-translates /~A/" list))))))

;;;;;;;;;;;;; collapse-lines.lisp

;; we could assign id's to the various lines and calculate where they start and end, in Prolog
;; but,,, we already have the lines described by sequence line-segments, we only really need to know where a line starts
;; and where it ends, we can do that easily in Lisp

(defun grid (x grid-size)
  (floor (* grid-size (floor (/ (+ x (1- grid-size)) grid-size)))))

(defun grid10 (x)
  (grid x 10))

(defun collapse-lines (list)
  (assert (listp list) () "collapse-lines list=/~a/" list)

  (if (listp (car list))
      (mapcar #'collapse-lines list)
      
      (case (car list)
	
	(translate
	 (let ((pair (second list))
               (tail (third list)))
	   (if (list-of-lists-p tail)
               `(translate ,pair ,(mapcar #'collapse-lines tail))
               (die "badly formed translate"))))
	
	((rect text arrow component ellipse dot speechbubble metadata nothing) 
	 list)
	
	(line
	 (let ((start (second list))
               (end (car (last list))))
	   `(line (line-begin ,(second start) ,(third start))
		  (line-end ,(grid10 (fourth end)) ,(grid10 (fifth end))))))
	
	(otherwise
	 (die(format nil "bad format in collapse-lines /~A/" list))))))

;;;;;;;;;;;;; create-text-objects.lisp

(defparameter *default-font-width* 2) ;; kludge - Draw.IO should be able to tell us the extent of the string, but doesn't
(defparameter *default-font-height* 12)


(defun matches-text-item-p (tail)
  (stringp (first tail)))

(defun matches-not-supported-p (tail)
  (when (and (listp tail) (= 1 (length tail)))
    (let ((str (first tail)))
      (and 
       (stringp str)
       (string= "[Not supported by viewer]" str)))))

(defun text-part (tail)
  (first tail))

(defun get-metadata-len (text)
  ;; faking it for now, too hard to calculate, let's wait for a better editor
  ;; in prolog, the text will match a rounded rectangle if its upper-left
  ;; corner is in the rounded rectangle (and we will mostly ignore the width)
  (declare (ignore text))
  10)

(defun create-text-objects (list)
  (assert (listp list))
  (if (listp (car list))
      (mapcar #'create-text-objects list)
      (if (stringp (car list))
	  (progn
	    (mapcar #'create-text-objects (rest list)))
	  (case (car list)
	    
	    (translate
	     (flet ((failure () (die (format nil "badly formed translate /~A/~%" list))))
	       (let ((pair (second list))
		     (tail (third list)))
		 (cond ((list-of-lists-p tail)
			`(translate ,pair ,(mapcar #'create-text-objects tail)))
		       
		       ((matches-not-supported-p tail)
			'(nothing))
		       
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
		       
		       (t (failure))))))
	    
	    ((line rect component ellipse dot speechbubble)
	     list)
	    
	    (metadata
	     (if (and 
		  (= 2 (length list)) 
		  (stringp (second list)))
		 ;; (metadata "[lotsofstrings]") --> (metadata strid 0 0 w/2 h)
		 (let ((half-width (/ (* (get-metadata-len (second list)) *default-font-width*) 2)))
		   `(metadata ,(second list) 0 0 ,half-width ,*default-font-height*))
		 (die (format nil "badly formed metadata /~S/~%" list))))
	    
	    (otherwise
	     (die (format nil "~%bad format in create-text-objects /~S/~%" list)))))))


;;;;;;;;;;;;; fix-arrows.lisp

;; Convention - any line ending in (Z) is actually an arrow

(defun fix-arrows (list)
  (assert (listp list) nil "fix-arrows list=/~a/" list)

  (if (listp (car list))
      (mapcar #'fix-arrows list)

    (case (car list)
      
      (translate
       (let ((pair (second list))
             (tail (third list)))
         (if (list-of-lists-p tail)
             `(translate ,pair ,(mapcar #'fix-arrows tail))
           (die (format nil "fix-arrows: badly formed translate /~A/~%" list)))))
      
      ((rect text arrow component ellipse dot speechbubble metadata nothing) 
       list)
      
      (line
       (if (eq 'z (first (first (last list))))
           ;; this is specific to draw.io - arrows in draw.io are of the form "(LINE (LINE-SEGMENT 310.0 178.88 306.5 171.88) (LINE-SEGMENT 306.5 171.88 310.0 173.63) (LINE-SEGMENT 310.0 173.63 313.5 171.88) (Z))"
           ;; "line" becomes "arrow" and we drop everything but the 2nd pair in the 3rd coord, which is the tip of the arrow
           (progn
             (let* ((tip-triple (third list))
                    (tip-x (fourth tip-triple))
                    (tip-y (fifth tip-triple)))
               `(arrow ,tip-x ,tip-y)))
         list))
    
    (otherwise
     (die (format nil "bad format in fix-arrows /~A/" list))))))

;;;;;;;;;;;;; fix-lines.lisp

;; in SVG, lines start with an absolute move (absm) followed by pair of coords (absl)
;; we want line segments to be (x1,y1,x2,y2)


(defun fixup-line (list x1 y1)
  (when list
    (if (and (= 1 (length list))
             (eq 'z (first (first list))))
        `((z))
      (let* ((absl (first list))
             (x2 (second absl))
             (y2 (third absl)))
        (cons `(line-segment ,x1 ,y1 ,x2 ,y2)
              (fixup-line (rest list) x2 y2))))))

(defun fix-lines (list)
  (assert (listp list) () "fix-lines list=/~a/" list)

  (if (listp (car list))
      (mapcar #'fix-lines list)
      (case (car list)
	
	(translate
	 (let ((pair (second list))
               (tail (third list)))
	   (if (list-of-lists-p tail)
               `(translate ,pair ,(mapcar #'fix-lines tail))
               (die (format nil"fix-lines: badly formed translate /~A/~%" list)))))
	
	((rect text component ellipse dot speechbubble metadata nothing) 
	 list)
	
	(line
	 (let* ((absm (second list))
		(x1 (second absm))
		(y1 (third absm)))
	   `(line ,@(fixup-line (rest (rest list)) x1 y1))))
	
	(otherwise
	 (die (format nil "bad format in fixup-line /~A/" list))))))

;;;;;;;;;;;;;
