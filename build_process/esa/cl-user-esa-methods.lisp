(in-package :cl-user)

(proclaim '(optimize (debug 3) (safety 3) (speed 0)))


(defclass schematic (node) () )

(defmethod initially ((self schematic))
  )

;; for bootstrap - make names case insensitive - downcase everything

(defun esa-if-failed-to-return-true-false (msg)
  (error (format nil "esa-if - expr did not return :true or :false ~s" msg)))

(defun esa-expr-true (x)
  (cond ((eq :true x) t)
        ((eq :false x) nil)
        (t (error (format nil "~&esa expression returned /~s/, but expected :true or :false" x)))))
  

  
(defmethod install-input-pin ((self kind) name)
  (push (string-downcase name) (input-pins self)))

(defmethod install-output-pin ((self kind) name)
  (push (string-downcase name) (output-pins self)))

(defmethod install-initially-function ((self kind) fn)
  (assert nil)) ;; should be explicitly defined in each class

(defmethod install-react-function ((self kind) fn)
  (assert nil)) ;; should be explicitly defined in each class

(defmethod install-wire ((self kind) (w wire))
  (push w (wires self)))

(defmethod install-part ((self kind) name kind node-class)
  (let ((p (make-instance 'part-definition)))
    (setf (part-name p) (stack-dsl:tolower name))
    (setf (part-kind p) kind)
    (push p (parts self))))

(defmethod kind-find-part ((self kind) name)
  (dolist (p (parts self))
    (when (string=-downcase name (part-name p))
      (return-from kind-find-part p)))
  (assert nil)) ;; no part with given name - can't happen


(defmethod ensure-part-not-declared ((self kind) name)
  (dolist (part (parts self))
    (when (string=-downcase name (part-name part))
      (error (format nil "part ~a already declared in ~s ~s" name (kind-name self) self))))
   T)

(defmethod ensure-valid-input-pin ((self kind) name)
  (dolist (pin-name (input-pins self))
    (when (string=-downcase pin-name name)
      (return-from ensure-valid-input-pin T)))
  (error (format nil "pin ~a is not an input pin of ~s ~s" name (kind-name self) self)))

(defmethod ensure-valid-output-pin ((self kind) name)
  (dolist (pin-name (output-pins self))
    (when (string=-downcase pin-name name)
      (return-from ensure-valid-output-pin T)))
  (error (format nil "pin /~a/ is not an output pin of ~s ~s" name (kind-name self) self)))


(defmethod ensure-input-pin-not-declared ((self kind) name)
  (when (slot-boundp self 'input-pins)
    (dolist (pin-name (input-pins self))
      (when (string=-downcase pin-name name)
	(error (format nil "pin /~a/ is already declared as an input pin of ~s ~s" name (kind-name self) self)))))
  T)

(defmethod ensure-output-pin-not-declared ((self kind) name)
  (dolist (pin-name (output-pins self))
    (when (string=-downcase pin-name name)
      (error (format nil "pin /~a/ is already declared as an output pin of ~s ~s" name (kind-name self) self))))
  T)

(defmethod load-file ((self kind) fname)
  (let ((filename (arrowgrams/build::fixup-root-reference fname)))
    (cl:load filename)))

(defmethod refers-to-self? ((self source))
  (if (string=-downcase "self" (part-name self))
      :true
     :false))

(defmethod refers-to-self? ((self destination))
  (if (string=-downcase "self" (part-name self))
      :true
     :false))

(defmethod refers-to-self? ((self part-pin))
  (if (string=-downcase "self" (part-name self))
      :true
     :false))


;  wires

(defmethod set-index ((self wire) i)
  (setf (index self) i))

(defmethod install-source ((self wire) part-name pin-name)
  (let ((s (make-instance 'source)))
    (setf (part-name s) (string-downcase part-name))
    (setf (pin-name s) (string-downcase pin-name))
    (push s (sources self))))
          
(defmethod install-destination ((self wire) part-name pin-name)
  (let ((d (make-instance 'destination)))
    (setf (part-name d) (string-downcase part-name))
    (setf (pin-name d) (string-downcase pin-name))
    (push d (destinations self))))


;; nodes


(defmethod clear-input-queue ((self node))
  (setf (input-queue self) nil))

(defmethod clear-output-queue ((self node))
  (setf (output-queue self) nil))

; (defmethod instances ((self node)) ;; already defined in declaration of accessor
  
; (defmethod intially ((self node))  needs to be explicitly declared in each class instance

(defmethod initially ((self node))
  ;; graphs have no initially
  ;; leaves might have an initially
  ;; (call-next-method) ends up here - nothing to do
  (format *error-output* "~&initially on ~s ~s~%" (name-in-container self) self))

(defmethod display-output-events-to-console-and-delete ((self node))
  (dolist (e (get-output-events-and-delete self))
    (format *standard-output* "~s" (data e))))
    ;(format *standard-output* "~&~s outputs on pin ~s : ~s~%" (name-in-container self) (pin-name (partpin e)) (data e))))

(defmethod flagged-as-busy? ((self node))
  (if (busy-flag self)
      :true
     :false))

(defmethod children? ((self node))
  (if (not (null (children self)))
      :true
     :false))

(defmethod has-no-container? ((self node))
  (if (null (container self))
      :true
     :false))

(defmethod send ((self node) (e event))
  (setf (output-queue self) (append (output-queue self) (list e))))

(defmethod get-output-events-and-delete ((self node))
  (let ((out-event-list (output-queue self)))
    (setf (output-queue self) nil)
    out-event-list))

(defmethod dequeue-input ((self node))
  (pop (input-queue self)))

(defmethod input-queue? ((self node))
  (if (not (null (input-queue self)))
      :true
     :false))

(defmethod has-inputs-or-outputs? ((self node))
  (if (or (not (null (input-queue self)))
	  (not (null (output-queue self))))
      :true
     :false))

(defmethod install-child ((self node) name (child node))
  (let ((pinstance (make-instance 'named-part-instance)))
    (setf (instance-name pinstance) name)
    (setf (instance-node pinstance) child)
    (push pinstance (children self))))

(defmethod enqueue-input ((self node) (e event))
  (setf (input-queue self) (append (input-queue self) (list e))))

(defmethod enqueue-output ((self node) (e event))
  (setf (output-queue self) (append (output-queue self) (list e))))

(defmethod find-wire-for-self-source ((self kind) pinname)
  ;(format *standard-output* "~&find-wire-for-self-source A ~s wires.len=~s~%" (kind-name self) (length (wires self)))
  (dolist (w (wires self))
    ;(format *standard-output* "~&find-wire-for-self-source B ~s sources=~s~%" w (sources w))
    (dolist (s (sources w))
      ;(format *standard-output* "~&find-wire-for-self-source C ~s ~s~%" pinname (pin-name s))
      (when (string=-downcase pinname  (pin-name s))
        (return-from find-wire-for-self-source w))))
  (error (format nil "source pin ~a not found"  pinname)))

(defmethod find-wire-for-source ((self kind) part-name pin-name)
  ;(format *standard-output* "~&find-wire-for-source ~s ~s in ~s ~s ~%" part-name pin-name (kind-field self) self)
  (dolist (w (wires self))
    (dolist (s (sources w))
      (when (and (or (string= "self" (part-name s))
                     (string=-downcase part-name (part-name s)))
                 (string=-downcase pin-name  (pin-name s)))
        (return-from find-wire-for-source w))))
  (make-instance 'wire)) ;;(assert nil)) ;; source not found - can't happen - NC!

(defmethod node-find-child ((self node) name)
  ;(format *standard-output* "~&node-find-child of ~s wants ~s~%" (name-in-container self) name)
  (dolist (p (children self))
    (when (string=-downcase name (instance-name p))
      (return-from node-find-child p)))
  (assert nil)) ;; no part with given name - can't happen

(defmethod ensure-kind-defined ((self part-definition))
  (unless (eq 'kind (type-of (part-kind self)))
    (error (format nil "kind for part ~a is not defined (check if manifest is correct)" (part-name self)))))


(defmethod memo-node ((self dispatcher) (n node))
  (push n (all-parts self)))

(defmethod set-top-node ((self dispatcher) (n node))
  (setf (top-node self) n))

(defmethod declare-finished ((self dispatcher))
  #+nil(format *standard-output* "~&~%Dispatcher Finished~%~%"))


(defun string=-downcase (a b)
  (string= (string-downcase (stack-dsl:%as-string a)) (string-downcase (stack-dsl:%as-string b))))

(defmethod get-destination ((self event))
  (let ((d (make-instance 'destination)))
    (setf (part-name d) (part-name self))
    (setf (pin-name d) (pin-name self))))

(defmethod react ((self node) (e event))
  (run-composite-reaction self e))

(defmethod create-top-event ((self dispatcher) pinName val)
  (let ((e  (make-instance 'cl-user::event))
        (pp (make-instance 'cl-user::part-pin)))
    (setf (cl-user::part-name pp) "self")
    (setf (cl-user::pin-name pp) pinName)
    (setf (cl-user::partpin e) pp)
    (setf (cl-user::data e) val)
    e))

;;;;;;;;;;;;;;;
;; App
;;;;;;;;;;;;;;;

(defmethod initialize ((self App)) 
  (setf (alist self) (arrowgrams/build::json-to-alist (json-string self)))
  (setf (tableOfKinds self) (make-hash-table :test 'equal)))

(defmethod fatalErrorInBuild ((self App))
  (error "fatal error in build"))

(defmethod JSON ((self App))
  (alist self))

(defmethod nothing ((self App))
  :undefined)

(defmethod lookupKind ((self App) name)
  ;; hash table lookup with key name 
  (gethash (string-downcase (stack-dsl:%as-string name)) (tableOfKinds self)))

(defmethod installInTable ((self App) kind-name kind-object)
  (setf (gethash (string-downcase (stack-dsl:%as-string kind-name)) (tableOfKinds self)) kind-object))


;;; kind methods during reading JSON phase

(defmethod schematicCommonClass ((self kind))
  'schematic)

(defmethod make-type-name ((self kind) str)
  ;; do any magic required by base language to create a type 
  ;;  name from the string str
  ;; in Lisp, we can just use the string str and intern it in the main package
  (intern (string-upcase (stack-dsl:%as-string str)) "COMMON-LISP-USER"))


;; JSON-array

(defmethod as-map ((self CONS #|JSON-array|#))
  ;; maps are just Lisp lists in this version
  self)

;; CONS #|JSON-object|#

(defmethod isLeaf ((self CONS #|JSON-object|#))
  ;; internally, we keep JSONparts as ALISTs in a list (aka map)
  ;; This choice is Lisp-specific,  we might choose a different kind of 
  ;;  representation in JS, say.  The choice is not visible at 
  ;;  the esa.scl (formerly esa.dsl) level - we only talk about 
  ;;  CONS #|JSON-object|#s and maps of CONS #|JSON-object|#s, then query them using external methods
  (if (string= "leaf" (cdr (assoc :item-kind self))) :true :false))

(defmethod isSchematic ((self CONS #|JSON-object|#))
  (if (string= "graph" (cdr (assoc :item-Kind self))) :true :false))

(defmethod name ((self CONS #|JSON-object|#))
  (cdr (assoc :name self)))

(defmethod itemKind ((self CONS #|JSON-object|#))
  (cdr (assoc :itemKind self)))


(defmethod kind ((self CONS #|JSON-object|#))
  (cdr (assoc :kind self)))
(defmethod filename ((self CONS #|JSON-object|#))
  (cdr (assoc :filename self)))
(defmethod inPins ((self CONS #|JSON-object|#))
  (cdr (assoc :in-Pins self)))
(defmethod outPins ((self CONS #|JSON-object|#))
  (cdr (assoc :out-Pins self)))


;; level 1
(defmethod schematic ((self CONS #|JSON-object|#))
  (cdr (assoc :graph self)))
;(defmethod name ((self CONS #|JSON-object|#))
;  (cdr (assoc :name self)))

;; level 2
(defmethod inputs ((self CONS #|JSON-object|#))
  (cdr (assoc :inputs self)))
(defmethod outputs ((self CONS #|JSON-object|#))
  (cdr (assoc :outputs self)))
(defmethod parts ((self CONS #|JSON-object|#))
  (cdr (assoc :parts self)))
(defmethod wiring ((self CONS #|JSON-object|#))
  (cdr (assoc :wiring self)))
;; level 3a
(defmethod partName ((self CONS #|JSON-object|#))
  (cdr (assoc :part-Name self)))
(defmethod kindName ((self CONS #|JSON-object|#))
  (cdr (assoc :kind-Name self)))
;; level 3b
(defmethod wireIndex ((self CONS #|JSON-object|#))
  (cdr (assoc :wire-Index self)))
(defmethod sources ((self CONS #|JSON-object|#))
  (cdr (assoc :sources self)))
(defmethod receivers ((self CONS #|JSON-object|#))
  (cdr (assoc :receivers self)))
;; level 4
(defmethod part ((self CONS #|JSON-object|#))
  (cdr (assoc :part self)))
(defmethod pin ((self CONS #|JSON-object|#))
  (cdr (assoc :pin self)))


;;;;;;;;;;
;; example JSON
;;;;;;;;;;
#|
[
    {
	"itemKind":"leaf",
	"name":"string-join",
	"inPins":["a","b"],
	"outPins":["c","error"],
	"kind":"string-join",
	"filename":"$\/parts\/cl\/.\/string-join.lisp"
    },
    {"itemKind":"leaf","name":"world","inPins":["start"],"outPins":["s","error"],"kind":"world","filename":"$\/parts\/cl\/.\/world.lisp"},
    {"itemKind":"leaf","name":"hello","inPins":["start"],"outPins":["s","error"],"kind":"hello","filename":"$\/parts\/cl\/.\/hello.lisp"},

    {
	"itemKind":"graph",
	"name":"helloworld",
	"graph":{"name":"HELLOWORLD",
		 "inputs":["START"],
		 "outputs":["RESULT"],
		 "parts":
		 [
		     {"partName":"STRING-JOIN","kindName":"STRING-JOIN"},
		     {"partName":"WORLD","kindName":"WORLD"},
		     {"partName":"HELLO","kindName":"HELLO"}
		 ],
		 "wiring":
		 [
		     {
			 "wireIndex":0,
			 "sources":[{"part":"HELLO","pin":"S"}],
			 "receivers":
			 [
			     {"part":"STRING-JOIN","pin":"A"}
			 ]
		     },
		     {"wireIndex":1,"sources":[{"part":"WORLD","pin":"S"}],"receivers":[{"part":"STRING-JOIN","pin":"B"}]},
		     {"wireIndex":2,"sources":[{"part":"STRING-JOIN","pin":"C"}],"receivers":[{"part":"SELF","pin":"RESULT"}]},
		     {"wireIndex":3,"sources":[{"part":"SELF","pin":"START"}],"receivers":[{"part":"WORLD","pin":"START"},{"part":"HELLO","pin":"START"}]}
		 ]
		}
    }
]
|#

