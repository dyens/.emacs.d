;; PDB file view on debug in vterm

;;;#autoload
(defun dy-pdb-debug-shell-mode-hook ()
  (add-hook
   'comint-output-filter-functions
   'python-pdbtrack-comint-output-filter-function t))
(add-hook 'shell-mode-hook 'dy-pdb-debug-shell-mode-hook)

;; Yapfify
(use-package yapfify
  :ensure t
  :after python)

;; Black
(use-package blacken
  :ensure t
  :commands (blacken-buffer)
  :after python)

;; Ruff
(use-package ruff-format
  :ensure t
  :commands (ruff-format-buffer ruff-sort-buffer)
  :config
  (reformatter-define ruff-sort
    :program ruff-format-command
    :args (list "check" "--fix" "--select" "I" "--stdin-filename" (or (buffer-file-name) input-file))
    :lighter "RuffSort"
    :group 'ruff-format))

;; Pydoc
(use-package pydoc
  :ensure t
  :after python)

;; Flymake ruff
(use-package flymake-ruff
  :ensure t
  :hook ((python-mode . flymake-ruff-load)
         (eglot-managed-mode . flymake-ruff-load))
  :config
  ;;;#autoload
  (defun my-filter-eglot-diagnostics (diags)
      "Drop Pyright 'variable not accessed' notes from DIAGS."
      (list (seq-remove (lambda (d)
                          (and (eq (flymake-diagnostic-type d) 'eglot-note)
                              (s-starts-with? "Pyright:" (flymake-diagnostic-text d))
                              (s-ends-with? "is not accessed" (flymake-diagnostic-text d))))
                      (car diags))))
  
  (advice-add 'eglot--report-to-flymake :filter-args #'my-filter-eglot-diagnostics))

;; Python mode
(use-package python
  :ensure nil
  :mode ("\\.py\\'" . python-mode)
  :after (subr-x evil)
  :custom
  (python-indent-def-block-scale 1)
  (python-shell-interpreter "ipython")
  (python-shell-interpreter-args "-i --simple-prompt")
  (python-shell-enable-font-lock nil)
  :hook
  ((python-mode . dy-python-setup)
   ;; (python-mode . eglot-ensure)
   (python-mode . (lambda ()(ggtags-mode 1)))
   (python-mode . (lambda()
    (keymap-set evil-normal-state-local-map "<SPC> m d" 'dy-python-create-docstring)
    (keymap-set evil-visual-state-local-map "<SPC> m a" 'dy-python-dict-kwargs-toogle)
    (keymap-set evil-normal-state-local-map "<SPC> m i" 'dy-python-add-noqa)
    (keymap-set evil-normal-state-local-map "<SPC> m t" 'dy-python-add-type-ignore)
    (keymap-set evil-normal-state-local-map "<SPC> m s" 'dy-py-split-string)
    (keymap-set evil-normal-state-local-map "<SPC> =" 'dy-format-python-buffer)
    (keymap-set evil-normal-state-local-map "<SPC> m R" 'run-python)
    (keymap-set evil-visual-state-local-map "<SPC> m r" 'python-shell-send-region)
    (keymap-set evil-normal-state-local-map "<SPC> m b" 'python-shell-send-buffer))))

  :config
  (defun dy-python-setup ()
    (setq column-enforce-column 79)
    (setq fill-column 79))

  ;; Custom functions
  ;; TODO if noqa exist - extend it

  (defun dy-python-add-noqa()
    "Add noqa for error string"
    (interactive)
    (save-excursion
      (let* (
             (messages (delq nil (seq-map  #'flycheck-error-id
                                           (flycheck-overlay-errors-at (point)))))
             (error-string (string-join (mapcar 'string-trim messages) ","))
             (noqa-mes (format "  # NOQA:%s" error-string)))
        (move-end-of-line nil)
        (insert noqa-mes))))

  (defun dy-python-add-type-ignore()
    "Add mypy ingore" 
    (interactive)
    (save-excursion
      (move-end-of-line nil)
      (insert "  # type: ignore")))

  (defun dy-python-arg-params(arg-string)
    "Get python argument params from argument string (name, type, default)."
    (let* (
           (arg-value (split-string arg-string "[[:blank:]]*=[[:blank:]]*" t))
           (name-type-string (car arg-value))
           (name-type (split-string name-type-string "[[:blank:]]*:[[:blank:]]*" t))
           (name (car name-type))
           (type (nth 1 name-type))
           (default-value (nth 1 arg-value))
           )
      (list name type default-value)))

  (defun dy-python-split-args (arg-string)
    "Split a python argument string into ((name, type, default)..) tuples"
    (let* (
           (args (split-string arg-string "[[:blank:]]*,[[:blank:]]*" t))
           (args (seq-filter (lambda (x) (not (string-blank-p x))) args))
           (args (mapcar 'string-trim args))
           (arg-values (mapcar 'dy-python-arg-params args))
           )
      arg-values))


  (defun dy-python-args-to-docstring (args-string identation)
    "return docstring format for the python arguments in yas-text"
    (let* (
           (args (dy-python-split-args args-string))
           (args (if (string= (nth 0 (car args)) "self")
                     (cdr args)
                   args))
           (ident (make-string identation ?\s))
           (format-arg (lambda (arg)
                         (concat
                          ident
                          ":param "
                          (nth 0 arg)
                          ": " (nth 0 arg)
                          (if (nth 2 arg) (concat ", default=" (nth 2 arg)))
                          (if (nth 1 arg)
                              (concat
                               "\n"
                               ident
                               ":type "
                               (nth 0 arg)
                               ": "
                               (nth 1 arg)
                               )))))
           (formatted-params (mapconcat format-arg args "\n")))
      (unless (string= formatted-params "")
        (mapconcat 'identity
                   (list  formatted-params)
                   "\n"))))

  (defun dy-python-return-to-docstring (return-string identation)
    "return docstring format for the python return type"
    (let* (
           (return-type (car (split-string return-string "[[:blank:]]*->[[:blank:]]*" t)))
           (ident (make-string identation ?\s))
           (formated-return (format "%s:rtype: %s" ident return-type)))
      (unless (string= return-type "nil") formated-return)))


  (add-hook 'dy-python-mode-hook
            (lambda () (set (make-local-variable 'yas-indent-line) 'fixed)))


  (defun dy--python-add-docstring-to-function ($fname $fargs-string $docstring-shift)
    "Add docstring to function."
    (let ($fargs $docstring $docstring-header $docstring-args)
      (setq $docstring-header
            (dy-capitalize-first-char (replace-regexp-in-string (regexp-quote "_") " " $fname)))

      (setq $fargs (dy-python-split-args $fargs-string))
      (search-forward  ":")
      (insert "\n")
      (insert $docstring-shift)
      (setq $docstring-header (format "\"\"\"%s." $docstring-header))
      (insert $docstring-header)
      (setq $fargs
            (seq-filter (lambda (arg)
                          (let ((var-name (car arg)))
                            (and
                             (not (string= "self" var-name))
                             (not (string= "*" var-name))
                             )))
                        $fargs))
      (message "%s" $fargs)
      (setq $docstring-args
            (mapcar
             (lambda (arg)
               (format ":param %s: %s"
                       (car arg)
                       (replace-regexp-in-string (regexp-quote "_") " " (car arg))))
             $fargs))
      (when $docstring-args
        (insert "\n")
        (dolist (arg $docstring-args)
          (insert "\n")
          (insert $docstring-shift)
          (insert arg))
        (insert "\n")
        (insert $docstring-shift)
        )
      (insert "\"\"\"")
      ))


  (defun dy--python-add-docstring-to-class ($classname $docstring-shift)
    "Add docstring to class."
    (let ($classdocstring (case-fold-search nil))
      (message "%s" $classname)
      (setq $classdocstring (replace-regexp-in-string "\\([A-Z]\\)" " \\1" $classname))
      (setq $classdocstring (string-trim $classdocstring))
      (setq $classdocstring (downcase $classdocstring))
      (setq $classdocstring (dy-capitalize-first-char $classdocstring))
      (search-forward  ":")
      (insert "\n")
      (insert $docstring-shift)
      (insert "\"\"\"")
      (insert $classdocstring)
      (insert ".\"\"\"")
      ))

  (defun dy-python-create-docstring ()
    "return docstring format for the python return type"
    (interactive)
    (python-nav-beginning-of-defun 1)
                                        ; jump to first now-whitespace symbol
    (back-to-indentation)
    (let* (
	   ($block-type (thing-at-point 'word))
	   ($block-start (current-column))
	   ($docstring-shift (make-string (+ 4 $block-start) 32))
	   )
      (cond
       ((string= $block-type "class")
	(let ($classname)
	  (re-search-forward
	   "[ \t]*class[ \t]*\\([a-zA-Z0-9_]+\\)" nil t)
	  (setq $classname (buffer-substring-no-properties (match-beginning 1) (match-end 1)))
	  (dy--python-add-docstring-to-class $classname $docstring-shift)
	  ))
       ((string= $block-type "async")
	(let ($fname $fargs-string $fargs $docstring $docstring-header $docstring-args)
	  (re-search-forward
	   "[ \t]*async[ \t]*def[ \t]*\\([a-zA-Z0-9_]+\\)[ \t]*\(\\([a-zA-Z0-9_\, \t\:=\n\*]*\\)\)" nil t)
	  (setq $fname (buffer-substring-no-properties (match-beginning 1) (match-end 1)))
	  (setq $fargs-string (buffer-substring-no-properties (match-beginning 2) (match-end 2)))
	  (dy--python-add-docstring-to-function $fname $fargs-string $docstring-shift)))
       ((string= $block-type "def")
	(let ($fname $fargs-string $fargs $docstring $docstring-header $docstring-args)
	  (re-search-forward
	   "[ \t]*def[ \t]*\\([a-zA-Z0-9_]+\\)[ \t]*\(\\([a-zA-Z0-9_\, \t\:=\n\*]*\\)\)" nil t)
	  (setq $fname (buffer-substring-no-properties (match-beginning 1) (match-end 1)))
	  (setq $fargs-string (buffer-substring-no-properties (match-beginning 2) (match-end 2)))
	  (dy--python-add-docstring-to-function $fname $fargs-string $docstring-shift))))))

  (defun dy-python-kwargs-to-dict ($start $end)
    "Convert kwargs arguments to dict.
     a=1, b=2 -> 'a': 1, 'b': 2
    "
    (interactive "r")
    (save-restriction
      (narrow-to-region $start $end)
      (goto-char (point-min))
      (replace-regexp "\\([_0-9a-zA-Z]+\\)\s*=\s*" "\"\\1\": ")))

  (defun dy-python-dict-to-kwargs ($start $end)
    "Convert dict arguments to kwargs.
     'a': 1, 'b': 2 -> a=1, b=2
    "
    (interactive "r")
    (save-restriction
      (narrow-to-region $start $end)
      (goto-char (point-min))
      (replace-regexp "\"\\([_0-9a-zA-Z]+\\)\"\s*:\s*" "\\1=")))

  (defun dy-python-dict-kwargs-toogle ($start $end)
    "Convert toogle dict kwargs args."
    (interactive "r")
    (if (seq-contains (buffer-substring $start $end) ?=)
        (dy-python-kwargs-to-dict $start $end)
      (dy-python-dict-to-kwargs $start $end)))

  (defun dy-py-split-string (&optional comma line-length)
    "Split string to multiple."
    (interactive)
    (unless comma (setq comma "'"))
    (unless line-length (setq line-length 70))
    (let (start (string-ended nil))
      (save-excursion
        (search-backward comma)
        (setq start (point))
        (insert "(\n")
        (indent-according-to-mode)
        (goto-char (+ 1(point)))
        (while (not string-ended)
  	  (re-search-forward (format "[[:space:]%s]" comma))
  	  (if (equal (buffer-substring-no-properties (match-beginning 0) (match-end 0)) " ")
  	      (if (>= (current-column) line-length)
  		  (progn
  		    (insert (format "%s\n%s" comma comma))
  		    (indent-according-to-mode))
  	        )
  	    (setq string-ended 't)
  	    )
          )
        (insert "\n)")
        (indent-according-to-mode))))

  (defun dy-format-python-buffer()
    (interactive)
    (cond ((executable-find "ruff") (ruff-format-buffer) (ruff-sort-buffer))
          ((executable-find "black")
           (progn
             (blacken-buffer)
             (if (executable-find "isort") (py-isort-buffer)))))))

;; Virtualenv
(use-package pyvenv
  :ensure t
  :after python
  :config
  (defun pyvenv-workon-local (&optional venv-dir-name)
    "Activate local environment"
    (interactive)
    (unless venv-dir-name (setq venv-dir-name ".venv"))
    (let ((activate-path (format "%s%s" (project-root (project-current)) venv-dir-name)))
      (pyvenv-activate activate-path)))

  (defun pipenvenv-old ()
    (interactive)
    (setenv "WORKON_HOME" "/home/dyens/.virtualenvs"))

  (defun pipenvenv ()
    (interactive)
    (setenv "WORKON_HOME" "/home/dyens/.local/share/virtualenvs"))

  (defun poetryenv ()
    (interactive)
    (setenv "WORKON_HOME" "/home/dyens/.cache/pypoetry/virtualenvs/"))

  ;; default env
  (poetryenv))

;; Py-isrot
(use-package py-isort
  :ensure t
  :commands (py-isort-buffer)
  :hook
  ((python-mode . (lambda()
   (keymap-set evil-normal-state-local-map "<SPC> i" 'py-isort-buffer)))))

;; Pytest
(use-package pytest
  :ensure t
  :after python
  :hook
  ((python-mode . (lambda()
   (keymap-set evil-normal-state-local-map "<SPC> t" 'dy-pytest-one)
   (keymap-set evil-normal-state-local-map "<SPC> T a" 'dy-pytest-all)
   (keymap-set evil-normal-state-local-map "<SPC> T b" 'dy-pytest-module)
   (keymap-set evil-normal-state-local-map "<SPC> T p" 'pytest-pdb-one)
   (keymap-set evil-normal-state-local-map "<SPC> T T" 'pytest-again))))
  :custom
  (pytest-project-root-files '("setup.py" ".hg" ".git"))
  :config
  ;; Custom variables
  (defcustom dy-pytest-arguments "--disable-warnings -x --ff"
    "Pytest run arguments.")

  (defun dy-pytest-one()
    (interactive)
    (pytest-one  dy-pytest-arguments))

  (defun dy-pytest-update-snapshot-one()
    (interactive)
    (let ((dy-pytest-arguments "--snapshot-update"))
      (pytest-one  dy-pytest-arguments)))

  (defun dy-pytest-update-snapshot-all()
    (interactive)
    (let ((dy-pytest-arguments "--snapshot-update"))
      (pytest-all  dy-pytest-arguments)))

  (defun dy-pytest-module()
    (interactive)
    (pytest-module  dy-pytest-arguments)
    )

  (defun dy-pytest-all()
    (interactive)
    (pytest-all  dy-pytest-arguments)))

;; Pyenv mode 
(use-package pyenv-mode
  :ensure t)

;; (use-package elpy
;;   :ensure t
;;   :init
;;   (elpy-enable)
;;   :config
;;   (when (load "flycheck" t t)
;;     (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
;;     (add-hook 'elpy-mode-hook 'flycheck-mode)))

(provide 'dy-python)
