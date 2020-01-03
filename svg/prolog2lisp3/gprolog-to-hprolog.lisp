(in-package :arrowgrams/parser)

(defparameter *rules-defined* nil)
(defparameter *parsed* nil)

(defun convert ()
  (setq *parsed* (esrap:parse 'rule-TOP *all-prolog*))
  (g-to-h *parsed*)
  *rules-called*)

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
               (let ((string-name (format nil "~A/~A" (symbol-name name) arity)))
                 (format *standard-output* "~&rule ~S~%" string-name)
                 (pushnew string-name *rules-defined* :test 'string=))))))))
                   
(defun walk-predicate-list (x)
  (unless (null x)
    (assert (eq 'predicate-list (first x)))
    (list (walk-predicate (second x))
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