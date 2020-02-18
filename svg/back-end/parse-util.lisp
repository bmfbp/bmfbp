;;
;; sl mechanisms used (see ~/attic/json.sl.lisp)
;;
;; :string print-text
;; :integer print-text
;; inc dec
;; nl
;; symbol-must-be-nil
;;



(in-package :arrowgrams/compiler)

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

(defmethod collection-length ((self collection))
  (length (as-list self)))

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
   (part-react :accessor part-react)
   (first-time :accessor first-time)))  

(defclass schematic (part)
  ((parts :accessor parts)
   (wiring :accessor wiring)
   (metadata :accessor metadata)))

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
   (wires :initform (make-hash-table) :accessor wires)
   (name :initform "" :accessor name :initarg :name)
   (memo :initform nil :accessor memo)
   (memo-mapping :accessor memo-mapping :initform (make-hash-table))))

(defun stringify-token (tok)
  (cond ((eq :lpar (token-kind tok)) "(")
        ((eq :rpar (token-kind tok)) ")")
        ((eq :string (token-kind tok)) (format nil ":string /~A/" (token-text tok)))
        ((eq :ws (token-kind tok)) " ")
        ((eq :integer (token-kind tok)) (format nil ":integer ~a" (token-text tok)))
        ((eq :symbol (token-kind tok)) (format nil ":symbol ~A" (token-text tok)))

        ;; additions to json-emitter-sl.lisp
        ((eq :inputs (token-kind tok)) (format nil ":inputs"))
        ((eq :outputs (token-kind tok)) (format nil ":outputs"))
        ((eq :inmap (token-kind tok)) (format nil ":inmap"))
        ((eq :outmap (token-kind tok)) (format nil ":outmap"))
        ((eq :end (token-kind tok)) (format nil ":end"))
        ;;

        (t (assert nil))))

(defparameter *debug-sl* nil)
(defparameter *debug-accept* nil)

(defun debug-sl (bool) (setf *debug-sl* bool))
(defun debug-accept (bool) (setf *debug-accept* bool))

(defun debug-token (tok)
  (when (or *debug-sl* *debug-accept*)
    (format *standard-output* "~a~%" (stringify-token tok))))

(defmethod accept ((self parser))
  (setf (accepted-token self) (pop (token-stream self)))
  (debug-token (accepted-token self)))

(defmethod parser-error ((self parser) kind)
  (let ((msg (format nil "~&parser error ~S expecting ~S, but got ~S ~%~%" (name self) kind (first (token-stream self)))))
      (assert nil () msg)
      (@send (owner self) :error msg)
      (pop (token-stream self)) ;; stream is volatile to help debugging
      nil))

