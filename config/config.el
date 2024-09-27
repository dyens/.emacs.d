;; Globals
(load "~/.emacs.d/config/globals.el")

;; GUI
(load "~/.emacs.d/config/gui.el")

;; Use package
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

;; Packages
(load "~/.emacs.d/config/packages.el")

;; Python
(load "~/.emacs.d/config/python.el")

;; Org-mypy
(load "~/.emacs.d/config/org-mypy.el")

;; Org
(load "~/.emacs.d/config/org.el")

;; Rust
(load "~/.emacs.d/config/rust.el")

;; Mail
(load "~/.emacs.d/config/mail.el")

;; Dyens
(load "~/.emacs.d/config/dyens.el")

;; Compilation
(load "~/.emacs.d/config/compilation.el")

;; Cpp
(load "~/.emacs.d/config/cpp.el")

;; Go
(load "~/.emacs.d/config/go.el")

;; Straight
(load "~/.emacs.d/config/straight.el")

;; GUI
(load "~/.emacs.d/config/gui.el")

;; Server
;; (load "~/.emacs.d/config/server.el")

;; (use-package detached
;;   :ensure t
;;   :init
;;   (detached-init)
;;   :bind (;; Replace `async-shell-command' with `detached-shell-command'
;;          ([remap async-shell-command] . detached-shell-command)
;;          ;; Replace `compile' with `detached-compile'
;;          ([remap compile] . detached-compile)
;;          ([remap recompile] . detached-compile-recompile)
;;          ;; Replace built in completion of sessions with `consult'
;;          ([remap detached-open-session] . detached-consult-session))
;;   :custom ((detached-show-output-on-attach t)
;;            (detached-terminal-data-command system-type)))

;; (global-set-key (kbd "C-c d") detached-action-map)

