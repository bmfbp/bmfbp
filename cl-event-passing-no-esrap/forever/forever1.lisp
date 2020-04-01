;; usage:
;; (ql:quickload :cl-event-passing/forever)
;; (cl-event-passing-user::forever)
;;
;; this should go into an infinite loop sending messages to itself

(in-package :cl-event-passing-user)

(defun forever ()
  (let ((net (@defnetwork forever-schem
		(:code unity (:in) (:out))

		(:schem forever-schem (:in) (:out)
			(unity)
			"
                        self.in,unity.out -> unity.in
                        "
                        )
		)))
    (@with-dispatch
      (let ((top-pin (e/part::get-input-pin net :in)))
        (@inject net top-pin t)))))

