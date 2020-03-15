(in-package :arrowgrams/build)

(defclass runner (builder)
  ()
)

(defmethod e/part:first-time ((self runner))
)

(defmethod e/part:react ((self runner) e)
)
