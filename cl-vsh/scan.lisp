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

(load "~/quicklisp/setup.lisp")
(ql:quickload "xmls")

(defun parse-graphml (fname)
  (with-open-file (f fname :direction :input)
    (xmls:parse f)))

(defun children (node)
  (xmls:xmlrep-children node))

(defun child-tags (tag node)
  (xmls:xmlrep-find-child-tags tag node))

(defun attrib (attrib node &key (if-undefined :error))
  (xmls:xmlrep-attrib-value attrib node if-undefined))

(defun find-with-attr-vals (attr-vals keys)
  (find-if #'(lambda (k)
               (every #'(lambda (av)
                          (let ((attr (first av))
                                (val (second av)))
                            (equal (attrib attr k :if-undefined nil) val)))
                      attr-vals))
           keys))           

(defun find-graph-name-id (graph)
  (attrib "id"
          (find-with-attr-vals
           '(("id" "d7")
             ("for" "graph")
             ("attr.type" "string")
             ("attr.name" "Description"))
           (child-tags "key" graph))))

(defun find-data (id graph)
  (find-with-attr-vals (list (list "key" id)) (child-tags "data" graph)))

(defun find-key-id (type graph)
  (attrib "id" (find-with-attr-vals (list (list "yfiles.type" type)) (child-tags "key" graph))))

;; yFiles extractor

(defun get-main-graph (graph)
  ;; the main graph is the (single) graph node in the top level xml
  ;; yFiles stores graphics information about nodes and edges in keys
  ;; with attributes "nodegraphics" and "edgegraphics", resp. - find these
  ;; nodes and extract their id's
  (values
   (find-graph-name-id graph)
   (find-key-id "nodegraphics" graph)
   (find-key-id "edgegraphics" graph)
   (car (child-tags "graph" graph))))

(defun get-title (title-id graph)
  (children (find-data title-id graph)))

(defun print-nodes (id graph)
  (mapcar #'(lambda (n)
              (let* ((cid (attrib "id" n))
                     (node (find-data id n))
                     (generic (child-tags "GenericNode" node))
                     (shape (child-tags "ShapeNode" node))
                     (info (car (or generic shape))))
                (format t "(node ~A nil)~%" cid)
                (format t "(type ~A ~A)~%" cid (if generic "box" "port"))
                (let ((g (car (child-tags "Geometry" info))))
                  (format t "(geometry ~A (~A ~A ~A ~A))~%" cid
                          (attrib "x" g) (attrib "y" g) (attrib "width" g) (attrib "height" g)))
                (let ((lab (car (children (car (child-tags "NodeLabel" info))))))
                  (format t "(~A ~A ~s)~%" (if generic "kind" "portName") cid lab))))
          (child-tags "node" graph)))

(defun print-edges (id graph)
  (declare (ignorable id))
  (mapcar #'(lambda (n)
              (let ((eid (attrib "id" n)))
                (format t "(edge ~A nil)~%" eid)
                (format t "(source ~A ~A)~%" eid (attrib "source" n))
                (format t "(sink ~A ~A)~%" eid (attrib "target" n))))
          (child-tags "edge" graph)))

(defun scan-drawing (fname argv)
  (multiple-value-bind (title-id node-id edge-id graph)
      (get-main-graph (parse-graphml fname))
    (format t "(component ~s nil)~%" (or (car (get-title title-id graph))
				     (pathname-name (second argv))))
    (print-nodes node-id graph)
    (print-edges edge-id graph)
    (format t "(quit nil nil)~%"))
  (values))

(defun main (argv)
  (scan-drawing (second argv) argv)
  0)

;(main)