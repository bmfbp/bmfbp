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
          (:code ident (:in) (:out :fatal)
           #'arrowgrams/clparts/ident::react
           #'arrowgrams/clparts/ident::first-time)
          (:schem scanner-tester (:in) (:out :fatal)
           (eol-comments ws ident)
           ((((:self :in)) ((eol-comments :in)))
            (((eol-comments :out)) ((ws :in)))
            (((ws :out)) ((ident :in)))
            (((ident :out)) ((:self :out)))
            (((ident :fatal) (ws :fatal) (eol-comments :fatal)) ((:self :fatal))))))))
    (e/dispatch::ensure-correct-number-of-parts 4) ;; early debug only
    (cl-event-passing-user:@with-dispatch
      (let ((string1 "a    b    c
% comment

d e    f % comment

[g h i] [jkl/m] [n o p / q ]

")
            (string2 "ab")
            (string3 "a
"))
        (with-input-from-string (s string1)
          (let ((c (read-char s nil nil)))
            (@:loop
              (@:exit-when (or (null c) (eq 'EOF c)))
              (cl-event-passing-user::@inject net (e/part::get-input-pin net :in) c)
              (setf c (read-char s nil 'EOF)))
            (cl-event-passing-user::@inject net (e/part::get-input-pin net :in) :EOF)))))))
