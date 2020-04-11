b(in-package :arrowgrams/parser)

#+nil(defrule tId (and tLCLetter (* tOthLetter) #\, (* #\Space))
  (:text t))

(defrule tId (or tLCLetter
                 (and tLCLetter tOthLetter)))

(defrule tId2 (or tLCLetter tDoubleLC))
(defrule tDoubleLC (and tLCLetter tLCLetter))

(defrule tSpc #\Space)

(defrule tLCLetter (character-ranges (#\a #\z)))
(defrule tOthLetter (or (character-ranges (#\A #\Z))
                          (character-ranges (#\a #\z))
                          (character-ranges (#\0 #\9))
                          "_"))


(defun xx ()
  (trace-rule 'tId2 :recursive t)
  (pprint (parse 'tId2 "a"))
  (pprint (parse 'tId2 "aa")))
  

