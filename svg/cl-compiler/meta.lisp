(in-package :cl-user)

(setf *print-right-margin* 128)

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

(defparameter *niy-parts* 
'(
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
              (list `((,from :done)) `((,to :go))))
          (butlast *parts*)
          (cdr *parts*)))
              
(defun build-packages ()
  (mapcar #'(lambda (x)
              (with-input-from-string (s (format nil ":arrowgrams/compiler/~a" x))
                (let ((pkg (read s nil nil)))
                  `(defpackage ,pkg (:use :cl)))))
          *parts*))

(defun build-code (x)
  (format nil
          "
(in-package :arrowgrams/compiler/~a)

; (:code ~a (:fb :go) (:add-fact :done :request-fb :error) #'arrowgrams/compiler/~a::react #'arrowgrams/compiler/~a::first-time)

(defmethod first-time ((self e/part:part))
  (cl-event-passing-user::@set-instance-var self :state :idle)
  )

(defmethod react ((self e/part:part) e)
  (let ((pin (e/event::sym e))
        (data (e/event:data e)))
    (ecase (cl-event-passing-user::@get-instance-var self :state)
      (:idle
       (if (eq pin :fb)
           (cl-event-passing-user::@set-instance-var self :fb data)
         (if (eq pin :go)
             (progn
               (cl-event-passing-user::@send self :request-fb t)
               (cl-event-passing-user::@set-instance-var self :state :waiting-for-new-fb))
           (cl-event-passing-user::@send
            self
            :error
            (format nil \"~a in state :idle expected :fb or :go, but got action ~a data ~a\" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (cl-event-passing-user::@set-instance-var self :fb data)
             ;; put code here
             (cl-event-passing-user::@send self :done t)
             (cl-event-passing-user::@set-instance-var self :state :idle))
         (cl-event-passing-user::@send
          self
          :error
          (format nil \"~a in state :waiting-for-new-fb expected :fb, but got action ~a data ~a\" pin (e/event:data e))))))))
"
          x x x x x "~S" "~S" x "~S" "~S"))

                 
(defun build-all-parts ()
  (mapc #'(lambda (x)
            (let ((code (build-code x)))
              (let ((fname (string-downcase (concatenate 'string "~/tmp2/" (symbol-name x) ".lisp"))))
                (with-open-file (f fname :direction :output :if-exists :supersede :if-does-not-exist :create)
                  (format f "~a~%" code)))))
        *niy-parts*))

(defun build-code-declaration (x)
  (let ((react (intern "REACT" (format nil (string-upcase "arrowgrams/compiler/~a") x)))
        (first-time (intern "FIRST-TIME" (format nil (string-upcase "arrowgrams/compiler/~a") x))))
    `(:code ,x (:fb :go) (:add-fact :done :request-fb :error) #',react #',first-time)))
                   
(defun build-code-declarations ()
  (mapcar #'(lambda (x)
              (build-code-declaration x))
          *niy-parts*))