(in-package :cl-user)

(prove:plan 1)
(let ((form '(loops:loop :for i :upto 7 :collecting i)))
  (prove:ok 
   (= 
    (length (macroexpand-1 form))
    (length '(LOOP :FOR I :UPTO 7 :COLLECTING I)))
   "Simple LOOPS:LOOP expansion"))

(prove:plan 1)
(prove:is
 (let ((result (loops:loop :for i :upto 7 :summing i)))
   result)
 28
 "Summing the first seven integers")

(prove:finalize)

