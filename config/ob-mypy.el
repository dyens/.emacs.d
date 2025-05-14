;; -*- lexical-binding: t; -*-
;; Org mypy
(require 'ob)
(require 'ob-eval)

(defvar org-babel-default-header-args:mypy
  '((:exports . "results"))
  "Default arguments for evaluatiing a mypy source block.")

(defcustom ob-mypy-cli-path nil
  "Path to mypy.cli executable."
  :group 'org-babel
  :type 'string)

(defun org-babel-execute:mypy (body params)
  (let* (
         (temp-file (org-babel-temp-file "mypy-"))
         (cmd (concat "mypy"
                      " "
                      (org-babel-process-file-name temp-file)
                      " --enable-incomplete-feature=NewGenericSyntax"
                      )))
    (with-temp-file temp-file (insert body))
    (org-babel-eval cmd "")
))

(provide 'ob-mypy)
