(in-package :arrowgrams/parser)

(defun pr (x)
  (format *standard-output* "~&pr: ~S~%" x)
  x)

(defun ignore-trailing-ws-2 (lis)
  (if (= 2 (length lis))
      (first lis)
    lis))

(defun ignore-parens (list)
  (if (and
       (= 3 (length list))
       (char= #\( (first list))
       (char= #\) (third list)))
      (second list)
    list))

(defun ignore-lpar-rpar-3 (lis)
  (if (= 3 (length lis))
      (first lis)
    lis))

(defun ignore-lpar-rpar-4 (lis)
  (if (= 4 (length lis))
      (list (first lis) (third lis))
    lis))

(defun ignore-not-comma-2 (lis)
  (if (= 2 (length lis))
      (first lis)
    lis))

(defun ignore-mid-comma-3 (lis)
  (if (= 3 (length lis))
      (list (first lis) (second lis))
    lis))

       