;; usage:
;; (ql:quickload :cl-event-passing/forever)
;; (cl-event-passing-user::forever)
;;
;; this should go into an infinite loop sending messages to itself

(in-package :cl-event-passing-user)

(defun forever ()
  (let ((net (@defnetwork forever-schem
		(:code unity (:in) (:out))
		(:code unity1 (:in) (:out))
		(:code unity2 (:in) (:out))

		(:schem inner (:in) (:out)
                 (unity)
                 "
                        self.in -> unity.in
                        unity.out -> self.out
                        "
                 )
                
                (:schem middle (:in) (:out)
                 (inner unity1 unity2)
                 "
                 self.in,unity2.out -> unity1.in
                 unity1.out -> inner.in
                 inner.out -> unity2.in
                 "
                 )

		(:schem forever-schem (:in) (:out)
			(middle)
			"
                        self.in -> middle.in
                        "
                        )
                
		)))
    (@with-dispatch
      (let ((top-pin (e/part::get-input-pin net :in)))
        (@inject net top-pin t)))))

(defun forever4 ()
  (let ((net (@defnetwork forever-schem
		(:code unity (:in) (:out))
		(:code unity1 (:in) (:out))
		(:code unity2 (:in) (:out))

		(:schem inner (:in) (:out)
                 (unity)
                 "
                        self.in -> unity.in
                        unity.out -> self.out
                        "
                 )
                
                (:schem middle (:in) (:out)
                 (inner unity1 unity2)
                 "
                 self.in -> unity1.in
                 unity1.out -> inner.in
                 inner.out -> unity2.in
                 unity2.out -> self.out
                 "
                 )

		(:schem forever-schem (:in) (:out)
			(middle)
			"
                        self.in,middle.out -> middle.in
                        "
                        )
                
		)))
    (@with-dispatch
      (let ((top-pin (e/part::get-input-pin net :in)))
        (@inject net top-pin t)))))

(defun forever3 ()
  (let ((net (@defnetwork forever-schem
		(:code unity (:in) (:out))

		(:schem inner (:in) (:out)
                 (unity)
                 "
                        self.in -> unity.in
                        unity.out -> self.out
                        "
                 )
                
                (:schem middle (:in) (:out)
                 (inner)
                 "
                 self.in -> inner.in
                 inner.out -> self.out
                 "
                 )

		(:schem forever-schem (:in) (:out)
			(middle)
			"
                        self.in,middle.out -> middle.in
                        "
                        )
                
		)))
    (@with-dispatch
      (let ((top-pin (e/part::get-input-pin net :in)))
        (@inject net top-pin t)))))

(defun forever2 ()
  (let ((net (@defnetwork forever-schem
		(:code unity (:in) (:out))

		(:schem inner (:in) (:out)
			(unity)
			"
                        self.in -> unity.in
                        unity.out -> self.out
                        "
                        )
                
		(:schem forever-schem (:in) (:out)
			(inner)
			"
                        self.in,inner.out -> inner.in
                        "
                        )
                
		)))
    (@with-dispatch
      (let ((top-pin (e/part::get-input-pin net :in)))
        (@inject net top-pin t)))))

