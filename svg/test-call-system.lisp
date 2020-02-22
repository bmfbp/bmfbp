;; trying out LW's call-system-showing-output
;; desired: run haskell front end, capture result in string(?

(defun cstest ()
  (let ((command-svg-to-lisp "~/bin/hs_vsh_drawio_to_fb")
        (svg-file "~/quicklisp/local-projects/bmfbp/build_process/kk/ide.svg"))
    (svg-to-fb-string command-svg-to-lisp svg-file)))


(defun svg-to-fb-string (program svg)
  (with-output-to-string (s)
    (system:call-system-showing-output (format nil "~a <~a" program svg) :output-stream s)))
