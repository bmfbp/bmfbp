(defun generate-editor-parser ()
  (let ((pasm:*pasm-accept-tracing* -1))
    (let ((p (make-instance 'editor-parser)))
      (let ((inFileName (pathEditorParser "hello_world.json")))
	(let ((pasmFileName (pathEditorParser "editor.pasm")))
	  (let ((pasm-string (alexandria:read-file-into-string pasmFileName))
		(json-string (alexandria:read-file-into-string inFileName)))
	    (pasm:transpile p pasm-string json-string 'jsonFromEditor)))))))

