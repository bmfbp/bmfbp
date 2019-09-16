(in-package :arrowgram)

(paiprolog:<- (text-completely-inside-box ?TextID ?BubbleID)
    (point-completely-inside-bounding-box ?TextID ?BubbleID))

(defun find-comments ()
  (let ((all-speechbubble-pairs (paiprolog:prolog-collect (?bid ?tid)
                             (speechbubble ?bid)
                             (text ?tid ?)
                             (text-completely-inside-box ?tid ?bid))))
    (format *error-output* "~&~%speechbubbles ~S~%" all-speechbubble-pairs)
    (mapc #'(lambda (pair)
              (let ((tid (second pair)))
                (paiprolog::add-clause `((used ,tid)))
                (paiprolog::add-clause `((comment ,tid)))))
          all-speechbubble-pairs)))




;;; (paiprolog:<-- (find-and-assert-comments-query)
;;; (lisp ?junk1 (format *error-output* "~&in find-and-assert-comments-query 1~%"))
;;;     (speechbubble ?bid)
;;; (lisp ?junk2 (format *error-output* "~&in find-and-assert-comments-query 2~%"))
;;;     (text ?textid ?str)
;;; (lisp ?junk3 (format *error-output* "~&in find-and-assert-comments-query 3~%"))
;;;     (textCompletelyInsideBox ?textid ?bid)
;;; (lisp ?junk4 (format *error-output* "~&in find-and-assert-comments-query 4~%"))
;;;     !
;;;     (add-clause `((used ,textid)))
;;;     (add-clause `((comment ,textid))))

;;; (paiprolog:<-- (find-and-assert-comments-query)
;;; (lisp ?junk5 (format *error-output* "~&in find-and-assert-comments-query fatal~%"))
;;;     (add-clause `((log "FATAL error in find-comments"))))

;;; (paiprolog:<-- (textCompletelyInsideBox ?TextID ?BubbleID)
;;;     (pointCompletelyInsideBoundingBox ?TextID ?BubbleID))



;;; (defun find-comments ()
;;; (format *error-output* "~&starting find-and-assert-comments-query~%")
;;;   (prove-all '((find-and-assert-comments-query)) no-bindings)
;;; (format *error-output* "~&ending find-and-assert-comments-query~%"))
