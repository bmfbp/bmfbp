(in-package :arrowgram)

(defun make-touches-rules ()
  (paiprolog::<- (port-touches-ellipse ?port-left-x ?port-top-y ?port-right-x ?port-bottom-y
                                       ?e-left-x    ?e-top-y    ?e-right-x    ?e-bottom-y)
                 ;; port touches left side of ellipse bounding rect
                 (=< ?port-left-x ?e-left-x)
                 (>= ?port-right-x ?e-left-x)
                 (>= ?port-top-y ?e-top-y)
                 (=< ?port-bottom-y ?e-bottom-y))
  (paiprolog::<- (port-touches-ellipse ?port-left-x ?port-top-y ?port-right-x ?port-bottom-y
                                       ?e-left-x    ?e-top-y    ?e-right-x    ?e-bottom-y)
                 ;; port touches top of ellipse bounding rect
                 (=< ?port-top-y ?e-top-y)
                 (>= ?port-bottom-y ?e-top-y)
                 (>= ?port-left-x ?e-left-x)
                 (=< ?port-right-x ?e-right-x))
  (paiprolog::<- (port-touches-ellipse ?port-left-x ?port-top-y ?port-right-x ?port-bottom-y
                                       ?e-left-x    ?e-top-y    ?e-right-x    ?e-bottom-y)
                 ;; port touches right side of ellipse bounding rect
                 (=< ?port-left-x ?e-right-x)
                 (>= ?port-right-x ?e-right-x)
                 (>= ?port-top-y ?e-top-y)
                 (=< ?port-bottom-y ?e-bottom-y))
  (paiprolog::<- (port-touches-ellipse ?port-left-x ?port-top-y ?port-right-x ?port-bottom-y
                                       ?e-left-x    ?e-top-y    ?e-right-x    ?e-bottom-y)
                 ;; port touches bottom of ellipse bounding rect
                 (=< ?port-top-y ?e-bottom-y)
                 (>= ?port-bottom-y ?e-bottom-y)
                 (>= ?port-left-x ?e-left-x)
                 (=< ?port-right-x ?e-right-x)))


(defun add-self-ports ()
  (make-touches-rules)
  (let ((all-self-ports (paiprolog::prolog-collect (?EllipseID ?PortID ?TextID ?str)
                         (port ?PortID)

                         (bounding_box_left ?EllipseID ?E-left-x)
                         (bounding_box_top ?EllipseID ?E-top-y)
                         (bounding_box_right ?EllipseID ?E-right-x)
                         (bounding_box_bottom ?EllipseID ?E-bottom-y)

                         (bounding_box_left ?PortID ?Port-left-x)
                         (bounding_box_top ?PortID ?Port-top-y)
                         (bounding_box_right ?PortID ?Port-right-x)
                         (bounding_box_bottom ?PortID ?Port-bottom-y)

                         (port-touches-ellipse ?Port-left-x ?Port-top-y ?Port-right-x ?Port-bottom-y
                                               ?E-left-x    ?E-top-y    ?E-right-x    ?E-bottom-y)

                         (text ?TextID ?str)
                         (point-completely-inside-bounding-box ?TextID ?EllipseID)
                         
                         !
                         )))
                         
    (mapc #'(lambda (L)
              (destructuring-bind (eid pid tid str) L
                (paiprolog::add-clause `((parent ,eid ,pid)))
                (paiprolog::add-clause `((used ,tid)))
                (paiprolog::add-clause `((portNameByID ,pid ,tid)))
                (paiprolog::add-clause `((portName ,str)))))
          all-self-ports)))
                
                

 