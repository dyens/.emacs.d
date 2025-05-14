;; -*- lexical-binding: t; -*-
;; Org k8s
(require 'ob)
(require 'ob-eval)

(defvar org-babel-default-header-args:k8s
  '((:exports . "results"))
  "Default arguments for evaluatiing a k8s source block.")

(defcustom ob-k8s-cli-path nil
  "Path to k8s.cli executable."
  :group 'org-babel
  :type 'string)

(defun org-babel-execute:k8s (body params)
  (let* (
         (temp-file (org-babel-temp-file "k8s-"))
         (cmd (concat "kubectl apply -f "
                      (org-babel-process-file-name temp-file)
                      )))
    (with-temp-file temp-file (insert body))
    (org-babel-eval cmd "")
))

(defvar org-babel-default-header-args:dk8s
  '((:exports . "results"))
  "Default arguments for evaluatiing a dk8s source block.")

(defcustom ob-dk8s-cli-path nil
  "Path to dk8s.cli executable."
  :group 'org-babel
  :type 'string)

(defun org-babel-execute:dk8s (body params)
  (let* (
         (temp-file (org-babel-temp-file "dk8s-"))
         (cmd (concat "kubectl delete -f "
                      (org-babel-process-file-name temp-file)
                      )))
    (with-temp-file temp-file (insert body))
    (org-babel-eval cmd "")
))



(provide 'ob-k8s)
