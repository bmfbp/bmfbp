(in-package :arrowgrams/build)

(defun instantiate-kind-recursively (top-kind disp)
  ;; top-kind -> tree of nodes
  ;;
  ;; (kind gives one definition for every node
  ;;  tree of nodes might create more than one node of the same kind)
  ;;
  ;; and memo each node within dispatcher (disp)
  ;;
  ;; kind and dispatcher are defined in ../cl-build/cl-user-esa.lisp

  (let ((top-most-node (cl-user::loader top-kind "TOP" nil disp)))
    top-most-node))
