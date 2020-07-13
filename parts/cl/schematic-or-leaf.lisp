(in-package :arrowgrams/build)

(defclass schematic-or-leaf (node)
  ())

(defmethod initially ((self schematic-or-leaf))
  (call-next-method))

(defmethod react ((self schematic-or-leaf) (e event))
  (ecase (pin-name e)
    (:manifest-as-json-string
     ;; during bootstrap: all files reside in a working directory
     (let ((manifest-alist (json-to-alist (data e))))
       (let ((kind-type-str (cdr (assoc :kind-type manifest-alist)))  ;; "leaf" or "composite"
             (platform-str (cdr (assoc :platform manifest-alist)))  ;; "lisp" or "loadedlisp"
             (entry-point (cdr (assoc :entrypoint manifest-alist))) ;; a string (file reference, e.g. "./file"
             (in-pins (cdr (assoc :in-pins manifest-alist))) ;; a lisp list of string names
             (out-pins (cdr (assoc :out-pins manifest-alist))))  ;; a lisp list of string names
	 (unless (and (stringp kind-type-str) (stringp platform-str) (stringp entry-point) 
		      (list-of-strings-p in-pins) (list-of-strings-p out-pins))
	   (let ((msg (format nil "badly formed manifest ~s" manifest-alist)))
	     (send-event self :error msg)
	     (error msg)))
         (cond ((string= "leaf" kind-type-str)
                (cond ((string= "lisp" platform-str)
                       (let ((file-name (merge-pathnames entry-point *src-dir*)))
                         (if (probe-file file-name)
                             (progn
                               (let ((descriptor-as-json-string
                                      (alist-to-json-string
                                       (list (cons :item-kind "leaf")
					     (cons :name (pathname-name file-name))
                                             (cons :in-pins in-pins)
                                             (cons :out-pins out-pins)
                                             (cons :kind (pathname-name file-name))
                                             (cons :filename (make-string-filename file-name))))))
                                 (sendevent self :child-descriptor descriptor-as-json-string)))
                           (progn
                             (let ((msg (format nil "file ~s does not exist" file-name)))
                               (send-event self :error msg) 
                               (error msg)))))) ;; lisp error only during bootstrapping
                      ((string= "loadedlisp" platform-str)
                       (let ((descriptor-as-json-string
                              (let ((file-name (merge-pathnames entry-point *src-dir*)))
                                (alist-to-json-string
                                 (list (cons :item-kind "leaf")
                                       (cons :name (pathname-name file-name))
                                       (cons :in-pins in-pins)
                                       (cons :out-pins out-pins)
                                       (cons :kind (pathname-name file-name))))))) ;; no filename!  don't load it, just send :kind
                         (send-event self :child-descriptor descriptor-as-json-string)
                         (format *standard-output* "~&loaded lisp file \"\"~%")))))
               ;; no op
               
               ((string= "composite" kind-type-str)
                (let ((file-name (merge-pathnames *diagram-dir* entry-point)))
                  (send-event self :schematic-filename file-name)))))))))

#+nil(defun fixup-filename (s)
  (let ((r1 (cl-ppcre:regex-replace-all " " s "-")))
    r1))

(defun list-of-strings-p (x)
  (when (listp x)
    (dolist (s x)
      (unless (stringp s)
        (return-from list-of-strings-p nil))))
  t)

(defun make-string-filename (s)
  (namestring s))
