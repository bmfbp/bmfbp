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

(defun mark-source (fact facts)
  (let ((port-id (obj fact)))
    (let ((port-info (gethash port-id facts)))
      (when-match (s 'sink port-info)
        (vsherror "port ~A cannot simultaneously be a source and sink" port-id))
      (when-match (s 'source port-info)
        (return-from mark-source)) ;; already marked
      (setf (gethash 'source port-info) (triple 'source port-id nil)))))

(defun mark-sink (fact facts)
  (let ((port-id (obj fact)))
    (let ((port-info (gethash port-id facts)))
      (when-match (s 'source port-info)
        (vsherror "port ~A cannot simultaneously be a sink and sink" port-id))
      (when-match (s 'sink port-info)
        (return-from mark-sink)) ;; already marked
      (setf (gethash 'sink port-info) (triple 'sink port-id nil)))))

(defun mark-direction (id info facts)
  ;; create a new "direction" fact for every port
  (declare (ignorable id))
  (when-match (e 'edge info)
      (when-match (s 'source info)
        (mark-source s facts))
      (when-match (s 'sink info)
        (mark-sink s facts))))

(defun mark-directions (facts)
  (maphash #'(lambda (k v) (mark-direction k v facts)) facts))

(defun main (argv)
  (declare (ignorable argv))
  (read-write-facts #'mark-directions *standard-input* *standard-output*)
  0)

;(main)