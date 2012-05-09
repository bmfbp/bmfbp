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


;; fbp says that each output of a component can only go one place, but outputs from
;; multiple components can be tied together and arrive at a single component's input

;; to assign pipe numbers, we (1) assign a unique pipe index to each input, then (2) find
;; all outputs that go to each input and give them the same pipe index

(load "io")

(declaim (ftype function next-pipe assign-pipe-number assign-pipe))

(defvar *npipes* 0)

(defun assign-pipe-numbers (facts)
  (let ((component-id nil)
	(component-info nil))
    (setf *npipes* 0)
    (maphash #'(lambda (k v)
		 (when-match (componentf 'component v)
		    (setf component-id k
			  component-info v))
		 (assign-pipe-number k v))
	     facts)
    (setf (gethash 'n-pipes component-info)
	  (triple 'n-pipes component-id *npipes*))))

(defun assign-pipe-number (id info)
  (when-match (p 'type info)
     (when (eq (obj p) 'port)
       (when-match (p 'sink info)
         (assign-pipe id info *npipes*)))))

(defun assign-pipe (id info n)
  (incf *npipes*)
  (setf (gethash 'pipe-num info)
        (list 'pipe-num id n)))

(defun main (argv)
  (declare (ignorable argv))
  (read-write-facts #'assign-pipe-numbers *standard-input* *standard-output*)
  0)

;(main)