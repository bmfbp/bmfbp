(in-package :cl-event-passing)

(defun net-parser (net)
  net)
  
(defun destring (str)
  (if (string= "self" str)
      :self
    (intern (string-upcase str))))

(defun pin-name (str)
  (intern (string-upcase str) "KEYWORD"))

