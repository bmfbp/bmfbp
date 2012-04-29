;;; Copyright (c) 2012, Paul Tarvydas
;;; All rights reserved.

;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions
;;; are met:

;;;    Redistributions of source code must retain the above copyright
;;;    notice, this list of conditions and the following disclaimer.

;;;    Redistributions in binary form must reproduce the above
;;;    copyright notice, this list of conditions and the following
;;;    disclaimer in the documentation and/or other materials provided
;;;    with the distribution.

;;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
;;; CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
;;; INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
;;; MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
;;; DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
;;; BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
;;; EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
;;; TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
;;; DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
;;; ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
;;; TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
;;; THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
;;; SUCH DAMAGE.


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
                  (when write-p
		    (write-facts facts outstrm)
		    (format outstrm "(quit)~%"))
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
  