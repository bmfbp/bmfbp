(in-package :arrowgrams/compiler/back-end)

(defmethod send! ((self util) pin data)
  (declare (type symbol pin))
  (@send self pin data))

(defmethod send-event! ((self util) pin (e e/event:event))
  (@send self (e/part::get-output-pin self pin) (e/event:data e)))

(defmethod inject! ((net e/part:part) pin data)
  (cl-event-passing-user::@with-dispatch
   (cl-event-passing-user::@inject net
                                   (e/part::get-input-pin net pin)
                                   data)))
