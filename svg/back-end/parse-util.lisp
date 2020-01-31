;;
;; sl mechanisms used (see ~/attic/json.sl.lisp)
;;
;; :string print-text
;; :integer print-text
;; inc dec
;; nl
;; symbol-must-be-nil
;;



(in-package :arrowgrams/compiler/back-end)

(defclass pair ()
  ((pair-first :accessor pair-first)
   (pair-second :accessor pair-second)))

;;;;;;; lists

(defclass collection ()
  ((collection :accessor collection :initform nil)))

(defmethod add ((self collection) item)
  (push item (collection self)))

(defmethod as-list ((self collection))
  (collection self))

(defmethod become ((self collection) (other collection))
  ;; overwrite the self-list with the other-list
  ;; essentially the other-class becomes the self-list, used for making a part-pair-list, then moving it to a sinks-list or a sources-list
  (setf (collection self) (collection other)))

;;;; stack 

(defclass stack ()
  ((stack :initform nil :accessor stack)))

(defmethod stack-push ((self stack) item)
  (cl:push item (stack self)))

(defmethod stack-pop ((self stack))
  (cl:pop (stack self)))

(defmethod stack-top ((self stack))
  (first (stack self)))

(defmethod stack-nth ((self stack) n)
  (nth n (stack self)))

;;;;;;;;;

(defclass sinks-list (collection) ())
(defclass sources-list (collection) ())
(defclass part-pin-pair-list (collection) ())

(defclass part ()
  ((name :accessor name :initarg :name)
   (kind :accessor kind)
   (inputs :accessor inputs)
   (outputs :accessor outputs)
   (react :accessor react)
   (first-time :accessor first-time)))  

(defclass schematic (part)
  ((parts :accessor parts)
   (wiring :accessor wiring)))

