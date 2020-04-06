
;; this is "traffic cop" for all token filters
;;
;; each filter contains one traffic cop and one do-er (peer)
;; the peer watches incoming tokens and generates new tokens or simply passes tokens on
;; the traffic cop stops the peer from generating too many tokens all at once

;;
;; it can receive a request for a token from downstream 
;; it can receive a token from upstream and handles EOF
;; it can receive a generated token from its peer
;; it can receive a token request from its peer
;;
;; it will buffer up to one generated token and can "block" its peer before passing 
#|

;; token requests upstream
;;
;; we need 4 states to handle all cases and must handle all 4 kinds of inputs in each state (some inputs are illegal in some cases)
;;
;; it has two main outputs
;; 1) send a token downstream
;; 2) send a request upstream
;;
;; and 1 peer output
;; 1) send a token from upstream to its peer
;;
;; the peer might send 0, 1, or 2 tokens at a time
;;


inputs : [request peer-token peer-request]
outputs : [out request peer-wrapup token-to-peer]
vars : [buffered-token]

initially {
  self.state = idle
  self.buffered-token = nil
}

react (e : event) {
  machine {
    on upstream-token: pass-to-peer(e.data)
    else machine {
      idle:
	on downstream-request:         -> wait-for-peer
	on peer-token:                 -> block
	on peer-request: send-request
      block: 
	on downstream-request:                                          -> block2
	on peer-token: save-peer-token & send-saved-token-downstream &  -> idle
	on peer-request: send-request
      block2:
	on downstream-request: illegal
	on peer-token: save-peer-token & send-saved-token-downstream & send-request &  -> idle
	on peer-request: illegal
      wait-for-peer:
	on downstream-request: illegal
	on peer-token: save-peer-token & send-saved-token-downstream &  -> idle
	on peer-request: send-request
      }
   }
}

method save-peer-token(token) { self.saved-token = token }
method send-saved-token-downstream(token) { out <- token }
method send-request { request <- true }
method pass-to-peer (token) { token <- token }

|#


(in-package :arrowgrams)

(defclass buffer (node) ()  
  ((state :accessor state)
   (saved-token :accessor saved-token)))

(defmethod initially ((self buffer))
  (setf (state self) :idle)
  (setf (buffered-token self) nil))

(defmethod react ((self buffer) (e event))
#|
  (state :idle
	 ("upstream-token" (pass-to-peer) )
	 ("downstream-request" (next :wait-for-peer) )
	 ("peer-token" (next :block) )
	 ("peer-request" (send-request) ))
  (state :block
	 ("upstream-token" (pass-to-peer) )
	 ("downstream-request" (-> :block2) )
	 ("peer-token" (save-peer-token send-saved-token-downstream -> :idle) )
	 ("peer-request" (send-request) ))
  (state :block2
	 ("upstream-token" (pass-to-peer) )
	 ("downstream-request" (illegal) )
	 ("peer-token" (save-peer-token send-saved-token-downstream send-request -> :idle))
	 ("peer-request" (illegal) ))
  (state :wait-for-peer
	 ("upstream-token" (pass-to-peer) )
	 ("downstream-request" (illegal) )
	 ("peer-token" (save-peer-token send-saved-token-downstream -> :idle) )
	 ("peer-request" (send-rquest) )))
|#
  (ecase (state self)
    
    (:idle
     (cond ((string= "upstream-token" (pin-name (partpin e)))
	    (pass-to-peer self e))
	   ((string= "downstream-request" (pin-name (partpin e)))
	    (setf (state self) :wait-for-peer))
	   ((string= "peer-token" (pin-name (partpin e)))
	    (setf (state self) :block))
	   ((string= "peer-request" (pin-name (partpin e)))
	    (send-request self e))
	   (t (illegal))
	   ))	   
     
    (:block
     (cond ((string= "upstream-token" (pin-name (partpin e)))
	    (pass-to-peer self e))
	   ((string= "downstream-request" (pin-name (partpin e)))
	    (setf (state self) :block2))
	   ((string= "peer-token" (pin-name (partpin e)))
	    (save-peer-token self e) (send-saved-token-downstream self e) (setf (state self) :idle))
	   ((string= "peer-request" (pin-name (partpin e)))
	    (send-request self e))
	   (t (illegal))
	    ))
    
    (:block2
     (cond ((string= "upstream-token" (pin-name (partpin e)))
	    (pass-to-peer self e))
	   ((string= "downstream-request" (pin-name (partpin e)))
	    (illegal self e))
	   ((string= "peer-token" (pin-name (partpin e)))
	    (save-peer-token self e) (send-saved-token-downstream self e) (send-request self e) (setf (state self) :idle))
	   ((string= "peer-request" (pin-name (partpin e)))
	    (illegal self e))
	   (t (illegal))
	    ))
    
    (:wait-for-peer
     (cond ((string= "upstream-token" (pin-name (partpin e)))
	    (pass-to-peer self e))
	   ((string= "downstream-request" (pin-name (partpin e)))
	    (illegal self e))
	   ((string= "peer-token" (pin-name (partpin e)))
	    (save-peer-token self e) (sen-save-token-downstream) (setf (state self) :idle))
	   ((string= "peer-request" (pin-name (partpin e)))
	    (send-request self e))
	   (t (illegal))
	    )))

    ))

;; mechanisms for above state machine
(defmethod pass-to-peer ((self buffer) (e event))
  (declare (ignore buffer))
  (send-event self "token-to-peer" (data e)))

(defmethod send-request ((self buffer) (e event))
  (declare (ignore buffer))
  (send-event self "upstream-request" t))

(defmethod save-peer-token ((self buffer) (e event))
  (setf (save-token self) (data e)))

(defmethod send-saved-token-downstream ((self buffer) (e event))
  (send-event self "out" (data e))
  (reset-saved self))


;; utilities

(defmethod reset-saved ((self buffer))
  (setf (saved-token self) nil))

(defmethod send-event ((self buffer) pin-name data)
  (let ((e (make-instance 'event))
        (temp-pp (make-instance 'part-pin)))
    (setf (part-name temp-pp) (name-in-container self))
    (setf (pin-name temp-pp) pin-name)
    (setf (partpin e) temp-pp)
    (setf (data    e) data)
    (send self e)))
