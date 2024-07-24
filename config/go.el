;; GO
(use-package go-mode
  :ensure t
  :after evil
  :custom
  (gofmt-command "goimports")
  :hook
  ((go-mode . eglot-ensure)
   (go-mode . (lambda()
     (keymap-set evil-normal-state-local-map "<SPC> t" 'go-test-current-test)
     (keymap-set evil-normal-state-local-map "<SPC> =" 'eglot-format-buffer)))))

(use-package gotest
  :ensure t
  :after go-mode
  :config)

