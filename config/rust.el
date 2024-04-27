(use-package rust-mode
  :ensure t
  :custom
  (rust-format-on-save t "Format rust code on save")
  ;; (company-tooltip-align-annotations t "Company annotations")
  :mode ("\\rs\\'" . rust-mode)
  :config
  (add-hook 'rust-mode-hook 'eglot-ensure)
  ;; (add-hook 'rust-mode-hook #'lsp)
  ;; (keymap-set rust-mode-map "TAB" #'company-indent-or-complete-common)
  )

;; rustic
(use-package rustic
  :ensure t)

;; Test at point
(defun rust-test-buffer ()
"Test buffer using `cargo test`"
(interactive)
(let* (
       (relative-file (file-relative-name buffer-file-name (project-root (project-current))))
       (splitted-path (split-string relative-file "/"))
       (module-path-with-rs (string-join (cdr splitted-path) "::"))
       (module-path (substring module-path-with-rs 0 (- (length module-path-with-rs) 3))))
  (compile (format "%s test %s" rust-cargo-bin module-path))))

;; Yes, i know. Its bullshit. It return first fn (name).
;; But for testing in general cases its ok.
(defun rust-fname-at-point ()
"Test buffer using `cargo test`"
(interactive)
(save-excursion
    (re-search-backward
    "^[ \t]\\{0,4\\}\\(fn\\)[ \t]+\\([a-zA-Z0-9_]+\\)" nil t)
    (buffer-substring-no-properties (match-beginning 2) (match-end 2))))

(defun rust-test-at-point ()
"Test buffer using `cargo test`"
(interactive)
(let* (
       (relative-file (file-relative-name buffer-file-name (project-root (project-current))))
       (splitted-path (split-string relative-file "/"))
       (module-path-with-rs (string-join (cdr splitted-path) "::"))
       (module-path (substring module-path-with-rs 0 (- (length module-path-with-rs) 3)))
       (fname (rust-fname-at-point))
       (test-module-name "tests"))
  (compile (format "%s test %s::%s::%s" rust-cargo-bin module-path test-module-name fname))
  ))

;; Bindings
(add-hook
 'rust-mode-hook
 (lambda()
   (keymap-set evil-normal-state-local-map "<SPC> m c" 'rust-run-clippy)
   (keymap-set evil-normal-state-local-map "<SPC> m C" 'rust-compile)
   (keymap-set evil-normal-state-local-map "<SPC> m r" 'rust-run)
   (keymap-set evil-normal-state-local-map "<SPC> T a" 'rust-test)
   (keymap-set evil-normal-state-local-map "<SPC> T b" 'rust-test-buffer)
   (keymap-set evil-normal-state-local-map "<SPC> =" 'lsp-format-buffer)
   (keymap-set evil-normal-state-local-map "<SPC> t" 'rust-test-at-point)))

