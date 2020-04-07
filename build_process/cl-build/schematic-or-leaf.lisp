(in-package :arrowgrams/build)

#|

leaf part: iterator:
1. manifest inside build_process.svg
  {    "dir": "build_process/", "file": "parts/parts/iterator.json","kindName": "iterator", "ref": "master", "repo": "https://github.com/bmfbp/bmfbp.git" },
2. file iterator.manifest.json
{ "entrypoint": "./iterator.js", "kindType": "leaf", "platform": "nodejs", "inPins": [ "start", "continue", "done" ], "outPins": [ "get one" ]}
3. file iterator.js
  << js code >>


composite (graph) part: compile_composite:
1. manifest inside build_process.svg
  { "dir": "build_process/", "file": "parts/compile_composite.json", "kindName": "compile composite", "ref": "master", "repo": "https://github.com/bmfbp/bmfbp.git" },
2. file compile_composite.json
{ "entrypoint": "./compile_composite.arrowgram.json", "inPins": [ "arrowgram" ], "kindType": "composite", "outPins": [ "metadata json", "composite json" ], "platform": "nodejs" }
3. compile_composite.output.json
  << json graph >>


basic algorithm:

1. receive manifest file reference (json 5 parts)
2. read manifest file using file reference
3. if manifest.kindType == "leaf" then create a file ref and send it to the code output pin
   if manifest.kindType == "composite" then create a file ref and send it to the schematic output pin
2/3 check for errors (manifest doesn't exist, code/svg doesn't exist)
|#

(defclass schematic-or-leaf (builder)
  ())

(defmethod e/part:first-time ((self schematic-or-leaf))
  (call-next-method))

(defmethod e/part:react ((self schematic-or-leaf) e)
  ;(format *standard-output* "~&schematic-or-leaf gets ~s ~s~%" (@pin self e) (subseq (@data self e) 0 60))
  (ecase (@pin self e)
    (:manifest-as-json-string
     ;; during bootstrap: all files reside in a working directory
     (let ((manifest-alist (json-to-alist (@data self e))))
       (let ((kind-type-str (cdr (assoc :kind-type manifest-alist)))  ;; "leaf" or "composite"
             (platform-str (cdr (assoc :platform manifest-alist)))  ;; "lisp" or "loadedlisp"
             (entry-point (cdr (assoc :entrypoint manifest-alist))) ;; a string (file reference, e.g. "./file"
             (in-pins (cdr (assoc :in-pins manifest-alist))) ;; a lisp list of string names
             (out-pins (cdr (assoc :out-pins manifest-alist))))  ;; a lisp list of string names
	 (unless (and (stringp kind-type-str) (stringp platform-str) (stringp entry-point) 
		      (list-of-strings-p in-pins) (list-of-strings-p out-pins))
	   (let ((msg (format nil "badly formed manifest ~s" manifest-alist)))
	     (@send self :error msg)
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
                                 (@send self :child-descriptor descriptor-as-json-string)))
                           (progn
                             (let ((msg (format nil "file ~s does not exist" file-name)))
                               (break)
                               (@send self :error msg) 
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
                         (@send self :child-descriptor descriptor-as-json-string)
                         (format *standard-output* "~&loaded lisp file \"\"~%")))))
               ;; no op
               
               ((string= "composite" kind-type-str)
                (let ((file-name (merge-pathnames *diagram-dir* entry-point)))
                  (@send self :schematic-filename file-name)))))))))

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
