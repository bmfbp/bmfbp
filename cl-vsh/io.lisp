;; read facts from stdin, determine ownership of ports, output net (for semantic checking and coding)

;; the factbase is a hash table of hash tables
;; the root hashtable contains id's of every node and edge in the drawing
;; each id contains a hashtable of facts (lists of pairs and triples) pertaining to the id
;; much like the fields of a class or struct, but more flexible - e.g. at this point, I haven't
;; sussed out how to keep command line options, etc., but can add them in the future simply by
;; scanning new facts and storing them in the id-based hash tables
;; futhermore, the parser and semantic passes can add new facts into the factbase as
;; new information about the drawing nodes is inferred

(defparameter *errors* nil)

(defun vsherror (str &rest args)
  (setf *errors* t)
  (apply 'format *error-output* (concatenate 'string ";" str "~%") args))

(defun vshmsg (str &rest args)
  (apply 'format *error-output* (concatenate 'string ";" str "~%") args))

(defun vshemit (f str &rest args)
  (apply 'format f (concatenate 'string str "~%") args))

(defparameter *name* nil) ; top level component name

(defun write-facts (facts strm)
  (maphash #'(lambda (k v) (declare (ignorable k))
               (maphash #'(lambda (rel f) (declare (ignorable rel))
                            (write f :stream strm)
                            (terpri strm))
                        v))
           facts)
  (format strm ";;~a~%~%" (if *errors* " ERRORS" "")))
               
(defun rel (f) (first f)) ;; relation is always first
(defun id (f) (second f)) ;; the id is always the second item in a fact - pair or triple - subject
(defun obj (f) (if (<= (length f) 3) (first (last f)) (rest (rest f))))  ;; object

(defun add-fact (facts fact legal-fact)
  (unless (funcall legal-fact fact)
    (vsherror "illegal fact ~S" fact))
  (let ((info (gethash (id fact) facts)))
    (unless info
      (setf info
            (setf (gethash (id fact) facts) (make-hash-table))))
    (setf (gethash (rel fact) info) fact)))


(defun read-write-if-facts (write-p func instrm outstrm legal-fact)
  ; main loop - read the factbase from stdin, then process the factbase by calling func, then do it again
  ; until QUIT is read
  (setf *errors* nil)
  (let ((fact (read instrm nil 'EOF)))
    (loop
     (let ((facts (make-hash-table :test 'equal)))
       (loop while (not (eq 'EOF fact))
             do (when (eq 'QUIT (first fact))
                  (funcall func facts)
                  (write-facts facts outstrm)
                  (format outstrm "(quit)~%")
                  #-lispworks (quit)
                  #+lispworks (return-from read-write-facts))
             do (add-fact facts fact legal-fact)  ;; facts can arrive in random order, cache them until ready
             do (setf fact (read instrm nil 'EOF)))
       (funcall func facts)
       (when write-p (write-facts facts outstrm))))))

(defun read-write-facts (func instrm outstrm &key (legal-fact 'identity))
  (read-write-if-facts t func instrm outstrm legal-fact))

(defun read-facts (func instrm outstrm &key (legal-fact 'identity))
  (read-write-if-facts nil func instrm outstrm legal-fact))



;; macro to help extract facts from fb
(defmacro when-match (var-key-hash &body body)
  ;; execute body only if matched
  (destructuring-bind (var key hash) var-key-hash
    `(let ((,var (gethash ,key ,hash)))
       (when ,var
         ,@body))))

(defmacro let-match (var-key-hash &body body)
  ; try to match and unconditionally execute body
  (destructuring-bind (var key hash) var-key-hash
    `(let ((,var (gethash ,key ,hash)))
         ,@body)))

(defmacro let-obj-match (var-key-hash &body body)
  ; try to match and unconditionally execute body
  (destructuring-bind (var key hash) var-key-hash
    `(let ((,var (gethash ,key ,hash)))
       (let ((,var (when ,var (obj ,var))))
         ,@body))))

(defun unity (x) x)

(defun push-obj (rel id new-obj facts)
  ;; the object of the fact is a list, push item onto it, creating the fact if it doesn't exist
  (let ((f (gethash rel facts)))
    (unless f
      (setq f (list rel id nil))
      (setf (gethash rel facts) f))
    (push new-obj (third f))))
  