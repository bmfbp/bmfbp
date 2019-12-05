(in-package :arrowgrams/clparts)

(defun test-scanner ()
  (cl-event-passing-user::@enable-logging)
  (let ((net
         (cl-event-passing-user:@defnetwork
          scanner-tester
          (:code eol-comments (:in) (:out :fatal)
           #'arrowgrams/clparts/comments-to-end-of-line::react
           #'arrowgrams/clparts/comments-to-end-of-line::first-time)
          (:code ws (:in) (:out :fatal)
           #'arrowgrams/clparts/remove-ws-runs::react
           #'arrowgrams/clparts/remove-ws-runs::first-time)
          (:schem scanner-tester (:in) (:out :fatal)
           (eol-comments ws)
           ((((:self :in)) ((eol-comments :in)))
            (((eol-comments :out)) ((ws :in)))
            (((ws :out)) ((:self :out)))
            (((ws :fatal) (eol-comments :fatal)) ((:self :fatal))))))))
    (e/dispatch::ensure-correct-number-of-parts 3) ;; early debug only
    (cl-event-passing-user:@with-dispatch
      (let ((string1 "a    b    c
% comment

d e    f % comment

g h i

")
            (string2 "a b"))
        (with-input-from-string (s string2)
          (let ((c (read-char s nil nil)))
            (@:loop
              (@:exit-when (or (null c) (eq 'EOF c)))
              (cl-event-passing-user::@inject net (e/part::get-input-pin net :in) c)
              (setf c (read-char s nil 'EOF)))
            (cl-event-passing-user::@inject net (e/part::get-input-pin net :in) :EOF)))))))
