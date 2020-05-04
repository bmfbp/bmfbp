(defun pathEditorParser (str)
  (asdf:system-relative-pathname :json-from-editor str))
