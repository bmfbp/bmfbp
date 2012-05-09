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

(declaim (ftype function assign-fd-numbers assign-fd-number assign-fd append-fd next-fd))

(defun main (argv)
  (declare (ignorable argv))
  (read-write-facts #'assign-fd-numbers *standard-input* *standard-output*)
  0)

(defun assign-fd-numbers (facts)
  (let ((component-id nil)
	(component-info nil))
    (maphash #'(lambda (k v)
		 (when-match (componentf 'component v)
		    (setf component-id k
			  component-info v))
		 (assign-fd-number k v facts)) facts)))

(defun assign-fd-number (id info facts)
  (when-match (p 'type info)
     (when (eq (obj p) 'port)
       (let-obj-match (name 'portname info)
          (cond ((string= name "in")
                 (assign-fd id info 0 facts))
                ((string= name "out")
                 (assign-fd id info 1 facts))
                ((string= name "err")
                 (assign-fd id info 2 facts))
                (t
                 (assign-fd id info (next-fd info facts) facts)))))))

(defun assign-fd (id info n facts)
  (setf (gethash 'fd-num info)
        (triple 'fd-num id n))
  (let-obj-match (parent 'parent info)
    (let-match (source 'source info)
      (let-obj-match (pipe 'pipe-num info)
        (let ((pinfo (gethash parent facts)))
	  (append-fd source pipe n parent pinfo))))))

(defun append-fd (source-p pipe fd id info)
  (let ((dir (if source-p 'source-fds 'sink-fds)))
    (let-obj-match (fd-list dir info)
      (setf (gethash dir info) (triple dir id (cons (cons pipe fd) fd-list))))))

(defun next-fd (port-info facts)
  (let-obj-match (parent-id 'parent port-info)
     (assert (and parent-id (atom parent-id)))
     (let ((parent-info (gethash parent-id facts)))
       (let-match (nextf 'next-fd parent-info)
		  (let ((next (if nextf
				  (obj nextf)
				  3)))
		    (setf (gethash 'next-fd parent-info)
			  (triple 'next-fd parent-id (1+ next)))
		    next)))))

;(main)