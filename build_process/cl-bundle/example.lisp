;;;; package.lisp
(defpackage :arrowgrams/build
  (:use :cl :cl-event-passing-user)
  (:nicknames "AB"))


;;;; esa.lisp
(in-package :arrowgrams/build)(defclass part-definition ()
  ((part-name :accessor part-name :initform nil)
   (part-kind :accessor part-kind :initform nil)
   ))
(defclass named-part-instance ()
  ((instance-name :accessor instance-name :initform nil)
   (instance-node :accessor instance-node :initform nil)
   ))
(defclass part-pin ()
  ((part-name :accessor part-name :initform nil)
   (pin-name :accessor pin-name :initform nil)
   ))
(defclass source ()
  ((part-name :accessor part-name :initform nil)
   (pin-name :accessor pin-name :initform nil)
   ))
(defclass destination ()
  ((part-name :accessor part-name :initform nil)
   (pin-name :accessor pin-name :initform nil)
   ))
(defclass wire ()
  ((index :accessor index :initform nil)
   (sources :accessor sources :initform nil)(destinations :accessor destinations :initform nil)))
(defclass kind ()
  ((kind-name :accessor kind-name :initform nil)
   (input-pins :accessor input-pins :initform nil)
   (self-class :accessor self-class :initform nil)
   (output-pins :accessor output-pins :initform nil)
   (parts :accessor parts :initform nil)
   (wires :accessor wires :initform nil)
   ))
(defclass node ()
  ((input-queue :accessor input-queue :initform nil)
   (output-queue :accessor output-queue :initform nil)
   (kind-field :accessor kind-field :initform nil)
   (container :accessor container :initform nil)
   (name-in-container :accessor name-in-container :initform nil)
   (children :accessor children :initform nil)
   (busy-flag :accessor busy-flag :initform nil)
   ))
(defclass dispatcher ()
  ((all-parts :accessor all-parts :initform nil)(top-node :accessor top-node :initform nil)
   ))
(defclass event ()
  ((partpin :accessor partpin :initform nil)
   (data :accessor data :initform nil)
   ))

