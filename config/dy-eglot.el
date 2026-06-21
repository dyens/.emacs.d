;; -*- lexical-binding: t; -*-

;; eglot-booster (optional speedup):
;;   (package-vc-install "https://github.com/jdtsmith/eglot-booster")
;;   https://github.com/blahgeek/emacs-lsp-booster (compile and put in /usr/local/bin)
;; (use-package eglot-booster
;;   :ensure nil
;;   :init (eglot-booster-mode 1))

;;; Python LSP server selection

(defun dy-eglot-python-lsp-cmd (&optional _interactive _project)
  "Prompt to select a Python LSP server and return its command."
  (let ((servers '(("pyright" . ("pyright-langserver" "--stdio"))
                   ("ty"      . ("ty" "server"))
                   ("ruff"    . ("ruff" "server")))))
    (cdr (assoc-string (completing-read "Python LSP: " (mapcar #'car servers) nil t)
                       servers))))

;;; Python venv configuration for pyright
;;
;; On Fedora, Python venvs install packages under lib64/ instead of lib/,
;; which pyright does not detect automatically. We collect all site-packages
;; directories from both lib/ and lib64/ and pass them via extraPaths.
;; eglot-workspace-configuration must be a buffer-local plist (not a function)
;; to be reliably sent to the server.

(defun dy-eglot--venv-site-packages (venv)
  "Return a vector of site-packages paths found in VENV (checks lib/ and lib64/)."
  (let (paths)
    (dolist (lib (list (expand-file-name "lib" venv)
                       (expand-file-name "lib64" venv)))
      (when (file-directory-p lib)
        (dolist (pydir (directory-files lib t "^python"))
          (let ((sp (expand-file-name "site-packages" pydir)))
            (when (file-directory-p sp)
              (push sp paths))))))
    (vconcat (nreverse paths))))

(defun dy-eglot--python-setup ()
  "Configure eglot for Python using the active virtualenv."
  (when-let ((venv (getenv "VIRTUAL_ENV")))
    (let ((python (expand-file-name "bin/python" venv)))
      (setq-local eglot-initialization-options
                  `(:pythonPath ,python))
      (setq-local eglot-workspace-configuration
                  `(:python (:pythonPath ,python
                             :analysis (:extraPaths ,(dy-eglot--venv-site-packages venv))))))))

(add-hook 'python-mode-hook    #'dy-eglot--python-setup)
(add-hook 'python-ts-mode-hook #'dy-eglot--python-setup)

;;; eglot setup

(use-package eglot
  :ensure nil
  :config
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode) . dy-eglot-python-lsp-cmd)))

(provide 'dy-eglot)
