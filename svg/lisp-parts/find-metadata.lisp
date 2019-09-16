(in-package :arrowgram)

(paiprolog:<- (metadata-completely-inside-bounding-box ?TextID ?BoxID)
    (center-completely-inside-bounding-box ?TextID ?BoxID))

(defun find-metadata ()
  (let ((meta-list
         (paiprolog:prolog-collect (?MID ?Rect ?main)
           (metadata ?MID ?Textid)
           (rect ?Rect)
           (metadata-completely-inside-bounding-box ?Textid ?Rect)
           (component ?Main))))
    (format *error-output* "~&meta ~S~%" meta-list)
    (mapc #'(lambda (lis)
              (destructuring-bind (mid rect main) lis
                (paiprolog::add-clause `((roundedrect ,rect)))
                (paiprolog::add-clause `((parent ,main ,rect)))
                (paiprolog::add-clause `((log ,rect "box_is_meta_data")))
                #+nil(paiprolog::retract-clause `(rect ,rect))))
          meta-list)))
  

#|

;        (paiprolog::add-clause `((roundedrect ?Rect)))
;       (paiprolog::add-clause `((parent ?Main ?Rect))))



;    (declare (ignore dont-care))))



           #+nil(asserta (roundedrect ?Rect))
           #+nil(asserta (parent ?Main ?Rect))
           #+nil(asserta (log ?Rect "box_is_meta_data"))
           #+nil(retract (rect ?Rect))
|#