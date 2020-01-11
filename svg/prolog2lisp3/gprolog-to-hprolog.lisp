(in-package :arrowgrams/parser)

(defparameter *rules-defined* nil)
(defparameter *rules-called* nil)
(defparameter *parsed* nil)
(defparameter *converted* nil)
(defparameter *rules-needed* nil)
(defparameter *foralls* nil)

(defun convert (parsed)
  (setq *parsed* parsed)
  (setq *converted* nil)
  (setq *rules-needed* nil)
  (setq *rules-defined* nil)
  (setq *rules-called* nil)
  (setq *foralls* nil)
  (setq *converted* (g-to-h *parsed*))
  (setq *converted* (delete nil *converted*))
  (setq *rules-defined* (sort-by-name *rules-defined*))
  (setq *rules-called* (sort-by-name (append *rules-needed* *rules-called*)))
  (setq *rules-needed* (sort-by-name *rules-needed*))
  (let ((manually-added-facts (sort-by-name *facts*)))
    (let ((diff1 (set-difference *rules-called* manually-added-facts)))
      (let ((diff2 (set-difference diff1 *rules-defined*)))
        (format *standard-output* "~%~%~A rules defined, ~A rules called~%"
                (length *rules-defined*) (length *rules-called*))
        (format *standard-output* "foralls created ~A~%~%" (length *foralls*))
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
         (assert (or (eq 'rule (car rule)) (eq 'fact (car rule))))
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
                     `(:lisp-true-fail (,(first arg) ,(walk-term (second arg)) ,(walk-term (third arg))))
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
  (let ((LHS (walk-var (second x))))
    (if (and (listp x)
             (= 3 (length x))
             (member (first (third x)) '(+ - * /)))
        (progn
          (let ((RHS (list (first (third x))
                           (walk-predicate-or-expr (second (third x)))
                           (walk-predicate-or-expr (third (third x))))))
            `(:lispv ,LHS ,RHS)))
      (if (and (listp x)
               (= 3 (length x))
               (eq 'predicate (car (third x))))
          (let ((r (walk-predicate (third x))))
            (let ((RHS
                   (cond
                    ((eq (car r) :sqrt)
                     (cons 'cl:sqrt (cdr r)))
                     ((eq (car r) :abs)
                      (cons 'cl:abs (cdr r)))
                     ((eq (car r) :lisp_return_closest_text)
                      (cons 'arrowgrams/compiler::lisp-return-closest-text (cdr r)))
                     ((eq (car r) :lisp_return_closest_port)
                      (cons 'arrowgrams/compiler::lisp-return-closest-port (cdr r)))
                     ((eq (car r) :lisp_return_closest_string)
                      (cons 'arrowgrams/compiler::lisp-return-closest-string (cdr r)))
                     (t (assert nil)))))
              `(:lispv ,LHS ,RHS)))
        (assert nil)))))

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
               (let ((r (rewrite-helper x)))
                  (push r result)))
          body)
    (reverse result)))

(defun rewrite-1 (x)
  (cond
   ((eq (car x) :fail)
    :fail)
   ((eq (car x) :!)
    :!)
   ((eq (car x) :true)
    `(:lisp (arrowgrams/compiler::true)))
   ((eq (car x) :halt)
    `(:lisp (arrowgrams/compiler::true)))
   ((eq (car x) :writefb)
    `(:lisp (arrowgrams/compiler::true)))
   
   ((eq (car x) :lisp_collect_begin)
    `(:lisp (arrowgrams/compiler::lisp-collect-begin)))
   
   ((eq (car x) :lisp_collect_finalize)
    `(:lisp (arrowgrams/compiler::lisp-collect-finalize)))
   
   (t x)))

(defun rewrite-2 (x)
  (cond
   ((eq (car x) :nl)
    (let ((stream (if (eq :user_error (second x)) '*standard-error* '*standard-output*)))
      `(:lisp (arrowgrams/compiler::out-nl))))
   ((eq (car x) :readfb)
    `(:lisp (arrowgrams/compiler::true)))
   ((eq (car x) :asserta)
    `(:lisp-method (arrowgrams/compiler/util::asserta ,(second x))))
   ((eq (car x) :retract)
    `(:lisp-method (arrowgrams/compiler/util::retract ,(second x))))
   
   ((eq (car x) :prolog_not_proven)
    (let ((clause (second x)))
      (let ((not-name (intern (format nil "NOT_~A" (symbol-name (car clause))) "KEYWORD")))
        (let ((not-name-with-arity (intern (format nil "~A/~A"
                                                   (symbol-name not-name)
                                                   (1- (length clause)))
                                           "KEYWORD")))
          (let ((rewritten `(,not-name ,@(rest clause))))
            (pushnew not-name-with-arity *rules-needed* :test 'name-EQ)
            rewritten)))))

   (t x)))

(defun rewrite-3 (x)
  (cond
   ((eq (car x) :write)
    `(:lisp (arrowgrams/compiler::out ,(third x))))

   ((eq (first x) :sqrt)
    (break)
    `(:lispv ,(second x) (cl:sqrt ,(third x))))

   ((and (eq (first x) :inc)
         (eq (second x) :counter))
    `(:lisp (arrowgrams/compiler::inc-counter)))
   ((and (eq (first x) :dec)
         (eq (second x) :counter))
    `(:lisp (arrowgrams/compiler::dec-counter)))
   ((and (eq (first x) :g_read)
         (eq (second x) :counter))
    `(:lispv ,(third x) (read-counter)))
   ((and (eq (first x) :g_assign)
         (eq (second x) :counter))
    `(:lisp (arrowgrams/compiler::set-counter ,(third x))))

   ((eq (first x) :prolog_not_equal_equal)
    `(:not_same ,(second x) ,(third x)))
   ((eq (first x) :prolog_not_equal)
    `(:not_same ,(second x) ,(third x)))
   (t x)))

(defun rewrite-4 (x)
  x)

(defun rewrite-5 (x)
  (cond
   ((eq (car x) :lisp_collect_distance)
    (let ((arg1 (second x))
          (arg2 (third x))
          (arg3 (fourth x))
          (arg4 (fifth x)))
      `(:lisp (arrowgrams/compiler::lisp-collect-distance ,arg1 ,arg2 ,arg3 ,arg4))))
   (t x)))

(defun rewrite-helper (x)
  (if (listp x)
      (cond
       ((= 1 (length x)) ;/0
        (rewrite-1 x))
       ((= 2 (length x)) ;/1
        (rewrite-2 x))
       ((= 3 (length x)) ;/2
        (rewrite-3 x))
       ((= 4 (length x)) ;/3
        (rewrite-4 x))
       ((= 5 (length x)) ;/4
        (rewrite-5 x))
       (t x))
    x))

(defun create ()
  (let ((tree (esrap:parse 'rule-TOP *all-prolog*)))
  ;(let ((tree (esrap:parse 'rule-TOP *test1*)))
    (let ((converted1 (convert tree)))
      (let ((converted2 (if *foralls* (cons *foralls* converted1) converted1)))
        (write-to-rules converted2 (asdf:system-relative-pathname :arrowgrams "svg/cl-compiler/rules.lisp")))))
    'done)

(defun write-to-rules (lis fname)
  (with-open-file (outf fname :direction :output :if-exists :supersede)
    (format outf "(in-package :arrowgrams/compiler)~%~%")
    (format outf "(defparameter *rules*~%'")
    (pprint lis outf)
    (format outf ")~%~%")))


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
