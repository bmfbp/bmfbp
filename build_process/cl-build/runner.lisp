(in-package :arrowgrams/build)

(defclass runner (builder)
  ()
)

(defmethod e/part:first-time ((self runner))
)

(defmethod e/part:react ((self runner) e)
  (format *standard-output* "~&**** runner gets pin ~s~%" (@pin self e))
  (test-hw))