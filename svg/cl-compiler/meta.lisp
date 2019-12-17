(in-package :cl-user)

(defparameter *parts* 
'(
ellipse-bb
rectangle-bb
text-bb
speechbubble-bb
assign-parents-to-ellipses
find-comments
find-metadata
add-kinds
add-self-ports
make-unknown-port-names
create-centers
calculate-distances
assign-portnames
mark-indexed-ports
concident-ports
mark-directions
match-ports-to-components
pinless
sem-parts-have-some-ports
sem-ports-have-sink-or-source
sem-no-duplicate-kinds
sem-speech-vs-comments
assign-wire-numbers-to-edges
self-input-pins
self-output-pins
input-pins
output-pins
))

(defun build-fb-wires ()
  (list '((:self :fb))
         (mapcar #'(lambda (part)
                     `( ,part :fb ))
                 *parts*)))
                 
(defun build-request-wires ()
  (list (mapcar #'(lambda (part)
                     `( ,part :request-fb ))
                 *parts*)
        '((:self :request-fb))))
  
(defun build-add-fact-wires ()
  (list (mapcar #'(lambda (part)
                     `( ,part :add-fact ))
                 *parts*)
        '((:self :add-fact))))
  
(defun build-error-wires ()
  (list (mapcar #'(lambda (part)
                     `( ,part :error ))
                 *parts*)
        '((:self :error))))
  
(defun build-done-go-wires ()
  (mapcar #'(lambda (from to)
              (list `(,from :done) `(,to :go)))
          (butlast *parts*)
          (cdr *parts*)))
              
