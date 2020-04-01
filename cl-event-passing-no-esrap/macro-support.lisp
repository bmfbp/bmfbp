(in-package :cl-event-passing)

;; functions that help the defnetwork macro work

(defmethod make-wire (receiver-list)
  (let ((w (cl-event-passing-user:@new-wire :name (e/util::get-wire-number))))
    (e/wire::set-receiver-list w receiver-list)
    w))

(defmethod make-sources-for-wire ((self e/part:schematic) (wire e/wire:wire) list-of-sources)
  (mapc #'(lambda (s)
            (e/source::set-wire-of-source s wire)
            (e/schematic::add-source-with-ensure self s))
        list-of-sources))

