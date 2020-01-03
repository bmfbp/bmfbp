(in-package :arrowgrams/parser)

(defparameter *rules-defined* nil)
(defparameter *rules-called* nil)
(defparameter *parsed* nil)
(defparameter *converted* nil)

(defparameter *str1*
"
nle :- nl(user_error).
")

(defun convert ()
  ;(setq *parsed* (esrap:parse 'rule-TOP *all-prolog*))
  (setq *parsed* (esrap:parse 'rule-TOP *str1*))
  (setq *converted* nil)
  (setq *rules-defined* nil)
  (setq *rules-called* nil)
  (setq *converted* (g-to-h *parsed*))
  (setq *converted* (delete nil *converted*))
  (pprint *converted*)
  (format *standard-output* "~%~%")
  (let ((diff1 (set-difference *rules-called* +facts+)))
    (set-difference diff1 *rules-defined*)))
    

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
                 (pushnew string-name *rules-defined* :test 'string=)
                 (let ((rewritten (rewrite body)))
                   (let ((final-body (mapc #'memo-called-rule rewritten)))
                     `( (,string-name ,@args)
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
      (otherwise pred))))

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
  (second x))

(defun walk-is (x)
  (assert (and (listp x) (eq 'is (car x))))
  (let ((LHS (walk-var (second x)))
        (RHS (convert-vars (third x))))
    `(,LHS ,RHS)))

(defun convert-vars (x)
  (unless (null x)
    (if (and (listp x) (eq 'var (car x)))
        (walk-var x)
      (if (listp x)
          (cons (convert-vars (car x))
                (convert-vars (cdr x)))
        x))))




(defun memo-called-rule (x)
  (when (and (listp x) (not (null x)))
    (let ((rule-name (car x))
          (args (cdr x)))
      (when (atom rule-name)
        (let ((rule-name-with-arity (intern (format nil "~A/~A" (string-upcase (symbol-name rule-name)) (length args)) "KEYWORD")))
          (pushnew rule-name-with-arity *rules-called*))))))

(defun rewrite (body)
  (mapcar #'rewrite1 body))

(defun rewrite1 (x)
  (if (listp x)
      (progn
        (format *standard-output* "~&rewrite1 ~A~%" x)
        (cond ((and (= 2 (length x))
                    (eq (car x) :nl))
               (let ((stream (if (eq :user_error (second x)) '*standard-error* '*standard-output*)))
                 `(lisp (format ,stream "~%"))))
              (t x)))
    x))

