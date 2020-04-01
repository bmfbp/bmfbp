;; usage:
;; (ql:quickload :cl-event-passing/nesting-test)
;; (cl-event-passing-user::nesting)
;; strcat1 should always print abCdeF regardless of (printed) execution order

(in-package :cl-event-passing-user)

(defun nesting ()
  (let ((net (@defnetwork nest
		(:code strcat1 (:x :y) (:out))
		(:code strcat2 (:x :y) (:out))
		(:code strcat3 (:x :y) (:out))
		(:code strcat4 (:x :y) (:out))
		(:code strcat5 (:x :y) (:out))

		(:code lowA (:in) (:out))
		(:code capA (:in) (:out))
		(:code lowB (:in) (:out))
		(:code capB (:in) (:out))
		(:code lowC (:in) (:out))
		(:code capC (:in) (:out))
		(:code lowD (:in) (:out))
		(:code capD (:in) (:out))
		(:code lowE (:in) (:out))
		(:code capE (:in) (:out))
		(:code lowF (:in) (:out))
		(:code capF (:in) (:out))

		(:schem lowest (:in) (:out)
			(lowA lowB strcat3)
			"
                        self.in -> lowA.in, lowB.in
                        lowA.out -> strcat3.x
                        lowB.out -> strcat3.y
                        strcat3.out -> self.out
                        ")
		(:schem middle (:in) (:out)
			(capC lowest strcat2)
			"
                        self.in -> lowest.in,capC.in
                        lowest.out -> strcat2.x
                        capC.out   -> strcat2.y
                        strcat2.out -> self.out
                        ")
		(:schem lowest2 (:in) (:out)
			(lowD lowE lowF strcat5)
			"
                        self.in -> lowD.in, lowE.in
                        lowD.out -> strcat5.x
                        lowE.out -> strcat5.y
                        strcat5.out -> self.out
                        ")
		(:schem middle2 (:in) (:out)
			(capD capE capF lowest2 strcat4)
			"
                        self.in -> lowest2.in,capF.in
                        lowest2.out -> strcat4.x
                        capF.out    -> strcat4.y
                        strcat4.out -> self.out
                        ")
		(:schem nest (:in) (:out)
			(middle middle2 strcat1)
			"
                        self.in -> middle.in,middle2.in
                        middle.out  -> strcat1.x
                        middle2.out -> strcat1.y
                        strcat1.out -> self.out
                        ")
		)))
    (@with-dispatch
      (let ((top-pin (e/part::get-input-pin net :in)))
        (@inject net top-pin t)))))

