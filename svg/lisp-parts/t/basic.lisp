(in-package :cl-user)


(prove:plan 1)

(prove:ok
 (progn 
   (arrowgram::make-bounding-boxes-for-rectangles)
   (arrowgram::make-bounding-boxes-for-text)
   (arrowgram::make-bounding-boxes-for-speech-bubbles)
   (arrowgram::make-bounding-boxes-for-ellipses))
 "Testing bounding boxes.")

(prove:finalize)
