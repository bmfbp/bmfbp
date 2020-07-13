(defpackage cl-event-passing
  (:use :cl))

(defpackage cl-event-passing-user
  ;; top level API
  (:use :cl)
  (:export

   #:@data
   #:@pin
   #:@defnetwork
   
   #:@new-schematic
   #:@new-code
   #:@reuse-part
   #:@new-wire
   #:@new-event
   #:@initialize
   #:@top-level-schematic
   #:@set-first-time-handler
   #:@set-input-handler
   #:@add-receiver-to-wire
   #:@add-source-to-schematic
   #:@add-part-to-schematic
   #:@send
   #:@send-event
   #:@start-dispatcher
   #:@history
   #:@enable-logging
   #:@enable-tracing
   #:@defnetwork
   #:@with-dispatch

   #:@get-input-pin
   #:@get-output-pin

   #:@set
   #:@get
   ))

(defpackage cl-event-passing-part
  (:nicknames :e/part)
  (:use :cl)
  (:export
   #:busy-p
   #:react
   #:first-time
   #:clone

   #:part
   #:code
   #:schematic
   #:name
   #:input-queue
   #:has-input-queue-p
   #:output-queue
   #:has-output-queue-p
   #:busy-flag
   #:namespace-input-pins
   #:namespace-output-pins
   #:input-handler
   #:first-time-handler

   #:sources
   #:internal-parts
   #:internal-wires

   #:parent-schem))

(defpackage cl-event-passing-event
  (:nicknames :e/event)
  (:use :cl)
  (:export
   #:event
   #:new-event
   #:event-pin
   #:data
   #:tag
   #:detail
   #:display-event
   #:display-output-events
   ))

(defpackage cl-event-passing-source
  (:nicknames :e/source)
  (:use :cl)
  (:export
   #:source
   #:source-pin
   #:wire))

(defpackage cl-event-passing-receiver
  (:nicknames :e/receiver)
  (:use :cl)
  (:export
   #:receiver-part
   #:receiver-pin
   #:receiver))

(defpackage cl-event-passing-schematic
  (:nicknames :e/schematic)
  (:use :cl)
  (:export
   #:clone
   #:name
   #:input-queue
   #:output-queue
   #:busy-flag
   #:namespace-input-pins
   #:namespace-output-pins
   #:input-handler
   #:first-time-handler
   #:parent-schem))

(defpackage cl-event-passing-dispatch
  (:nicknames :e/dispatch)
  (:use :cl))

(defpackage cl-event-passing-user-util
  (:nicknames :e/util)
  (:use :cl)
  (:export
   #:logging
   #:ensure-in-list
   #:ensure-not-in-list))

(defpackage cl-event-passing-user-wire
  (:nicknames :e/wire)
  (:use :cl)
  (:export
   #:wire
   #:receivers))

(defpackage cl-event-passing-pin
  (:nicknames :e/pin)
  (:use :cl)
  (:export
   #:pin
   #:input-pin
   #:output-pin
   #:pin-name
   #:pin-parent))

