;(load "/home/tarvydas/quicklisp/setup.lisp")
;(ql:quickload "xmls")
;(ql:quickload "cl-ppcre")

;;; (defsystem ebp (:optimize ((speed 0) (space 0) (safety 3) (debug 3) (float 1)))
;;;   :members ("ebp.lisp"
;;;             "container.lisp"
;;;             "test1.lisp"
;;;             )
;;;   :rules ((:compile :all (:requires (:load :previous)))))

(defsystem svg-to-fb (:optimize ((speed 0) (space 0) (safety 3) (debug 3) (float 1)))
  :members ("main.lisp"
            "arrows.lisp"
            "tofb.lisp"
            "translate.lisp"
            )
  :rules ((:compile :all (:requires (:load :previous)))))

