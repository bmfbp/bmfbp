(in-package :cl-event-passing)

(defmacro cl-event-passing-user:@defnetwork (name &rest defs)
  `(progn
     (cl-event-passing-user::@initialize)
     ,(cl-event-passing::compile-network name defs)))

(defun compile-network (name defs)
  (if (null defs)
      `(let ()
         (cl-event-passing-user::@top-level-schematic ,name)
         (e/util::check-top-level-schematic-sanity ,name)
         ,name)
    (compile-one-network name (first defs) (rest defs))))

(defun compile-one-network (name def tail)
    (let ((one
           (ecase (car def)
           
             (:part
              (destructuring-bind (reused-net-name new-part-name inputs outputs)
                  (rest def)
                `(let ((,new-part-name
                        (cl-event-passing-user:@reuse-part ,reused-net-name
                         :name ',new-part-name
                         :input-pins ',inputs
                         :output-pins ',outputs))))))

             (:code
              (destructuring-bind (code-name inputs outputs &optional (input-handler nil) (first-time-handler nil))
                  (rest def)
                (let ((dest-pkg (find-package (symbol-package code-name))))
                  `(let ((,code-name (cl-event-passing-user:@new-code
                                      :kind ',code-name
                                      :name ,(symbol-name code-name)
                                      :input-handler #',(or
                                                         (when (and (listp input-handler)
                                                                    (eq 'function (first input-handler)))
                                                           (second input-handler))
                                                         input-handler
                                                         'e/part::react)
                                                                                          ;(let ((fn (intern "REACT" dest-pkg)))
                                                                                          ;  fn))
                                      :input-pins ',inputs :output-pins ',outputs
                                      :first-time-handler #',(or 
                                                              (when (and (listp first-time-handler)
                                                                         (eq 'function (first first-time-handler)))
                                                                (second first-time-handler))
                                                              first-time-handler
                                                              'e/part::first-time))))))))
                                                                                              ;(let ((fn (intern "FIRST-TIME" dest-pkg)))
                                                                                               ;  fn)))))))))
             (:schem
              (destructuring-bind (schem-name inputs outputs parts-list nets &optional (first-time-handler nil))
                  (rest def)
                `(let ((,schem-name (cl-event-passing-user:@new-schematic :name ,(symbol-name schem-name)
                                                                          :input-pins ',inputs :output-pins ',outputs
                                                                          :first-time-handler ,first-time-handler)))
                   ,@(compile-parts schem-name parts-list)
                   ,@(compile-nets schem-name (net-parser nets)))))))
          
           (compiled-tail (compile-network name tail)))
          
      (if compiled-tail
          (append one (list compiled-tail))
        one)))

(defun compile-parts (schem-name part-list)
  (mapcar #'(lambda (id)
              `(cl-event-passing-user:@add-part-to-schematic ,schem-name ,id))
          part-list))

(defun make-receiver (schem-name pair)
  (if (eq :self (first pair))
      `(e/receiver::new-receiver
        :pin (e/pin::existing-pin
              :pin-parent ,schem-name
              :pin-name ,(second pair)
              :direction :output))
    `(e/receiver::new-receiver
      :pin (e/pin::existing-pin
            :pin-parent ,(first pair)
            :pin-name ,(second pair)
            :direction :input))))

(defun make-source (schem-name pair)
  (if (eq :self (first pair))
      `(e/source::new-source :pin (e/pin::existing-pin
                                   :pin-parent ,schem-name
                                   :pin-name ,(second pair)
                                   :direction :input))
    `(e/source::new-source :pin (e/pin::existing-pin
                                 :pin-parent ,(first pair)
                                 :pin-name ,(second pair)
                                 :direction :output))))

(defun compile-nets (schem-name net-list)
  (let ((wires (mapcar #'(lambda (net)
                                    (assert (= 2 (length net)))
                                    `(,(gensym "WIRE-") (make-wire (list ,@(mapcar #'(lambda (part-pin-pair)
                                                                                       (make-receiver schem-name part-pin-pair))
                                                                                   (second net))))))
                        net-list)))
    (let ((wire-names (mapcar #'first wires))
          (sources-for-each-wire (mapcar #'first net-list)))
      (let ((sources
              (mapcar #'(lambda (wire-name source-list)
                          `(make-sources-for-wire ,schem-name
                                                  ,wire-name
                                                  (list ,@(mapcar #'(lambda (part-pin-pair)
                                                               (make-source schem-name part-pin-pair))
                                                           source-list))))
                      wire-names sources-for-each-wire)))
        `((let (,@wires)
            ,@sources))))))
               


#|
(defun mtest ()
  (pprint
   (compile-network '(
                      (code flow-through-1 (:ftin) (:ftout) #'flow-through)
                      (code flow-through-2 (:ftin) (:ftout) #'flow-through)
                      ))))


(defun mtest2 ()
  (pprint
   (compile-network '(
                      (schem top (:in :in2) (:out :out2)
                             (child1 child2 child3)
                             (
                              ( ((self :in)) --> ((child :childin)) )

                              ( ((child :childout)) --> ((self :out)) )
                              )
                             )))))

(defun mtest3 ()
  (pprint
   (compile-network '(
                      (code flow-through-1 (:ftin) (:ftout) #'flow-through)
                      (code flow-through-2 (:ftin) (:ftout) #'flow-through)

                      (schem child (:childin) (:childout)
                             (flow-through-1 flow-through-2)
                             (
                              ( ((self :childin))        --> ((flow-through-1 :ftin)) )
                              ( ((flow-through-1 :ftout)) --> ((flow-through-2 :ftin)) )
                              ( ((flow-through-2 :ftout)) --> ((self :childout)) )
                              )
                             )

                      (schem top (:in) (:out)
                             (child)
                             (
                              ( ((self :in))  --> ((child :childin)) )
                              ( ((child :childout)) --> ((self :out)) )
                              )
                             )

                      )
                    )))

|#
