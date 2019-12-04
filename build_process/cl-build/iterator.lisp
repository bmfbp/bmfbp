#|

let state = 'stopped';

exports.main = (pin, packet, send) => {
  switch (state) {
    case 'stopped':
      switch (pin) {
        case 'start':
          state = 'started';
          break;

        default:
          // No action needed
      }
      break;

    case 'started':
      switch (pin) {
        case 'continue':
          send('get a part', true);
          break;

        case 'done':
          state = 'stopped';
          break;

        default:
          // No action needed
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
  (let ((sym (@get-pin e)))
    (@ensure-valid-input-pin self sym)
    
    (ecase (@get-instance-var self :state)

      (:stopped
       (ecase pin
         (:start
          (@set-instance-var self :state :started)))
       (otherwise nil)) ;; no action (we could have used "case" instead of ecase to avoid writing this otherwise clause)

      (:started
       (ecase pin
         (:continue
          (@send self "get a part" T))
         (:done
          (@set-instance-var self :state :stopped))
         (otherwise
          nil))))))