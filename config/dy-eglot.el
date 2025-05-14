;; -*- lexical-binding: t; -*-
;; need install manually
;; (package-vc-install "https://github.com/jdtsmith/eglot-booster")))
;; and compile and move to /usr/local/bin: https://github.com/blahgeek/emacs-lsp-booster
(use-package eglot-booster
         :ensure nil
         :autoload eglot-booster-mode
         :init (eglot-booster-mode 1))

(provide 'dy-eglot)
