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

(load "io")

(declaim (ftype function emit get-filename emit-name-and-pipes emit-pipes emit-components))

(defun main (argv)
  (declare (ignorable argv))
  (read-facts #'emit *standard-input* *standard-output*)
  0)

(defun emit (facts)
  (let ((fname (get-filename facts)))
    (with-open-file (f fname :direction :output :if-exists :supersede)
      (emit-name-and-pipes f facts)
      (emit-components f facts))))

(defun get-filename (facts)
  (maphash #'(lambda (id info)
	       (declare (ignore id))
	       (when-match (compf 'component info)
		 (return-from get-filename (merge-pathnames (obj compf) "*.gsh"))))
	   facts))

(defun emit-name-and-pipes (f facts)
  (maphash #'(lambda (id info)
	       (declare (ignore id))
	       (when-match (compf 'component info)
		 (vshemit f "#name ~A.gsh" (obj compf))
		 (let-match (nf 'n-pipes info)
		   (vshemit f "pipes ~a" (obj nf)))
		 (return-from emit-name-and-pipes)))
	   facts))

(defun emit-pipes (f dir fds)
  (mapc #'(lambda (p-fd)
	    (vshemit f "push ~a" dir)
	    (vshemit f "push ~a" (car p-fd))
	    (vshemit f "dup ~a" (cdr p-fd)))
	(remove-duplicates fds :test 'equal)))

(defun emit-components (f facts)
  (maphash #'(lambda (id info)
	       (declare (ignore id))
	       (when-match (kindf 'kind info)
		  (vshemit f "fork")
		  (let ((exec-line (obj kindf)))
		    (let-obj-match (source-fds 'source-fds info)
		      (let-obj-match (sink-fds 'sink-fds info)
			(emit-pipes f 0 sink-fds)
			(emit-pipes f 1 source-fds)
			(vshemit f "~a ~a" (if sink-fds "exec" "exec1st") exec-line)
			(vshemit f "krof ~%"))))))
	   facts))

;(main)

#|

# First Light test
# effectively: echo hello | cat -

pipes 1

fork
#dup2(pipes[0][1],1)
push 1
push 0
dup 1
exec echo hello
krof

fork
#dup2(pipes[0][0],0)
push 0
push 0
dup 0
exec cat -
krof

|#