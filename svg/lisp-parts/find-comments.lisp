(in-package :arrowgram)

; calling this results in 2 answers instead of 1
;(paiprolog:<- (text-completely-inside-box ?TextID ?BubbleID)
;    (point-completely-inside-bounding-box ?TextID ?BubbleID))

(defun find-comments ()
  (let ((all-speechbubble-pairs (paiprolog:prolog-collect (?bid ?tid)
                             (speechbubble ?bid)
                             !
                             (text ?tid ?)
                             (point-completely-inside-bounding-box ?tid ?bid))))
    (format *error-output* "~&~%speechbubbles ~S~%" all-speechbubble-pairs)
    (mapc #'(lambda (pair)
              (let ((tid (second pair)))
                (paiprolog::add-clause `((used ,tid)))
                (paiprolog::add-clause `((comment ,tid)))))
          all-speechbubble-pairs)))
