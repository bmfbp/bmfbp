(in-package :e/receiver)

;; a Receiver is an object stored in a Wire, a Wire can hold multiple Receivers
;; an event is delivered to all Receivers on a Wire "at the same time"

;; a Receiver stores a unique pair - the Part and the Pin (of that Part) which will receive an Event.

;; There are 2 cases for receiving events
;; 1.  A Receiver (child (used to be inbound)) delivers the event to the input queue of a Code Part or a Schematic Part.
;; 2.  A Receiver (self (used to be outbound)) delivers the event to the output queue of its enclosing Schematic Part.
;; 
;; update 20191126 - the direction of the pin determines child/self - a receiver represents a child if the pin is :input, 
;;   and represents a schematic :self if the pin is :output

(defclass receiver ()
  ((receiver-pin :accessor receiver-pin  :initarg :receiver-pin)
   (debug-name :accessor debug-name :initarg :debug-name :initform "")))

(defun new-receiver (&key (pin nil))
  (make-instance 'receiver :receiver-pin pin))

(defmethod print-object ((obj receiver) out)
  (format out "<receiver[")
  (print-object (receiver-pin obj) out)
  (format out "/~a>" (debug-name obj)))

(defmethod clone-with-mapping (proto-self proto-map cloned-self cloned-map (proto receiver))
  (let ((new (make-instance 'receiver)))
    (setf (receiver-pin new) (e/pin::dup-pin proto-self proto-map cloned-self cloned-map (receiver-pin proto)))
    (setf (debug-name new) (format nil "cloned receiver ~S" (debug-name proto)))
    new))

;; two receivers are equal if they have the same type, same part and same pin symbol

(defmethod receiver-equal ((r1 receiver) (r2 receiver))
  (e/pin::pin-equal (receiver-pin r1) (receiver-pin r2)))

(defmethod receiver-part ((r receiver))
  (e/pin::get-part (receiver-pin r)))

;; At this point, the Event contains the originating output pin.  The pin must
;; be rewritten to match that of the receiving pin, and the newly-created event is pushed
;; onto the input queue of the receiving part.

(defmethod deliver-event ((r receiver) (e e/event:event))
  (let ((pin (receiver-pin r)))
    (let ((new-e (e/event::new-event :event-pin pin :data (e/event:data e) :tag (e/event:tag e) :detail (e/event:detail e))))
      (e/pin::receive-event pin new-e))))

(defmethod ensure-receiver-sanity (schem (self receiver))
  (e/pin::ensure-sanity schem (receiver-pin self)))
