(<- (find-and-assert-comments-query)
    (speechbubble ?bid)
    (text ?textid ?str)
    (textCompletelyInsideBox ?textid ?bid)
    !
    (add-clause `((used ,textid)))
    (add-clause `((comment ,textid))))

(defun find-comments ()
  (prove-all '((find-and-assert-comments-query)) no-bindings))