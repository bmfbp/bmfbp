(in-package :arrowgrams/build)

(defun my-command-line ()
  ;https://stackoverflow.com/questions/1021778/getting-command-line-arguments-in-common-lisp
  (or 
   #+CLISP *args*
   #+SBCL sb-ext:*posix-argv*  
   #+LISPWORKS system:*line-arguments-list*
   #+CMU extensions:*command-line-words*
   nil))
