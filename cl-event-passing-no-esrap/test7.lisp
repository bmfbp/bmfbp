(in-package :cl-event-passing-user)


;; top level input goes straight to top level output

(defun test7 ()
  ;; see test6.drawio tab "top level"
  (@initialize)

  (let ((main-schem (@new-schematic :name "main schem" :input-pins '("in") :output-pins '("out")))
        ;; 1 wire
        (wire (@new-wire :name "wire")))

    (@top-level-schematic main-schem)

    ;; wires that go INTO parts
    (@add-receiver-to-wire  wire
                            (e/part::get-output-pin main-schem "out"))

    ;; wire that go OUT OF parts

    ;; need 1 source
    (@add-source-to-schematic main-schem (e/part::get-input-pin main-schem "in") wire)

    (@with-dispatch 
     (@inject main-schem (e/part::get-input-pin main-schem "in") "test 7"))))
