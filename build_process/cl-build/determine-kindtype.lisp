#|

const tmp = require('tmp');
const child_process = require('child_process');
const path = require('path');
const fs = require('fs');
const isSvg = require('is-svg');

let metadata = null;

exports.main = (pin, packet, send) => {
  switch (pin) {
    case 'part metadata':
      metadata = packet;
      break;

    case 'file content':
      if (metadata === null) {
        console.error('No metadata received');
        return;
      }

      let manifestContent;

      try {
        manifestContent = JSON.parse(packet);
      } catch (e) {
        console.error('Incoming packet is not a valid JSON string.');
        return;
      }

      if (! manifestContent.kindType) {
        console.error('Property "kindType" expected');
        return;
      }

      if (manifestContent.kindType === 'schematic') {
        send('schematic metadata', metadata);
      } else {
        send('leaf metadata', metadata);
      }
      break;
  }
};

|#

(in-package :arrowgrams/build/cl-build)

;; part signature:
;; iterator :code '(:start :continue :done) '("get a part")
;;                ^input pins               ^output pins

(defclass iterator-part (e/part) ())

(defmethod first-time ((self iterator)
  (@set-instance-var self :state :stopped))

(defmethod react ((self iterator) (event e/event))
  (let ((pin-sym (@get-pin self e))) ;; also checks validity of input pin name
    
    (ecase (@get-instance-var self :state)

      (:stopped
       (ecase pin-sym
         (:start
          (@set-instance-var self :state :started)))
       (otherwise nil)) ;; no action (we could have used "case" instead of ecase to avoid writing this otherwise clause)

      (:started
       (ecase pin-sym
         (:continue
          (@send self "get a part" T))
         (:done
          (@set-instance-var self :state :stopped))
         (otherwise
          nil))))))