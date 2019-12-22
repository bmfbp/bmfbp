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


(defun run (strm)
  (init-string-map)
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
	(to-prolog fixed *standard-output*)
	(write-string-map "temp-string-map.lisp" "strings.sed")))))

#-lispworks
(defun main (argv)
  (declare (ignore argv))
  (handler-case
      (progn
	(run *standard-input*))
    (end-of-file (c)
      (format *error-output* "FATAL 'end of file error; in main /~S/~%" c))
    (simple-error (c)
      (format *error-output* "FATAL error in main /~S/~%" c))
    (error (c)
      (format *error-output* "FATAL error in main /~S/~%" c))))

#+lispworks
(defun main (fname)
  (with-open-file (f fname :direction :input)
    (run f)))

