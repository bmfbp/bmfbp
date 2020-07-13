(defmethod stringEqVersion ((p editor-parser))
  (unless (string= "version" (scanner:token-text (pasm:accepted-token p)))
    (error (format nil "expected string /version/, but got /~s/~%"
		   (scanner:token-text (pasm:accepted-token p))))))

(defmethod stringEqModuleName ((p editor-parser))
  (unless (string= "moduleName" (scanner:token-text (pasm:accepted-token p)))
    (error (format nil "expected string /moduleName/, but got /~s/~%"
		   (scanner:token-text (pasm:accepted-token p))))))

(defmethod stringEqCanvasItems ((p editor-parser))
  (unless (string= "canvasItems" (scanner:token-text (pasm:accepted-token p)))
    (error (format nil "expected string /canvasItems/, but got /~s/~%"
		   (scanner:token-text (pasm:accepted-token p))))))

(defmethod stringEqID ((p editor-parser))
  (unless (string= "id" (scanner:token-text (pasm:accepted-token p)))
    (error (format nil "expected string /id/, but got /~s/~%"
		   (scanner:token-text (pasm:accepted-token p))))))

(defmethod stringEqShape ((p editor-parser))
  (unless (string= "shape" (scanner:token-text (pasm:accepted-token p)))
    (error (format nil "expected string /shape/, but got /~s/~%"
		   (scanner:token-text (pasm:accepted-token p))))))

(defmethod stringEqTag ((p editor-parser))
  (unless (string= "tag" (scanner:token-text (pasm:accepted-token p)))
    (error (format nil "expected string /tag/, but got /~s/~%"
		   (scanner:token-text (pasm:accepted-token p))))))

(defmethod stringEq ((p editor-parser) str)
  (unless (string= str (scanner:token-text (pasm:accepted-token p)))
    (error (format nil "expected string /~a/, but got /~s/~%" 
		   str
		   (scanner:token-text (pasm:accepted-token p))))))

(defmethod stringEqTopLeft ((p editor-parser))
  (stringEq p "topLeft"))

(defmethod stringEqBottomRight ((p editor-parser))
  (stringEq p "bottomRight"))

(defmethod stringEqPoints ((p editor-parser))
  (stringEq p "points"))


;; next 3 methods are predicates, return :ok or :fail
;; they expect that a STRING token has just been accepted
(defmethod isPolyline ((p editor-parser))
  (if (string= "Polyline" (scanner:token-text (pasm:accepted-token p)))
      :ok
      :fail))
(defmethod isEllipse ((p editor-parser))
  (if (string= "Ellipse" (scanner:token-text (pasm:accepted-token p)))
      :ok
      :fail))
(defmethod isRect ((p editor-parser))
  (if (string= "Rect" (scanner:token-text (pasm:accepted-token p)))
      :ok
      :fail))