(defgeneric install-input-pin (self G518))
(defgeneric install-output-pin (self G519))
(defgeneric add-input-pin #|script|# (self G520))
(defgeneric add-output-pin #|script|# (self G521))
(defgeneric add-part #|script|# (self G522 G523 G524))
(defgeneric add-wire #|script|# (self G525))
(defgeneric install-wire (self G526))
(defgeneric install-part (self G527 G528 G529))
(defgeneric parts (self) #|returns map part-definition|# )


(defgeneric install-class (self G530))
(defgeneric ensure-part-not-declared (self G531))
(defgeneric ensure-valid-input-pin (self G532))
(defgeneric ensure-valid-output-pin (self G533))
(defgeneric ensure-input-pin-not-declared (self G534))
(defgeneric ensure-output-pin-not-declared (self G535))
(defgeneric ensure-valid-source #|script|# (self G536))
(defgeneric ensure-valid-destination #|script|# (self G537))


(defgeneric ensure-kind-defined (self))


(defmethod add-input-pin #|script|# ((self kind) name )
  ( ensure-input-pin-not-declared self  name )
  ( install-input-pin self  name )
  )#|end script|#

(defmethod add-output-pin #|script|# ((self kind) name )
  ( ensure-output-pin-not-declared self  name )
  ( install-output-pin self  name )
  )#|end script|#

(defmethod add-part #|script|# ((self kind) nm  k  nclass )
  ( ensure-part-not-declared self  nm )
  ( install-part self  nm  k  nclass )
  )#|end script|#

(defmethod add-wire #|script|# ((self kind) w )
  (block map (dolist (s ( sources w))
               ( ensure-valid-source self  s )
               ))#|end map|#
  (block map (dolist (dest ( destinations w))
               ( ensure-valid-destination self  dest )
               ))#|end map|#
  ( install-wire self  w )
  )#|end script|#

(defmethod ensure-valid-source #|script|# ((self kind) s )
  (cond ((esa-expr-true ( refers-to-self? s))
         ( ensure-valid-input-pin self ( pin-name s) )
         )
        (t  ;else
         (let ((p ( kind-find-part self ( part-name s) )))
           ( ensure-kind-defined p)
           ( ensure-valid-output-pin( part-kind p) ( pin-name s) )
           )#|end let|#
         )#|end else|#
        )#|end if|#
  )#|end script|#

(defmethod ensure-valid-destination #|script|# ((self kind) dest )
  (cond ((esa-expr-true ( refers-to-self? dest))
         ( ensure-valid-output-pin self ( pin-name dest) )
         )
        (t  ;else
         (let ((p ( kind-find-part self ( part-name dest) )))
           ( ensure-kind-defined p)
           ( ensure-valid-input-pin( part-kind p) ( pin-name dest) )
           )#|end let|#
         )#|end else|#
        )#|end if|#
  )#|end script|#

(defgeneric refers-to-self? (self) #|returns boolean|# )


(defgeneric refers-to-self? (self) #|returns boolean|# )


(defgeneric install-source (self G538 G539))
(defgeneric install-destination (self G540 G541))


(defmethod add-source #|script|# ((self wire) part  pin )
  ( install-source self  part  pin )
  )#|end script|#

(defmethod add-destination #|script|# ((self wire) part  pin )
  ( install-destination self  part  pin )
  )#|end script|#

(defgeneric loader #|script|# (self G542 G543 G544) #|returns node|# )


(defgeneric clear-input-queue (self))
(defgeneric clear-output-queue (self))
(defgeneric install-node (self G545))
(defgeneric add-child #|script|# (self G546 G547))


(defmethod loader #|script|# ((self kind) my-name  my-container  dispatchr )
  (let ((clss ( self-class self)))
    (let ((inst (make-instance clss)))
      ( clear-input-queue inst)
      ( clear-output-queue inst)
      (setf ( kind-field inst) self)
      (setf ( container inst) my-container)
      (setf ( name-in-container inst) my-name)
      (block map (dolist (part ( parts self))
                   (let ((part-instance ( loader( part-kind part) ( part-name part)  inst  dispatchr )))
                     ( add-child inst ( part-name part)  part-instance )
                     )#|end let|#
                   ))#|end map|#
      ( memo-node dispatchr  inst )
      (return-from loader inst)
      )#|end create|#
    )#|end let|#
  )#|end script|#

(defgeneric memo-node (self G548))
(defgeneric set-top-node (self G549))


(defmethod add-child #|script|# ((self node) nm  nd )
  ( install-child self  nm  nd )
  )#|end script|#

(defgeneric initialize-all #|script|# (self))


(defmethod initialize-all #|script|# ((self dispatcher))
  (block map (dolist (part ( all-parts self))
               ( initialize part)
               ))#|end map|#
  )#|end script|#

(defgeneric initialize #|script|# (self))
(defgeneric initially (self))


(defmethod initialize #|script|# ((self node))
  ( initially self)
  )#|end script|#

(defgeneric send (self G550))
(defgeneric distribute-output-events #|script|# (self))
(defgeneric display-output-events-to-console-and-delete (self))
(defgeneric get-output-events-and-delete (self) #|returns map event|# )
(defgeneric has-no-container? (self) #|returns boolean|# )
(defgeneric distribute-outputs-upwards #|script|# (self))


(defgeneric start #|script|# (self))
(defgeneric distribute-all-outputs #|script|# (self))
(defgeneric run #|script|# (self))
(defgeneric declare-finished (self))


(defgeneric find-wire-for-source (self G551 G552) #|returns wire|# )
(defgeneric find-wire-for-self-source (self G553) #|returns wire|# )


(defgeneric busy? #|script|# (self))
(defgeneric ready? #|script|# (self))
(defgeneric has-inputs-or-outputs? (self) #|returns boolean|# )
(defgeneric children? (self) #|returns boolean|# )
(defgeneric flagged-as-busy? (self) #|returns boolean|# )
(defgeneric dequeue-input (self))
(defgeneric input-queue? (self))
(defgeneric enqueue-input (self G554))
(defgeneric enqueue-output (self G555))
(defgeneric react (self G556))
(defgeneric run-reaction #|script|# (self G557))
(defgeneric run-composite-reaction #|script|# (self G558))
(defgeneric node-find-child (self G559) #|returns named-part-instance|# )


(defmethod busy? #|script|# ((self node))
  (cond ((esa-expr-true ( flagged-as-busy? self))
         (return-from busy? :true)
         )
        (t  ;else
         (block map (dolist (child-part-instance ( children self))
                      (let ((child-node ( instance-node child-part-instance)))
                        (cond ((esa-expr-true ( has-inputs-or-outputs? child-node))
                               (return-from busy? :true)
                               )
                              (t  ;else
                               (cond ((esa-expr-true ( busy? child-node))
                                      (return-from busy? :true)
                                      ))#|end if|#
                               )#|end else|#
                              )#|end if|#
                        )#|end let|#
                      ))#|end map|#
         )#|end else|#
        )#|end if|#
  (return-from busy? :false)
  )#|end script|#

(defmethod start #|script|# ((self dispatcher))
  ( distribute-all-outputs self)
  ( run self)
  )#|end script|#

(defmethod run #|script|# ((self dispatcher))
  (let ((done  :true))
    (loop
     (setf  done :true)
     ( distribute-all-outputs self)
     (block map (dolist (part ( all-parts self))
                  (cond ((esa-expr-true ( ready? part))
                         ( invoke part)
                         (setf  done :false)
                         (return-from map nil)
                         ))#|end if|#
                  ))#|end map|#
     (when (esa-expr-true  done) (return))
     )#|end loop|#
    )#|end let|#
  ( declare-finished self)
  )#|end script|#

(defmethod invoke #|script|# ((self node))
  (let ((e ( dequeue-input self)))
    ( run-reaction self  e )
    ( distribute-output-events self)
    )#|end let|#
  )#|end script|#

(defmethod ready? #|script|# ((self node))
  (cond ((esa-expr-true ( input-queue? self))
         (cond ((esa-expr-true ( busy? self))
                (return-from ready? :false)
                )
               (t  ;else
                (return-from ready? :true)
                )#|end else|#
               )#|end if|#
         ))#|end if|#
  (return-from ready? :false)
  )#|end script|#

(defmethod distribute-all-outputs #|script|# ((self dispatcher))
  (block map (dolist (p ( all-parts self))
               ( distribute-output-events p)
               ( distribute-outputs-upwards p)
               ))#|end map|#
  )#|end script|#

(defmethod distribute-outputs-upwards #|script|# ((self node))
  (cond ((esa-expr-true ( has-no-container? self))
         )
        (t  ;else
         (let ((parent ( container self)))
           ( distribute-output-events parent)
           )#|end let|#
         )#|end else|#
        )#|end if|#
  )#|end script|#

(defmethod distribute-output-events #|script|# ((self node))
  (cond ((esa-expr-true ( has-no-container? self))
         ( display-output-events-to-console-and-delete self)
         )
        (t  ;else
         (let ((parent-composite-node ( container self)))
           (block map (dolist (output ( get-output-events-and-delete self))
                        (let ((dest ( partpin output)))
                          (let ((w ( find-wire-for-source( kind-field parent-composite-node) ( part-name( partpin output)) ( pin-name( partpin output)) )))
                            (block map (dolist (dest ( destinations w))
                                         (cond ((esa-expr-true ( refers-to-self? dest))
                                                (let ((new-event (make-instance 'event)))
                                                  (let ((pp (make-instance 'part-pin)))
                                                    (setf ( part-name pp)( name-in-container parent-composite-node))
                                                    (setf ( pin-name pp)( pin-name dest))
                                                    (setf ( partpin new-event) pp)
                                                    (setf ( data new-event)( data output))
                                                    ( send parent-composite-node  new-event )
                                                    )#|end create|#
                                                  )#|end create|#
                                                )
                                               (t  ;else
                                                (let ((new-event (make-instance 'event)))
                                                  (let ((pp (make-instance 'part-pin)))
                                                    (setf ( part-name pp)( part-name dest))
                                                    (setf ( pin-name pp)( pin-name dest))
                                                    (setf ( partpin new-event) pp)
                                                    (setf ( data new-event)( data output))
                                                    (let ((child-part-instance ( node-find-child parent-composite-node ( part-name pp) )))
                                                      ( enqueue-input( instance-node child-part-instance)  new-event )
                                                      )#|end let|#
                                                    )#|end create|#
                                                  )#|end create|#
                                                )#|end else|#
                                               )#|end if|#
                                         ))#|end map|#
                            )#|end let|#
                          )#|end let|#
                        ))#|end map|#
           )#|end let|#
         )#|end else|#
        )#|end if|#
  )#|end script|#

(defmethod run-reaction #|script|# ((self node) e )
  ( react self  e )
  )#|end script|#

(defmethod run-composite-reaction #|script|# ((self node) e )
  (let ((w  :true))
    (cond ((esa-expr-true ( has-no-container? self))
           (setf  w( find-wire-for-self-source( kind-field self) ( pin-name( partpin e)) ))
           )
          (t  ;else
           (setf  w( find-wire-for-source( kind-field( container self)) ( part-name( partpin e)) ( pin-name( partpin e)) ))
           )#|end else|#
          )#|end if|#
    (block map (dolist (dest ( destinations w))
                 (let ((new-event (make-instance 'event)))
                   (let ((pp (make-instance 'part-pin)))
                     (cond ((esa-expr-true ( refers-to-self? dest))
                            (setf ( part-name pp)( part-name dest))
                            (setf ( pin-name pp)( pin-name dest))
                            (setf ( partpin new-event) pp)
                            (setf ( data new-event)( data e))
                            ( send self  new-event )
                            )
                           (t  ;else
                            (cond ((esa-expr-true ( children? self))
                                   (setf ( part-name pp)( part-name dest))
                                   (setf ( pin-name pp)( pin-name dest))
                                   (setf ( partpin new-event) pp)
                                   (setf ( data new-event)( data e))
                                   (let ((child-part-instance ( node-find-child self ( part-name dest) )))
                                     ( enqueue-input( instance-node child-part-instance)  new-event )
                                     )#|end let|#
                                   ))#|end if|#
                            )#|end else|#
                           )#|end if|#
                     )#|end create|#
                   )#|end create|#
                 ))#|end map|#
    )#|end let|#
  )#|end script|#

  
;;;; esa-methods.lisp
(in-package :arrowgrams/build)


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
    (setf (part-name p) (string-downcase name))
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
  (dolist (pin-name (input-pins self))
    (when (string=-downcase pin-name name)
      (error (format nil "pin /~a/ is already declared as an input pin of ~s ~s" name (kind-name self) self))))
  T)

(defmethod ensure-output-pin-not-declared ((self kind) name)
  (dolist (pin-name (output-pins self))
    (when (string=-downcase pin-name name)
      (error (format nil "pin /~a/ is already declared as an output pin of ~s ~s" name (kind-name self) self))))
  T)

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
(format *standard-output* "~&install-source ~s ~S~%" part-name pin-name)
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
    (format *standard-output* "~&~s outputs on pin ~s : ~s~%" (name-in-container self) (pin-name (partpin e)) (data e))))

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
      (when (string=-downcase pinname  (pin-name s)))
      (return-from find-wire-for-self-source w)))
  (assert nil)) ;; source not found - can't happen

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
    (error "kind for part /~s/ is not defined (check if manifest is correct) ~s" (part-name self) self)))


(defmethod memo-node ((self dispatcher) (n node))
  (push n (all-parts self)))

(defmethod set-top-node ((self dispatcher) (n node))
  (setf (top-node self) n))

(defmethod declare-finished ((self dispatcher))
  (format *standard-output* "~&~%Dispatcher Finished~%~%"))


(defun string=-downcase (a b)
  (string= (string-downcase a) (string-downcase b)))

(defmethod get-destination ((self event))
  (let ((d (make-instance 'destination)))
    (setf (part-name d) (part-name self))
    (setf (pin-name d) (pin-name self))))

(defmethod react ((self node) (e event))
  (format *standard-output* "~&react node ~s~%" (name-in-container self))
  (run-composite-reaction self e))

;;;; json.lisp

(defun json-to-alist (json-string)
  (with-input-from-string (s json-string)
    (json:decode-json s)))

(defun alist-to-json-string (alist)
  (with-output-to-string (s)
    (json:encode-json alist s)))

;;;; make-kind-from-graph.lisp

(defclass loader ()
  ((kinds-by-name :accessor kinds-by-name)
   (code-stack :accessor code-stack)))


(defun make-kind-from-graph (alist)
  ;; kind is defined in esa.lisp
  (let ((self (make-instance 'loader)))
    (setf (kinds-by-name self) (make-hash-table :test 'equal))
    (setf (code-stack self) nil)
    (let ((top-kind (process-array-of-alists self alist)))
      top-kind)))



(defmethod process-array-of-alists ((self loader) list-of-alists)
  (let ((top-most-kind nil))
    (dolist (alist list-of-alists)
      (if (string= "leaf" (cdr (assoc :item-kind alist)))
          (progn
            #+nil(format *standard-output* "~&build-graph processes ~s ~s~%"
		    (get-kind alist) (cdr (assoc :name alist)))
            (process-leaf self alist))
        (progn
          #+nil(format *standard-output* "~&build-graph processes ~s ~s~%" (get-kind alist) (cdr (assoc :name alist)))
          (setf top-most-kind (process-graph self alist))))) ;; set top-most-kind to the last graph processed (which is the top-most, since this is being done in reverse order)
    top-most-kind))



(defmethod process-graph ((self loader) full-graph)
  (let ((graph (get-graph full-graph)) ;; strip noise
        (name (get-name full-graph)))
    (let ((kind (make-instance 'kind)))
      (let ((kind-sym 'graph))
        (setf (kind-name kind) name)
        (setf (self-class kind) kind-sym)
        (setf (gethash kind-sym (kinds-by-name self)) kind)  ;; kind defined in esa
        (dolist (input-name (get-inputs graph))
          (add-input-pin kind (make-pin-name input-name)))  ;; calls esa
        (dolist (output-name (get-outputs graph))
          (add-output-pin kind (string-downcase output-name)))  ;; calls esa
        (dolist (part-as-alist (get-parts-list graph))
          (let ((kind-sym (make-class-name (get-part-kind part-as-alist)))
                (part-name (make-pin-name (get-part-name part-as-alist))))
            (add-part kind part-name (gethash kind-sym (kinds-by-name self)) kind-sym)))  ;; calls esa
        ;; the wiring table is an array [] of wires
        ;; each wire is defined by: 1. index, 2. (list of) sources, 3. (list of) destinations
        (dolist (wire-as-alist (get-wiring graph))
          (let ((w (make-instance 'wire)))
            (set-index w (get-wire-index wire-as-alist))
            (dolist (source (get-sources wire-as-alist))
              (add-source w (get-part source) (get-pin source)))   ;; calls esa
            (dolist (dest (get-destinations-list wire-as-alist))
              (add-destination w (get-part dest) (get-pin dest)))  ;; calls esa
            (add-wire kind w)))                                    ;; calls esa
        kind))))
  


(defmethod process-leaf ((self loader) a)
  (let ((kind-str (get-kind a))
        (filename (get-filename a))
        (in-pins (get-in-pins a))
        (out-pins (get-out-pins a)))
    ;; kind is a CLOS class name
    (let ((kind-sym (make-class-name kind-str)))
      (let ((k (make-instance 'kind)))  ;; defined by esa
        (setf (kind-name k) kind-sym)
        (setf (self-class k) kind-sym)
        (when filename
          (load filename)) ;; load class into memory unless it has already been loaded (filename NIL)
        (dolist (ipin-str in-pins)
          (add-input-pin k ipin-str))  ;; call to esa
        (dolist (opin-str out-pins)
          (add-output-pin k opin-str)) ;; call to esa
        (setf (gethash kind-sym (kinds-by-name self)) k)  ;; this should be per diagram/graph, not global
        k))))


;; utility functions and dealing with CL packages

(defparameter *arrowgrams-package* "ARROWGRAMS/BUILD")

(defun make-class-name (str)
  (intern (string-upcase str) *arrowgrams-package*))

(defun make-pin-name (str)
  (string-downcase str))

(defun make-part-id (str)
  (string-downcase str))




;;;;;;;; lisp routines to access alists (from JSON)
;;;;;;;; used for building GRAPH

(defun get-name (alist)
  (cdr (assoc :name alist)))

(defun get-item-kind (alist)
  (cdr (assoc :item-kind alist)))

(defun get-graph (alist)
  (cdr (assoc :graph alist)))

(defun get-leaf (alist)
  (cdr (assoc :leaf alist)))

(defun get-inputs (graph-alist)
  (cdr (assoc :inputs graph-alist)))

(defun get-outputs (graph-alist)
  (cdr (assoc :outputs graph-alist)))

(defun get-parts-list (graph-alist)
  (cdr (assoc :parts graph-alist)))

(defun get-part-name (part-alist)
  (cdr (assoc :part-name part-alist)))

(defun get-part-kind (part-alist)
  (cdr (assoc :kind-name part-alist)))

(defun get-wiring (graph-alist)
  (cdr (assoc :wiring graph-alist)))

(defun get-wire-index (wire-alist)
  (cdr (assoc :wire-index wire-alist)))

(defun get-sources (wire-alist)
  (cdr (assoc :sources wire-alist)))

(defun get-destinations-list (wire-alist)
  (cdr (assoc :receivers wire-alist)))

(defun get-part (x)
  (string-downcase (cdr (assoc :part x))))

(defun get-pin (x)
  (string-downcase (cdr (assoc :pin x))))

;;;;;;;; lisp routines to access alists (from JSON)
;;;;;;;; used for building LEAF

(defun get-filename (a)  (cdr (assoc :filename a)))
(defun get-in-pins (a)  (cdr (assoc :in-pins a)))
(defun get-out-pins (a)  (cdr (assoc :out-pins a)))
(defun get-kind (a) (cdr (assoc :kind a)))


;;;; load-and-run.lisp

(defun load-and-run (graph-filename)
  (let ((graph-alist (json-to-alist (alexandria:read-file-into-string graph-filename))))
    #+nil(format *standard-output* "*** making kind from graph~%")
    (let ((top-kind (make-kind-from-graph graph-alist)))  ;; kind defined in esa.lisp
      
      #+nil(format *standard-output* "*** creating dispatcher~%")
      (let ((esa-disp (make-instance 'dispatcher)))  ;; dispatcher defined in esa.lisp

	#+nil(format *standard-output* "*** instantiating graph~%")
	(let ((top-node (instantiate-kind-recursively top-kind esa-disp)))

	  #+nil(format *standard-output* "*** initializing instances~%")
	  (initialize-all esa-disp)  ;; initialize-all is in esa.lisp

	  #+nil(format *standard-output* "*** distributing initial outputs~%")
	  (distribute-all-outputs esa-disp)  ;; distribute-all-outputs is in esa.lisp

	  #+nil(format *standard-output* "*** injecting START~%")
	  (let ((ev (make-instance 'event))
		(pp (make-instance 'part-pin)))
	    (setf (part-name pp) "self")
	    (setf (pin-name pp) "start")
            (setf (partpin ev) pp)
	    (setf (data ev) t)
	    (enqueue-input top-node ev))

	  #+nil(format *standard-output* "*** running~%")
	  (run esa-disp)  ;; run is in esa.lisp
          )))))

(defun test-lar ()
  (load-and-run (asdf:system-relative-pathname :arrowgrams "build_process/cl-build/helloworld.graph.json")))

