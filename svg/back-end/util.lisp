(in-package :arrowgrams/compiler/back-end)

(defmethod send! ((self e/part:part) pin kind data)
  (cl-event-passing-user::@send self pin data))

(defmethod send-event! ((self e/part:part) pin (e e/event:event))
  (cl-event-passing-user::@send self (e/part::get-output-pin self pin) (e/event:data e)))

(defmethod inject! ((net e/part:part) pin data)
  (cl-event-passing-user::@with-dispatch
   (cl-event-passing-user::@inject net
                                   (e/part::get-input-pin net pin)
                                   data)))
