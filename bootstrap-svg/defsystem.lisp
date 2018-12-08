(defsystem svg-to-fb (:optimize ((speed 0) (space 0) (safety 3) (debug 3) (float 1)))
  :members ("test-data"
            "toprolog"
            "fix-translate"
            "collapse-lines"
            "create-text-objects"
            "fix-arrows"
            "fix-lines"
            "main.lisp")
  :rules ((:compile :all (:requires (:load :previous)))))

