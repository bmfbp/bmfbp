(in-package :arrowgram)

(paip::<- (find-and-assert-comments-query)
(lisp ?junk1 (format *error-output* "~&in find-and-assert-comments-query 1~%"))
    (speechbubble ?bid)
(lisp ?junk2 (format *error-output* "~&in find-and-assert-comments-query 2~%"))
    (text ?textid ?str)
(lisp ?junk3 (format *error-output* "~&in find-and-assert-comments-query 3~%"))
    (textCompletelyInsideBox ?textid ?bid)
(lisp ?junk4 (format *error-output* "~&in find-and-assert-comments-query 4~%"))
    !
    (paip::add-clause `((used ,textid)))
    (paip::add-clause `((comment ,textid))))

(paip::<- (find-and-assert-comments-query)
(lisp ?junk5 (format *error-output* "~&in find-and-assert-comments-query fatal~%"))
    (paip::add-clause `((log "FATAL error in find-comments"))))

(paip::<- (textCompletelyInsideBox ?TextID ?BubbleID)
    (pointCompletelyInsideBoundingBox ?TextID ?BubbleID))



(defun find-comments ()
(format *error-output* "~&starting find-and-assert-comments-query~%")
  (paip::prove-all '((find-and-assert-comments-query)) paip::no-bindings)
(format *error-output* "~&ending find-and-assert-comments-query~%"))
