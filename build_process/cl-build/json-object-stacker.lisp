#|

const stack = [];

exports.main = (pin, packet, send) => {
  switch (pin) {
    case 'push object':
      stack.push(packet);
      break;

    case 'get a part':
      if (stack.length === 0) {
        send('no more', true);
      } else {
        send('part metadata', stack.pop());
      }
      break;
  }
};

|#

;; part signature:
;; json-object-stacker :code '("push object" "get a part") '("part metadata" "no more")
;;                           ^input pins                   ^output pins

(in-package :arrowgrams/build/cl-build)

(defclass json-object-stacker (e/part) ())

(defmethod first-time ((self json-object-stacker))
  (@set-instance-var self :stack nil))

(defmethod react ((self json-object-stacker) (e e/event))
  (let ((pin-str (@get-pin self e))
        (data (@get-data self e))) 
    (cond
     ((string= "push object" pin-str)
      (@set-instance-var self :stack (cons data (@get-instance-var self :stack))))
     
     ((string= "get a part" pin-str)
      (if (null (@get-instance-var self :stack))
          (@send self "no more" t)
        (let ((stack (@get-instance-var self :stack)))
          (@set-instance-var self :stack (rest stack))
          (@send self "part metadata" (first stack)))))
     
     (otherwise
      nil))))
