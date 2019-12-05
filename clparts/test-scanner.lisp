(in-package :arrowgrams/clparts)

(defun test-scanner ()
  (cl-event-passing-user::@enable-logging)
  (let ((net
         (cl-event-passing-user:@defnetwork
          scanner-tester
          (:code eol-comments (:in) (:out :fatal)
           #'arrowgrams/clparts/comments-to-end-of-line::react
           #'arrowgrams/clparts/comments-to-end-of-line::first-time)
          (:schem scanner-tester (:in) (:out :fatal)
           (eol-comments)
           ((((:self :in)) ((eol-comments :in)))
            (((eol-comments :out)) ((:self :out)))
            (((eol-comments :fatal)) ((:self :fatal))))))))
    (e/dispatch::ensure-correct-number-of-parts 2) ;; early debug only
    (cl-event-passing-user:@with-dispatch
     (with-input-from-string (s
                              "a b c
% comment

d e f % comment

g h i

")
       (let ((c (read-char s nil nil)))
         (@:loop
          (@:exit-when (null c))
          (cl-event-passing-user::@inject net (e/part::get-input-pin net :in) c)
          (setf c (read-char s nil nil)))
        (cl-event-passing-user::@inject net (e/part::get-input-pin net :in) :EOF))))))
