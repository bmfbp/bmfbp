(in-package :arrowgram)

;(paiprolog:<- (text-completely-inside-box ?TextID ?BoxID)
;    (point-completely-inside-bounding-box ?TextID ?BoxID))

(defun add-kinds ()
  (let ((box-text-str-triples (paiprolog:prolog-collect (?boxid ?textid ?str)
                                (text ?TextId ?str)
                                (fail-if (used ?TextID))
                                (rect ?boxid)
                                (point-completely-inside-bounding-box ?TextID ?BoxID))))
    (format *error-output* "~&~%box/text/str kinds ~A~%" (length box-text-str-triples))
    (mapc #'(lambda (triple)
              (destructuring-bind (bid tid str) triple
                (paiprolog::add-clause `((used ,tid)))
                (paiprolog::add-clause `((kind ,bid ,str)))))
          box-text-str-triples)))
