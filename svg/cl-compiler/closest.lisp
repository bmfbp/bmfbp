(in-package :arrowgrams/compiler/ASSIGN-PORTNAMES)

(defclass close ()
  ((side :initarg :side :accessor side)
   (distance :accessor distance :initarg :distance)))

(defun calc-distance (x y x2 y2)
  (let ((dx (- x2 x))
        (dy (- y2 y)))
    (sqrt (+ (* dx dx) (* dy dy)))))
  
(defun text-above-p (port-x port-y text-left text-top text-right text-bottom)
  (declare (ignore text-top))
  (and (< text-bottom port-y)
       (<= text-left port-x text-right)))

(defun text-below-p (port-x port-y text-left text-top text-right text-bottom)
  (declare (ignore text-bottom))
  (and (> text-top port-y)
       (<= text-left port-x text-right)))

(defun text-to-right-p (port-x port-y text-left text-top text-right text-bottom)
  (declare (ignore text-right port-y text-top text-right text-bottom))
  (> text-left port-x))

(defun text-to-left-p (port-x port-y text-left text-top text-right text-bottom)
  (declare (ignore text-left port-y text-left text-top text-bottom))
  (< text-right port-x))


(defun closest (port-left port-top port-right port-bottom text-left text-top text-right text-bottom)
  (let ((port-center-x (+ port-left (/ (- port-right port-left) 2)))
        (port-center-y (+ port-top (/ (- port-bottom port-top) 2))))
    (let ((c 
           (cond ((text-above-p port-center-x port-center-y text-left text-top text-right text-bottom)
                  (make-instance 'close :side :bottom
                                 :distance (min (calc-distance port-center-x port-center-y text-left text-bottom)
                                                (calc-distance port-center-x port-center-y
                                                               (+ text-left (/ (- text-right text-left) 2))
                                                               text-bottom) ;; middle
                                                (calc-distance port-center-x port-center-y text-right text-bottom))))
                 ((text-below-p port-center-x port-center-y text-left text-top text-right text-bottom)
                  (make-instance 'close :side :top
                                 :distance (min (calc-distance port-center-x port-center-y text-left text-top)
                                                (calc-distance port-center-x port-center-y
                                                               (+ text-left (/ (- text-right text-left) 2))
                                                               text-top) ;; middle
                                                (calc-distance port-center-x port-center-y text-right text-top))))
                 ((text-to-right-p port-center-x port-center-y text-left text-top text-right text-bottom)
                  (make-instance 'close :side :left
                                 :distance (min (calc-distance port-center-x port-center-y text-left text-bottom)
                                                (calc-distance port-center-x port-center-y text-right text-top))))
                 ((text-to-left-p port-center-x port-center-y text-left text-top text-right text-bottom)
                  (make-instance 'close :side :right
                                 :distance (min (calc-distance port-center-x port-center-y text-left text-bottom)
                                                (calc-distance port-center-x port-center-y text-right text-top))))
                 (t (assert nil)))))
      c)))
    
(defmethod less-than-p ((a close) (b close))
  (< (distance a) (distance b)))

#+nil(defun distance-test ()
  (let ((port-bb '(50 50 60 60))

        (text1 '(45 20 65 40))
        (text2 '(65 40 80 55))
        (text3 '(65 65 80 70))
        (text4 '(40 70 70 80))
        (text5 '( 5 55 45 70))
        (text6 '( 5 40 65 50))

        (text7 '(80 20 100 40)))

    (let ((d1 (closest (first port-bb) (second port-bb) (third port-bb) (fourth port-bb)
                       (first text1)   (second text1)   (third text1)   (fourth text1)  ))
          (d2 (closest (first port-bb) (second port-bb) (third port-bb) (fourth port-bb)
                       (first text2)   (second text2)   (third text2)   (fourth text2)  ))
          (d3 (closest (first port-bb) (second port-bb) (third port-bb) (fourth port-bb)
                       (first text3)   (second text3)   (third text3)   (fourth text3)  ))
          (d4 (closest (first port-bb) (second port-bb) (third port-bb) (fourth port-bb)
                       (first text4)   (second text4)   (third text4)   (fourth text4)  ))
          (d5 (closest (first port-bb) (second port-bb) (third port-bb) (fourth port-bb)
                       (first text5)   (second text5)   (third text5)   (fourth text5)  ))
          (d6 (closest (first port-bb) (second port-bb) (third port-bb) (fourth port-bb)
                       (first text6)   (second text6)   (third text6)   (fourth text6)  ))
          (d7 (closest (first port-bb) (second port-bb) (third port-bb) (fourth port-bb)
                       (first text7)   (second text7)   (third text7)   (fourth text7)  )) )
      (format *standard-output* "~A ~A ~A ~A ~A ~A ~A~%" d1 d2 d3 d4 d5 d6 d7))))
                       
                       
