(in-package :arrowgrams/parser)
(defparameter *rules-defined* nil)
(defparameter *rules-called* nil)
(defparameter *parsed* nil)
(defparameter *converted* nil)
(defparameter *rules-needed* nil)

(defparameter *str1*
"
nle :- nl(user_error).
")

(defparameter *str2*
"
we(X) :- write(user_error,X).
")

(defparameter *str3*
"
condRect :-
    forall(rect(ID), createRectBoundingBox(ID)).
")

(defparameter *str4*
"
notNamedSource(X) :-
    namedSource(X),
    !,
    true,
    fail.
")

(defparameter *str5*
"
notNamedSource(X) :-
    asserta(log(BoxID,box_is_meta_data)),
    retract(rect(BoxID)).
")

(defparameter *str6*
"
sem_speechVScomments_main :-
    readFB(user_input),
    g_assign(counter,0),
% pt
    forall(speechbubble(ID),inc(counter,_)),
% pt
    forall(comment(ID),dec(counter,_)),
    g_read(counter,Counter),
    checkZero(Counter),
    writeFB,
    halt.
")

(defparameter *str7*
"
sem_speechVScomments_main :-
    g_assign(counter,0),
    prolog_not_equal(Kind1,Kind2),
    prolog_not_equal_equal(Kind1,Kind2).
")

(defparameter *str8*
"
x :-    
     Left is CX - HalfWidth,
     L1 >= L2.
")

(defparameter *str9*
  "
x :-
    prolog_not_proven(namedSink(X)),
    prolog_not_proven(used(TextID)),
    prolog_not_proven(used(TextID)).
")

(defun convert (parsed)
  (setq *parsed* parsed)
  ;(setq *parsed* (esrap:parse 'rule-TOP *str9*))
  (setq *converted* nil)
  (setq *rules-needed* nil)
  (setq *rules-defined* nil)
  (setq *rules-called* nil)
  (setq *converted* (g-to-h *parsed*))
  (setq *converted* (delete nil *converted*))
  (setq *rules-defined* (sort-by-name *rules-defined*))
  (setq *rules-called* (sort-by-name (append *rules-needed* *rules-called*)))
  (setq *rules-needed* (sort-by-name *rules-needed*))
  (let ((manually-added-facts (sort-by-name +facts+)))
    (let ((diff1 (set-difference *rules-called* manually-added-facts)))
      (let ((diff2 (set-difference diff1 *rules-defined*)))
        (format *standard-output* "~%~%~A rules defined, ~A rules called~%~%"
                (length *rules-defined*) (length *rules-called*))
        (if (zerop (length diff2))
            (format *standard-output* "NO missing rules")
          (format *standard-output* "~A missing rules=~S"
                  (length diff2) diff2))
        (format *standard-output* "~%~%"))
      *converted*)))
    

(defun g-to-h (parsed)
  (setf *rules-defined* nil)
  (mapcar #'convert-g-to-h (cdr parsed)))

(defun convert-g-to-h (rule)
  (cond ((and (= 1 (length rule))
              (eq 'directive (car rule)))
         nil)
        (t
         (assert (eq 'rule (car rule)))
         (let ((head (walk-predicate (second rule)))
               (body (walk-predicate-list (third rule))))
           (let ((name (car head))
                 (args (cdr head)))
             (let ((arity (length args)))
               ;(assert (eq (find-package "KEYWORD") (symbol-package name)))
               (let ((string-name (intern (format nil "~A/~A" (symbol-name name) arity) "KEYWORD")))
                 (pushnew string-name *rules-defined* :test 'name-EQ)
                 (when (eq :predicate name)
                   (break ""))
                 (let ((rewritten (rewrite body)))
                   (let ((final-body (mapc #'memo-called-rule rewritten)))
                     `( (,name ,@args)
                        ,@final-body ))))))))))
                   
(defun walk-predicate-list (x)
  (unless (null x)
    (assert (eq 'predicate-list (first x)))
    (cons
     (walk-predicate (second x))
     (walk-predicate-list (third x)))))

(defun walk-predicate (pred)
  (assert (eq 'predicate (first pred)))
  (let ((arg (second pred)))
    (case (first arg)
      (atom (list (walk-atom arg)))
      (structure (walk-structure arg))
      (is (walk-is arg))
      (otherwise (if (and (listp arg)
                          (or (eq '>= (first arg)) (eq '<= (first arg))))
                     `(:lisp (,(first arg) ,(walk-term (second arg)) ,(walk-term (third arg))))
                   arg))))) 

(defun walk-atom (x)
  (assert (eq 'atom (first x)))
  (let ((arg (second x)))
    (if (listp arg)
        (ecase (first arg)
          (ident (intern (string-upcase (second arg)) "KEYWORD")))
      (ecase arg
        (true nil)
        (fail :fail)
        (cut :!)))))

(defun walk-structure (x)
  (assert (eq 'structure (car x)))
  (let ((head (walk-atom (second x)))
        (args (walk-term-list (third x))))
    `(,head ,@args)))

(defun walk-term-list (x)
  (unless (null x)
    (assert (and (listp x) (eq 'term-list (car x))))
    (cons (walk-term (second x))
          (walk-term-list (third x)))))

(defun walk-term (x)
  (assert (and (listp x) (eq 'term (car x))))
  (let ((term (second x)))
    (ecase (car term)
      (atom (walk-atom term))
      (structure (walk-structure term))
      (var (walk-var term))
      (constant (walk-constant term)))))

(defun walk-var (x)
  (assert (and (listp x) (eq 'var (car x))))
  `(:? ,(intern (string-upcase (second x)))))

(defun walk-constant (x)
  (assert (and (listp x) (eq 'constant (car x))))
  (let ((val (second x)))
    (assert (or (eq (first val) 'int) (eq (first val) 'string)))
    (second val)))

(defun walk-is (x)
  (assert (and (listp x) (eq 'is (car x))))
  (let ((LHS (walk-var (second x)))
        (RHS (list (first (third x))
                   (walk-predicate-or-expr (second (third x)))
                   (walk-predicate-or-expr (third (third x))))))
    `(:lispv ,LHS ,RHS)))

(defun walk-predicate-or-expr (x)
  (assert (listp x))
  (if (eq 'precidate (car x))
      (walk-predicate x)
    (walk-expr x)))

(defun walk-expr (x)
  (unless (null x)
    (if (atom x)
        x
      (progn
        (assert (listp x))
        (if (eq 'primary (first x))
            (walk-primary x)
          (cons (first x)
                (cons (walk-expr (second x))
                      (walk-expr (third x)))))))))

(defun walk-primary (x)
  (unless (null x)
    (assert (listp x))
    (assert (eq 'primary (first x)))
    (let ((arg (second x)))
      (ecase (first arg)
        (var (walk-var arg))
        (int (second arg))
        (ident (intern (second arg)))
        ((+ - * /) (cons (first arg)
                         (cons (walk-primary (second arg))
                               (walk-primary (third arg)))))))))


(defun memo-called-rule (x)
  (when (and (listp x) (not (null x)))
    (let ((rule-name (car x))
          (args (cdr x)))
      (when (atom rule-name)
        (let ((rule-name-with-arity (intern (format nil "~A/~A" (string-upcase (symbol-name rule-name)) (length args)) "KEYWORD")))
          (pushnew rule-name-with-arity *rules-called* :test 'name-EQ))))))

(defun rewrite (body)
  (let ((result nil))
    (mapc #'(lambda (x)
              (let ((r (rewrite1 x)))
                (if (and (listp r) (eq :@ (car r)))
                    (progn
                      (push (second r) result)
                      (push (third r) result))
                  (push r result))))
          body)
    (reverse result)))

(defun rewrite1 (x)
  (if (listp x)
      (cond
       ((= 1 (length x)) ;/0
        (cond
         ((eq (car x) :fail)
            :fail)
         ((eq (car x) :!)
            :!)
         ((eq (car x) :true)
          `(:lisp (true)))
         ((eq (car x) :halt)
          `(:lisp (true)))
         ((eq (car x) :writefb)
          `(:lisp (true)))

         (t x)))
        
       ((= 2 (length x)) ;/1
        (cond
         ((eq (car x) :nl)
          (let ((stream (if (eq :user_error (second x)) '*standard-error* '*standard-output*)))
            `(:lisp (format ,stream "~%"))))
         ((eq (car x) :readfb)
          `(:lisp (true)))
         ((eq (car x) :asserta)
          `(:lisp-method (asserta ',(second x))))
         ((eq (car x) :retract)
          `(:lisp-method (retract ',(second x))))

         ((eq (car x) :prolog_not_proven)
          (let ((clause (second x)))
            (let ((not-name (intern (format nil "NOT-~A" (symbol-name (car clause))) "KEYWORD")))
              (let ((not-name-with-arity (intern (format nil "~A/~A"
                                                         (symbol-name not-name)
                                                         (1- (length clause)))
                                                 "KEYWORD")))
                (let ((rewritten `(,not-name ,@(rest clause))))
                  (pushnew not-name-with-arity *rules-needed* :test 'name-EQ)
                  rewritten)))))

         (t x)))
             
       ((= 3 (length x)) ;/2
        (cond
         ((eq (car x) :write)
          (let ((stream (if (eq :user_error (second x)) '*standard-error* '*standard-output*)))
            `(:lisp (format ,stream "~A" ,(third x)))))
         ((eq (car x) :forall)
          `(:@ ,(second x) ,(third x)))

         ((and (eq (first x) :inc)
               (eq (second x) :counter))
          `(:lisp (inc-counter)))
         ((and (eq (first x) :dec)
               (eq (second x) :counter))
          `(:lisp (dec-counter)))
         ((and (eq (first x) :g_read)
               (eq (second x) :counter))
          `(:lispv ,(third x) (read-counter)))
         ((and (eq (first x) :g_assign)
               (eq (second x) :counter))
          `(:lisp (set-counter ,(third x))))

         ((eq (first x) :prolog_not_equal_equal)
          `(:not-same ,(second x) ,(third x)))
         ((eq (first x) :prolog_not_equal)
          `(:not-same ,(second x) ,(third x)))

         (t x)))
       
       (t x))
    x))


(defun create ()
  (let ((tree (esrap:parse 'rule-TOP *all-prolog*)))
    (let ((converted (convert tree)))
      (write-to-rules converted (asdf:system-relative-pathname :arrowgrams "svg/cl-compiler/rules.lisp"))
    'done)))
  

(defun write-to-rules (lis fname)
  (with-open-file (outf fname :direction :output :if-exists :supersede)
    (format outf "(in-package :arrowgrams/compiler)~%~%")
    (format outf "(defconstant +rules+ '(")
    (pprint lis outf)
    (format outf "~%)~%")))


(defun sort-by-name (sym-list)
  (sort sym-list #'name-GE))

(defun name-GE (sym1 sym2)
  (let ((p1 (symbol-package sym1))
        (p2 (symbol-package sym2)))
    (if (eq p1 p2)
        (let ((s1 (symbol-name sym1))
              (s2 (symbol-name sym2)))
          (string-greaterp s1 s2))
      (string-greaterp (package-name p1) (package-name p2)))))

(defun name-EQ (sym1 sym2)
  (let ((p1 (symbol-package sym1))
        (p2 (symbol-package sym2)))
    (if (eq p1 p2)
        (let ((s1 (symbol-name sym1))
              (s2 (symbol-name sym2)))
          (string= s1 s2))
      nil)))
