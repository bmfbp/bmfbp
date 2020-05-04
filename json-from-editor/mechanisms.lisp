(defmethod stringEqVersion ((p editor-parser))
  (unless (string= "version" (scanner:token-text (pasm:accepted-token p)))
    (error (format nil "expected string to be exactly /version/, but got /~s/~%"
		   (scanner:token-text (pasm:accepted-token p))))))

(defmethod stringEqModuleName ((p editor-parser))
  (unless (string= "moduleName" (scanner:token-text (pasm:accepted-token p)))
    (error (format nil "expected string to be exactly /moduleName/, but got /~s/~%"
		   (scanner:token-text (pasm:accepted-token p))))))

(defmethod stringEqCanvasItems ((p editor-parser))
  (unless (string= "canvasItems" (scanner:token-text (pasm:accepted-token p)))
    (error (format nil "expected string to be exactly /canvasItems/, but got /~s/~%"
		   (scanner:token-text (pasm:accepted-token p))))))

(defmethod stringEqID ((p editor-parser))
  (unless (string= "id" (scanner:token-text (pasm:accepted-token p)))
    (error (format nil "expected string to be exactly /id/, but got /~s/~%"
		   (scanner:token-text (pasm:accepted-token p))))))

  
