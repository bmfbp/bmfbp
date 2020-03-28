(in-package :arrowgrams/build)

(defclass runner (builder)
  ()
)

(defmethod e/part:first-time ((self runner))
)

(defmethod e/part:react ((self runner) e)
  (format *standard-output* "~&**** runner gets pin ~s~%" (@pin self e))
  (let ((kgraph (@data self e)))
    (let ((d (make-instance 'dispatcher)))  ;; make one "global" dispatcher
      (format *standard-output* "~&**** loader~%")
      (let ((n (loader kgraph "TOP" nil d)))
        (format *standard-output* "~&**** finished loader~%")
        kgraph))))