(defclass wire ()
  ((index :accessor index)
   (source-list :accessor source-list :initform (make-instance 'collection))
   (sink-list :accessor sink-list :initform (make-instance 'collection))))

;; class needed by SL, must be called "parser"
(defclass parser ()
  ((accepted-token :initform nil :accessor accepted-token)
   (owner :initform nil :accessor owner :initarg :owner)
   (token-stream :initform nil :accessor token-stream :initarg :token-stream)
   (unparsed-token-stream :initform nil :accessor unparsed-token-stream)
   (indent :initform 0 :accessor indent)
   (output-stream :initform (make-string-output-stream) :accessor output-stream)
   (error-stream :initform *error-output* :accessor error-stream)
   (schematic-stack :accessor schematic-stack :initform (make-instance 'stack))
   (collection-stack :accessor collection-stack :initform (make-instance 'stack))
   (table-stack :accessor table-stack :initform (make-instance 'stack))
   (wire-stack :accessor wire-stack :initform (make-instance 'stack))
   (part-stack :accessor part-stack :initform (make-instance 'stack))
   (sinks-list-stack :accessor sinks-list-stack :initform (make-instance 'stack))
   (sources-list-stack :accessor sources-list-stack :initform (make-instance 'stack))
   (part-pin-pair-list-stack :accessor part-pin-pair-list-stack :initform (make-instance 'stack))
   (part-pin-pair-stack :accessor part-pin-pair-stack :initform (make-instance 'stack))
   (top-schematic :accessor top-schematic)
   (parts :initform (make-hash-table :test 'equal) :accessor parts)
   (wires :initform (make-hash-table) :accessor wires)))



(defun string-token (tok)
  (cond ((eq :lpar (token-kind tok)) "(")
        ((eq :rpar (token-kind tok)) ")")
        ((eq :string (token-kind tok)) (format nil "~A" (token-text tok)))
        ((eq :ws (token-kind tok)) " ")
        ((eq :integer (token-kind tok)) (format nil "integer ~a" (token-text tok)))
        ((eq :symbol (token-kind tok)) (format nil "symbol ~A" (token-text tok)))

        ;; additions to json-emitter-sl.lisp
        ((eq :inputs (token-kind tok)) (format nil ":inputs"))
        ((eq :outputs (token-kind tok)) (format nil ":outputs"))
        ((eq :end (token-kind tok)) (format nil ":end"))
        ;;

        (t (assert nil))))

(defun debug-token (tok)
  (format *standard-output* "~a~%" (string-token tok)))

(defmethod accept ((self parser))
  (setf (accepted-token self) (pop (token-stream self)))
  (debug-token (accepted-token self)))

(defmethod parser-error ((self parser) kind)
  (let ((msg (format nil "~&parser error expecting ~S, but got ~S ~%~%" kind (first (token-stream self)))))
      (assert nil () msg)
      (send! (owner self) :error msg)
      (pop (token-stream self)) ;; stream is volatile to help debugging
      nil))

(defmethod skip-ws ((self parser))
  (@:loop
    (@:exit-when (not (eq :ws (token-kind (first (token-stream self))))))
    (pop (token-stream self))))

(defmethod look-ahead-p ((self parser) kind)
  (skip-ws self)
  (and (token-stream self)
       (eq kind (token-kind (first (token-stream self))))))

(defmethod need ((self parser) kind)
  (if (look-ahead-p self kind)
      (accept self)
    (parser-error self kind)))

(defmethod accept-if ((self parser) kind)
  (when (look-ahead-p self kind)
    (accept self)))

(defmethod get-accepted-token-text ((self parser))
  (token-text (accepted-token self)))

(defmethod accepted-symbol-must-be-nil ((self parser))
  (if (and (eq :symbol (token-kind (accepted-token self)))
           (string= "NIL" (string-upcase (token-text (accepted-token self)))))
      T
    (parser-error self nil)))

(defmethod emit ((self parser) fmtstr &rest args)
  (apply #'format (output-stream self) fmtstr args))

(defmethod get-output ((self parser))
  (get-output-stream-string (output-stream self)))

(defmethod inc ((self parser))
  (incf (indent self) 2))

(defmethod dec ((self parser))
  (decf (indent self) 2))

(defmethod nl ((self parser))
  (let ((count (indent self)))
    (@:loop
      (@:exit-when (<= count 0))
      (emit self " ")
      (decf count))
    (emit self "~%")))
      
(defun debug-indent (stream count)
  (@:loop
    (@:exit-when (<= count 0))
    (format stream " ")
    (decf count)))

(defparameter *debug-sl* nil)

(defun debug-sl (bool) (setf *debug-sl* bool))

(defun debug-calling (depth caller)
  (when *debug-sl*
    (format *error-output* "~&")
    (debug-indent *error-output* depth)
    (format *error-output* "~a calling~%" caller)))

(defun debug-return (depth caller)
  (when *debug-sl*
    (format *error-output* "~&")
    (debug-indent *error-output* depth)
    (format *error-output* "return to ~a~%" caller)))

(defun debug-in (depth rule)
  (when *debug-sl*
    (format *error-output* "~&")
    (debug-indent *error-output* depth)
    (format *error-output* "~a~%" rule)))

;; parser support
(defmethod must-see ((p parser) token)   (arrowgrams/compiler/back-end:need p token))
(defmethod look-ahead ((p parser) token)   (arrowgrams/compiler/back-end:look-ahead-p p token))
(defmethod output ((p parser) str)   (arrowgrams/compiler/back-end:emit p str))
(defmethod need-nil-symbol ((p parser) str)   (arrowgrams/compiler/back-end:emit p str))

(defmethod call-external ((p parser) func depth caller)
  (debug-calling depth 'mechanism)
  (cl:apply func (list p))
  (debug-return depth 'mechanism))
  
(defmethod call-rule ((p parser) func depth caller)
  (debug-calling depth caller)
  (cl:apply func (list p (1+ depth)))
  (debug-return depth caller))

(defmethod in-rule ((p parser) depth rule-sym)
  (declare (ignore p))
  (debug-in depth rule-sym))

;; mechanisms used in *collector-rules* and *generic-rules*
(defmethod print-text ((p parser))
  (format (arrowgrams/compiler/back-end:output-stream p)
          "~a"
          (arrowgrams/compiler/back-end:token-text (arrowgrams/compiler/back-end:accepted-token p))))

(defmethod symbol-must-be-nil ((p parser))
  (arrowgrams/compiler/back-end:accepted-symbol-must-be-nil p))

(defmethod break-here ((p parser))
  (format *standard-output* "p is ~A~%" p)
  (break)
)

;;;;

;; schematic mechanism

(defmethod schematic/open ((self parser))
  (stack-push (schematic-stack self) (make-instance 'schematic :name "self")))

(defmethod schematic/set-kind-from-string ((self parser))
  (let ((str (get-accepted-token-text self)))
    (let ((top (stack-top (schematic-stack self))))
      (setf (kind top) str))))

(defmethod schematic/set-react-from-string ((self parser))
  (let ((str (get-accepted-token-text self)))
    (let ((top (stack-top (schematic-stack self))))
      (setf (react top) str))))

(defmethod schematic/set-first-time-from-string ((self parser))
  (let ((str (get-accepted-token-text self)))
    (let ((top (stack-top (schematic-stack self))))
      (setf (first-time top) str))))

(defmethod schematic/close-pop ((self parser))
  (setf (top-schematic self)
        (stack-pop (schematic-stack self))))

(defmethod schematic/set-inputs-from-list ((self parser))
  (let ((list (stack-pop (collection-stack self))))
    (let ((top-schem (stack-top (schematic-stack self))))
      (setf (inputs top-schem) list))))

(defmethod schematic/set-outputs-from-list ((self parser))
  (let ((list (stack-pop (collection-stack self))))
    (let ((top-schem (stack-top (schematic-stack self))))
      (setf (outputs top-schem) list))))

(defmethod schematic/set-parts-from-table-pop-table ((self parser))
  (let ((table (stack-pop (table-stack self))))
    (let ((top-schem (stack-top (schematic-stack self))))
      (setf (parts top-schem) table))))

(defmethod schematic/set-wiring-from-table-pop-table ((self parser))
  (let ((table (stack-pop (table-stack self))))
    (let ((top-schem (stack-top (schematic-stack self))))
      (setf (wiring top-schem) table))))


;; part mechanism

(defmethod part/new ((self parser))
  (stack-push (part-stack self) (make-instance 'part)))

(defmethod part/close-pop ((self parser))
  (stack-pop (part-stack self)))

(defmethod part/set-name ((self parser))
  (let ((top (stack-top (part-stack self))))
    (setf (name top) (get-accepted-token-text self))))

(defmethod part/set-kind ((self parser))
  (let ((top (stack-top (part-stack self))))
    (setf (kind top) (get-accepted-token-text self))))

(defmethod part/set-react ((self parser))
  (let ((top (stack-top (part-stack self))))
    (setf (react top) (get-accepted-token-text self))))

(defmethod part/set-first-time ((self parser))
  (let ((top (stack-top (part-stack self))))
    (setf (first-time top) (get-accepted-token-text self))))

(defmethod part/set-inputs-from-list ((self parser))
  (let ((top (stack-top (part-stack self))))
    (setf (inputs top) (stack-top (collection-stack self)))))

(defmethod part/set-outputs-from-list ((self parser))
  (let ((top (stack-top (part-stack self))))
    (setf (outputs top) (stack-top (collection-stack self)))))


;; list mechanism

(defmethod list/new ((self parser))
  (stack-push (collection-stack self) (make-instance 'collection)))

(defmethod list/close ((self parser))
  ;; noop - leave TOP on stack
  )

(defmethod list/pop ((self parser))
  (stack-pop (collection-stack self)))

(defmethod list/add-string ((self parser))
  (let ((str (get-accepted-token-text self)))
    (add (stack-top (collection-stack self)) str)))

;; wire mechanism
(defmethod wire/new ((self parser))
  (stack-push (wire-stack self) (make-instance 'wire)))

(defmethod wire/close((self parser)))

(defmethod wire/pop ((self parser))
  (stack-pop (wire-stack self)))

(defmethod wire/set-index ((self parser))
  (let ((top-wire (stack-top (wire-stack self))))
    (setf (index top-wire) (cl:parse-integer (get-accepted-token-text self)))))

(defmethod wire/set-sources-list ((self parser))
  (let ((sources-list (stack-pop (sources-list-stack self))))
    (let ((top-wire (stack-top (wire-stack self))))
      (setf (source-list top-wire) sources-list))))

(defmethod wire/set-sinks-list ((self parser))
  (let ((sink-list (stack-pop (sinks-list-stack self))))
    (let ((top-wire (stack-top (wire-stack self))))
      (setf (sink-list top-wire) sink-list))))

;; sources and sinks

(defmethod sources-list/new ((self parser))
  (stack-push (sources-list-stack self) (make-instance 'sources-list)))

(defmethod sinks-list/new ((self parser))
  (stack-push (sinks-list-stack self) (make-instance 'sinks-list)))

(defmethod sources-list/becomes-part-pin-pair-list ((self parser))
  (let ((sources-list (stack-top (sources-list-stack self))))
    (let ((part-pin-pair-list (stack-top (part-pin-pair-list-stack self))))
    (become sources-list part-pin-pair-list))))

(defmethod sinks-list/becomes-part-pin-pair-list ((self parser))
  (let ((sinks-list (stack-top (sinks-list-stack self))))
    (let ((part-pin-pair-list (stack-top (part-pin-pair-list-stack self))))
    (become sinks-list part-pin-pair-list))))

(defmethod sources-list/close-pop ((self parser))
  (stack-pop (sources-list-stack self)))

(defmethod sinks-list/close-pop ((self parser))
  (stack-pop (sinks-list-stack self)))

;; part-pin-pair-lists

(defmethod part-pin-pair-list/new ((self parser))
  (stack-push (part-pin-pair-list-stack self) (make-instance 'part-pin-pair-list)))

(defmethod part-pin-pair-list/close-pop ((self parser))
  (stack-pop (part-pin-pair-list-stack self)))

(defmethod part-pin-pair-list/add-pair ((self parser))
  (let ((pair (stack-pop (part-pin-pair-stack self))))
    (add (stack-top (part-pin-pair-list-stack self)) pair)))

;; part-pin-pairs
(defmethod part-pin-pair/new ((self parser))
  (stack-push (part-pin-pair-stack self) (make-instance 'pair)))

(defmethod part-pin-pair/close-pop ((self parser))
  (stack-pop (part-pin-pair-stack self)))

(defmethod part-pin-pair/add-first-string ((self parser))
  (let ((str (get-accepted-token-text self)))
    (let ((top-pair (stack-top (part-pin-pair-stack self))))
      (setf (pair-first top-pair) str))))

(defmethod part-pin-pair/add-second-string ((self parser))
  (let ((str (get-accepted-token-text self)))
    (let ((top-pair (stack-top (part-pin-pair-stack self))))
      (setf (pair-second top-pair) str))))

;; table
(defmethod table/new ((self parser))
  (stack-push (table-stack self) (make-hash-table :test 'equal)))

(defmethod table/close-pop ((self parser))
  (stack-pop (table-stack self)))

(defmethod table/add-part ((self parser))
  (let ((part (stack-top (part-stack self))))
    (let ((top-table (stack-top (table-stack self))))
      (setf (gethash (name part) top-table)
            part))))

(defmethod table/add-wire ((self parser))
  (let ((top-table (stack-top (table-stack self))))
    (let ((top-wire (stack-top (wire-stack self))))
      (setf (gethash (index top-wire) top-table)
            top-wire))))


;;;;; unparser support
#|
(defmethod unparse-emit ((p parser) item)
  (setf (unparsed-token-stream p)
        (cons item (unparsed-token-stream p))))
  
(defmethod unparse-emit-token ((p parser) tok)
  (unparse-emit p tok))

(defmethod unparse-push ((p parser) item)
  (stack-push (unparse-stack p) item))

(defmethod unparse-pop ((p parser))
  (stack-pop (unparse-stack p)))

(defmethod unparse-tos ((p parser))
  (stack-top (unparse-stack p)))

(defmethod unparse-call-external ((p parser) func)
  (apply func (list p)))

(defmethod unparse-call-rule ((p parser) func)
  (apply func (list p)))

(defmethod unparse-foreach-in-list ((p parser) func)
  (dolist (L (unparse-tos p))
    (unparse-push p L)
    (apply func (list p))
    (unparse-pop p)))

(defmethod unparse-foreach-in-table ((p parser) func)
  (maphash #'(lambda (key val)
               (declare (ignore key))
               (unparse-push val)
               (apply func (list p))
               (unparse-pop))
           (unparse-tos p)))

(defmethod unparse-dupn ((p parser) n)
  (assert (> n 0))
  (let ((item (stack-nth (unparse-stack p) (1- n)))) ;; 1==top
    (unparse-push p item)))
|#

(defmethod emit-token ((p parser) kind)
  (send! (owner p) :out (make-token :kind kind)))

(defmethod emit-string ((p parser) str)
  (send! (owner p) :out (make-token :kind :string :text str)))

(defmethod emit-integer ((p parser) n)
  (send! (owner p) :out (make-token :kind :integer :text (format nil "~A" n))))

;;;;;;;; mechanisms for schem-unparse.lisp ;;;;;;;
#|
(defmethod send-top ((p parser))
  (let ((str (unparse-tos p)))
    (assert (stringp str))
    (unparse-emit p str)))
|#

(defmethod lookup-part-pin-in-sinks ((p parser) wiring-table part-name pin-name)
  (let ((result nil))
    (maphash #'(lambda (integer-key wire)
                 (when (part-pin-in-wire-sinks-p p wire part-name pin-name)
                   (push integer-key result)))
             wiring-table)
    result))

(defmethod lookup-part-pin-in-sources ((p parser) wiring-table part-name pin-name)
  (let ((result nil))
    (maphash #'(lambda (integer-key wire)
                 (when (part-pin-in-wire-sources-p p wire part-name pin-name)
                   (push integer-key result)))
             wiring-table)
    result))

(defmethod part-pin-in-wire-sinks-p ((p parser) (wire wire) part-name pin-name)
  (dolist (sink (as-list (sink-list wire)))
    ;; sink is a pair of strings
    (if (and (string= (pair-first sink) part-name)
               (string= (pair-second sink) pin-name))
        T
      nil)))

(defmethod part-pin-in-wire-sources-p ((p parser) (wire wire) part-name pin-name)
  (dolist (source (as-list (source-list wire)))
    ;; source is a pair of strings
    (if (and (string= (pair-first source) part-name)
               (string= (pair-second source) pin-name))
        T
      nil)))

;; unparse emission

(defmethod uemit-token ((self parser) kind)
  (push (make-token :kind kind) (unparsed-token-stream self)))

(defmethod uemit-string ((self parser) str)
  (push (make-token :kind :string :text str) (unparsed-token-stream self)))

(defmethod uemit-integer ((self parser) n)
  (push (make-token :kind :integer :text (format nil "~A" n)) (unparsed-token-stream self)))

(defmethod uget-unparsed-token-stream ((self parser))
  (reverse (unparsed-token-stream self)))
