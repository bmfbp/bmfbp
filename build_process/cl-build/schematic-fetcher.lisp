(in-package :arrowgrams/build)

(defclass schematic-fetcher (e/part:code)
  ())

(defmethod e/part:busy-p ((self schematic-fetcher))
  (call-next-method))

(defmethod e/part:clone ((self schematic-fetcher))
  (call-next-method))

(defmethod e/part:first-time ((self schematic-fetcher)))

(defmethod e/part:react ((self schematic-fetcher) e)
  (ecase (@pin self e)
    (:json-ref
     ;; stubbed out for now - all files reside in a working directory
     (with-input-from-string (json-ref (@data self e))
         (let ((file-ref (json:decode-json json-array)))
           (format *standard-output* "~&file ref ~S~%" file-ref))))))

    