(in-package :arrowgrams/build)

(defclass part-namer (loader)
  ((counter :accessor counter)))

(defmethod e/part:first-time ((self part-namer))
  (setf (counter self) 0))

(defmethod e/part:react ((self part-namer) e)
(incf (counter self))
(format *standard-output* "~&~loader gets ~a ~s~%" (counter self) (@pin self e) (@data self e))
  (ecase (@pin self e)
    (:json-script
     (let ((json-script (@data self e)))
       (let ((alist-script (with-input-from-string (s json-script) (json:decode-json s))))
         (perform-loading alist-script)
         (let ((top-name (find-top-schematic-name alist-script)))
           (@send self :function top-name))))

(defun perform-loading (alist-script)
  (mapc #'(lambda (alist-item)
            (let ((item-kind (cdr (assoc :item-kind item))))
              (ecase item-kind
                (:leaf
                 (load-file (cdr (assoc :filename item))))
                (:graph
                 (load-graph (cdr (assoc :graph item)))))))
        alist-script))

(defun load-file (filename)
  (load filename))

;;;;;;;; helper functions that might make the code less lispy...  (ie. don't try to read these helpers until you want more lispy detail)

(defun alist-get (keyword alist)
  (cdr (assoc keyword alis)))

(defstruct wire  ;; create struct using (make-wire :sources ... :receivers ...)
  sources
  receivers)

(defun make-wire-struct (&key (sources nil) (receivers nil))
  (make-wire :sources source :receivers receivers))

(defun put-in-hash-table (hash-table key data)
  (setf (gethash key hash-table) data))

;;;;;;;;;;;;;
#|
    {"itemKind":"leaf","name":"top_level_name","fileName":"/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/lispparts/top_level_name.lisp"},
    {	"graph":{
	    "name":"IDE",
	    "inputs":null,
	    "outputs":null,
	    "parts":[
		{"partName":"BUILD-PROCESS","kindName":"BUILD-PROCESS"},
		{"partName":"TOP-LEVEL-NAME","kindName":"TOP-LEVEL-NAME"},
		{"partName":"SVG-INPUT","kindName":"SVG-INPUT"},
		{"partName":"RUN","kindName":"RUN"}
	    ],
	    "wiring":[
		{
		    "wireIndex":0,
		    "sources":[{"part":"SVG-INPUT","pin":"SVG-CONTENT"}],
		    "receivers":[{"part":"BUILD-PROCESS","pin":"TOP-LEVEL-SVG"}]
		},
		{"wireIndex":1,"sources":[{"part":"BUILD-PROCESS","pin":"JAVASCRIPT-SOURCE-CODE"}],"receivers":[{"part":"RUN","pin":"IN"}]},
		{"wireIndex":2,"sources":[{"part":"TOP-LEVEL-NAME","pin":"NAME"}],"receivers":[{"part":"BUILD-PROCESS","pin":"TOP-LEVEL-NAME"}]}
	    ]
	}},
|#

(defun load-graph (graph-alist)
  (let ((parts-hash (make-hash-table))
        (wires-hash (make-hash-table))
        (part-alist (cdr (assoc :parts graph-alist)))
        (wire-alist (cdr (assoc :wiring graph-alist))))
    (create-parts-hash parts-hash part-alist)
    (create-wires-hash wires-hash wire-alist)))


;;;
;;; niggly details - don't read this on your first pass
;;;
(defun create-parts-hash (parts-hash part-alist)
  (mapc #'(lambda (part)
            (let ((name (alist-get :part-name part-alist))
                  (kind (alist-get :kind-name part-alist)))
              (put-in-hash-table parts-hash name (make-instance-of-class kind))))
        part-alist))

(defun create-wires-hash (wires-hash wire-alist)
    (mapc #'(lambda (wire)
              (let ((index (alist-get :wire-index wire))
                    (sources (process-sources (alist-get :sources wire-alist) wire parts-hash))
                    (receivers (process-receivers (alist-get :receivers wire-alist) wire parts-hash))))
                (put-in-hash-table wires-hash index (make-wire-struct :sources sources :receivers receivers))))
          wire-alist)))

(defmethod process-sources (self sources wire parts-hash)
 ;; every source must be in the parts-hash
 ;; every pin of every source must be a source pin of the part
 ;; a source is a part+pin pair
 (let ((proceed (validate-sources sources parts-hash)))
   (if proceed
       ()
     (@send self "loader quit due to source error"))))

(defmethod process-receivers (receivers wire parts-hash)
 ;; every receiver must be in the parts-hash
 ;; every pin of every receiver must be a reciever pin of the part
 (let ((proceed (validate-receivers receivers parts-hash)))
   (if proceed
       ()
     (@send self "loader quit due to receiver error"))))

(defmethod validate-sources (self sources parts-hash)
  (let ((ok T))
    (mapc #'(lambda (pair)
              (let ((part (first pair))
                    (pin (second pair)))
                (setf ok
                      (if (eq :self part)
                          (part/query/valid-input? self part pin parts-hash :message t)
                        (part/query/valid-output? self part pin parts-hash :message t)))))
          ok)))

(defmethod validate-receivers (self sources parts-hash)
  (let ((ok T))
    (mapc #'(lambda (pair)
              (let ((part (first pair))
                    (pin (second pair)))
                (setf ok (if (eq :self part)
                              (part/query/ensure-valid-output? self part pin parts-hash :message t)
                            (part/query/ensurevalid-input? self part pin parts-hash :message t)))
                sources))
          ok)))
    