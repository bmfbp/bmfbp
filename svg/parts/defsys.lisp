(defsystem toprolog ()
  :members ("util"
            "toprolog"
            "fix-translate"
            "collapse-lines"
            "create-text-objects"
            "fix-arrows"
            "fix-lines"
            "main")
  :rules
  ((:in-order-to :compile :all (:requires (:load :previous)))
   ))
