
(define link list)
(define L_l car)
(define L_g cadr)
(define L_r caddr)
(define L_e cadddr)
(define (L_n x) (car (cddddr x)))

(define (L_c x) (cadr (cddddr x)))


(define (clear_r x)
  (set-car! (cddr x) '(())))


(define (back6 l g r e n c result)
  (cond
    ((and (pair? g)
          (pair? r))
      (prove6 l g (cdr r) e n c result))
    ((pair? l)
      (prove6 (L_l l)
              (L_g l)
              (cdr (L_r l))
              (L_e l)
              (L_n l)
              (L_c l)
	      result))))


(define (prove6 l g r e n c result)
  (cond
    ((null? g)
      (back6 l g r e n c (cons (collect-frame e) result)))
    ((eq? '! (car g))
      (clear_r c)
      (prove6 c (cdr g) r e n c result))
    ((eq? 'r! (car g))
      (prove6 l (cddr g) r e n (cadr g) result))
    ((null? r)
      (if (null? l)
          result
          (back6 l g r e n c result)))
    (else
      (let* ((a  (copy (car r) n))
             (e* (unify (car a) (car g) e)))
        (if e*
            (prove6 (link l g r e n c)
                    (append (cdr a) `(r! ,l) (cdr g))
                    db
                    e*
                    (+ 1 n)
                    l
		    result)
            (back6 l g r e n c result))))))


(define empty '((bottom)))

(define var '?)
(define name cadr)
(define time cddr)

(define (var? x)
  (and (pair? x)
       (eq? var (car x))))

(define (lookup v e)
  (let ((id (name v))
        (t  (time v)))
    (let loop ((e e))
      (cond ((not (pair? (caar e)))
              #f)
            ((and (eq? id (name (caar e)))
                  (eqv? t (time (caar e))))
              (car e))
            (else
              (loop (cdr e)))))))

(define (value x e)
  (if (var? x)
      (let ((v (lookup x e)))
        (if v
            (value (cadr v) e)
            x))
      x))

(define (copy x n)
  (cond
    ((not (pair? x)) x)
    ((var? x) (append x n))
    (else
      (cons (copy (car x) n)
            (copy (cdr x) n)))))

(define (bind x y e)
  (cons (list x y) e))

(define (unify x y e)
  (let ((x (value x e))
        (y (value y e)))
    (cond
      ((eq? x y) e)
      ((var? x) (bind x y e))
      ((var? y) (bind y x e))
      ((or (not (pair? x))
           (not (pair? y))) #f)
      (else
        (let ((e* (unify (car x) (car y) e)))
          (and e* (unify (cdr x) (cdr y) e*)))))))


(define (resolve x e)
  (cond ((not (pair? x)) x)
        ((var? x)
          (let ((v (value x e)))
            (if (var? v)
                v
                (resolve v e))))
        (else
          (cons
            (resolve (car x) e)
            (resolve (cdr x) e)))))

(define (print-and-collect-frame e)
  (let ((result '()))
    (newline)
    (let loop ((ee e))
      (cond ((pair? (cdr ee))
             (cond ((null? (time (caar ee)))
                    (display (cadaar ee))
                    (display " = ")
                    (display (resolve (caar ee) e))
                    (newline)
		    (set! result
			  (cons
			   (cons (cadaar ee) (resolve (caar ee) e))
			   result))))
	     (loop (cdr ee)))))
    result))
  
(define (collect-frame e)
  (let ((result '()))
    (let loop ((ee e))
      (cond ((pair? (cdr ee))
             (cond ((null? (time (caar ee)))
		    (set! result
			  (cons
			   (cons (cadaar ee) (resolve (caar ee) e))
			   result))))
	     (loop (cdr ee)))))
    result))
  