(defmethod skip-ws ((self parser))
  (@:loop
    (@:exit-when (null (token-stream self)))
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

(defmethod rm-quotes ((self parser))
  (setf (token-text (accepted-token self))
        (strip-quotes (token-text (accepted-token self)))))

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

(defmethod print-indent ((self parser))
  (let ((count (indent self)))
    (@:loop
      (@:exit-when (<= count 0))
      (emit self " ")
      (decf count))))

(defmethod nl ((self parser))
  (emit self "~%")
  (print-indent self))
      
(defun debug-indent (stream count)
  (@:loop
    (@:exit-when (<= count 0))
    (format stream " ")
    (decf count)))


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
(defmethod must-see ((p parser) token)   (need p token))
(defmethod look-ahead ((p parser) token)   (look-ahead-p p token))
(defmethod output ((p parser) str)   (emit p str))
(defmethod need-nil-symbol ((p parser) str)   (emit p str))

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
  (format (output-stream p)
          "~a"
          (token-text (accepted-token p))))

(defmethod print-integer ((p parser))
  (print-text p))

(defmethod symbol-must-be-nil ((p parser))
  (accepted-symbol-must-be-nil p))

(defmethod break-here ((p parser))
  (format *standard-output* "p is ~A~%" p)
  (break)
)



(defmethod print-text-as-quoted-symbol ((p parser))
  (format (output-stream p)
          "'~a"
          (token-text (accepted-token p))))

(defmethod convert-accepted-text-to-symbol ((p parser))
  (let ((name (string-upcase
               (cl-ppcre:regex-replace-all "\""
                                           (cl-ppcre:regex-replace-all " " (token-text (accepted-token p)) "-")
                                           ""))))
    (let ((sym (intern name "CL-USER")))
      sym)))

(defmethod print-text-as-symbol ((p parser))
  (let ((sym (convert-accepted-text-to-symbol p)))
      (write sym :stream (output-stream p))))

(defmethod print-text-as-keyword-symbol ((p parser))
  (let ((sym (convert-accepted-text-to-symbol p)))
    (write sym :stream (output-stream p))))

(defmethod print-text-as-string ((p parser))
  (format (output-stream p) "~s" (token-text (accepted-token p))))


;; memo - map invented symbol names to kind-names - assume that kinds are used only once, hence, symbol-name can be the kind-name
;; (this should make manual debugging easier)

(defmethod memo-symbol ((p parser))
  (let ((sym (convert-accepted-text-to-symbol p)))
    (multiple-value-bind (val success)
        (gethash sym (memo-mapping p))
      (declare (ignore val))
      (assert (not success)) ;; symbol must not already be in the mapping table ; this error can happen if using a schematic that uses a KIND more than once (see "memo" comment above)
      (setf (memo p) sym)
      (setf (gethash sym (memo-mapping p)) nil))))
  

(defmethod associate-kind-name-with-memo ((p parser))
  (let ((kind (convert-accepted-text-to-symbol p)))
    (setf (gethash (memo p) (memo-mapping p)) kind)))

(defmethod print-kind-instead-of-symbol ((p parser))
  (let ((sym (convert-accepted-text-to-symbol p)))
    (cond ((eq 'cl-user::self sym)
           (write 'cl-user::self :stream (output-stream p)))
          (t (multiple-value-bind (kind-sym success)
                 (gethash sym (memo-mapping p))
               (assert success)
               (write kind-sym :stream (output-stream p)))))))
    
;;;;

;; schematic mechanism

(defmethod schematic/open ((self parser))
  (stack-push (schematic-stack self) (make-instance 'schematic :name "\"self\"")))

(defmethod schematic/set-meta-from-string ((self parser))
  (let ((str (get-accepted-token-text self)))
    (let ((top (stack-top (schematic-stack self))))
      (setf (metadata top) str))))

(defmethod schematic/set-kind-from-string ((self parser))
  (let ((str (get-accepted-token-text self)))
    (let ((top (stack-top (schematic-stack self))))
      (setf (kind top) str))))

(defmethod schematic/set-react-from-string ((self parser))
  (let ((str (get-accepted-token-text self)))
    (let ((top (stack-top (schematic-stack self))))
      (setf (part-react top) str))))

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
    (setf (part-react top) (get-accepted-token-text self))))

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
  (let ((str (strip-quotes (get-accepted-token-text self))))
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
  (let ((str (strip-quotes (get-accepted-token-text self))))
    (let ((top-pair (stack-top (part-pin-pair-stack self))))
      (setf (pair-first top-pair) str))))

(defmethod part-pin-pair/add-second-string ((self parser))
  (let ((str (strip-quotes (get-accepted-token-text self))))
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



(defmethod emit-token ((p parser) kind)
  (@send (owner p) :out (make-token :kind kind)))

(defmethod emit-string ((p parser) str)
  (@send (owner p) :out (make-token :kind :string :text str)))

(defmethod emit-integer ((p parser) n)
  (@send (owner p) :out (make-token :kind :integer :text (format nil "~A" n))))

;;;;;;;; mechanisms for schem-unparse.lisp ;;;;;;;

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
                 (let ((bool (part-pin-in-wire-sources-p p wire part-name pin-name)))
                   (when bool 
                     (push integer-key result))))
             wiring-table)
    result))

(defmethod part-pin-in-wire-sinks-p ((p parser) (wire wire) part-name pin-name)
  (dolist (sink (as-list (sink-list wire)))
    ;; sink is a pair of strings
    (when (and (string= (pair-first sink) part-name)
               (string= (pair-second sink) pin-name))
      (return-from part-pin-in-wire-sinks-p t))))

(defmethod part-pin-in-wire-sources-p ((p parser) (wire wire) part-name pin-name)
  (dolist (source (as-list (source-list wire)))
    ;; source is a pair of strings
    (let ((ret (and (string= (pair-first source) part-name)
                    (string= (pair-second source) pin-name))))
      (when ret
        (return-from part-pin-in-wire-sources-p t)))))

;; unparse emission

(defmethod uemit-token ((self parser) kind)
  (push (make-token :kind kind) (unparsed-token-stream self)))

(defmethod uemit-string ((self parser) str)
  (push (make-token :kind :string :text str) (unparsed-token-stream self)))

(defmethod uemit-integer ((self parser) n)
  (push (make-token :kind :integer :text (format nil "~A" n)) (unparsed-token-stream self)))

(defmethod uget-unparsed-token-stream ((self parser))
  (reverse (unparsed-token-stream self)))

;;; utility functions ;;;

(defun strip-quotes (str)
  (if (and (char= #\" (char str 0))
           (char= #\" (char str (1- (length str)))))
      (subseq str 1 (1- (length str)))
    str))



