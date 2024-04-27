;; String-inflection
(use-package string-inflection
  :ensure t)

;; Perspective
(use-package perspective
  :ensure t
  :config
  (setq persp-suppress-no-prefix-key-warning t)
  (persp-mode))

;;; Super word mode
(superword-mode t)


; Evil mode
(setq evil-want-C-i-jump nil)
;; for work with abc_abc words
(with-eval-after-load 'evil
    (defalias #'forward-evil-word #'forward-evil-symbol)
    ;; make evil-search-word look for symbol rather than word boundaries
    (setq-default evil-symbol-word-search t))

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  ;; Put a cursor to a new window
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  ;; Fix org tab key
  (setq evil-want-C-i-jump nil)
  :config 
  (evil-mode 1)
  ;; With new evil changes and new emacs evil use different undo systemes
  (evil-set-undo-system 'undo-redo)
  (keymap-set evil-normal-state-map "<f5>" #'modus-themes-toggle)

  ;; C-o defined for jump back
  ;; C-i for jump forward

  (keymap-set evil-normal-state-map "C-i" 'evil-jump-forward)
  (keymap-set evil-normal-state-map "<SPC> f" 'find-file)
  (keymap-set evil-normal-state-map "<SPC> b" 'switch-to-buffer)
  (keymap-set evil-normal-state-map "<SPC> I" 'consult-imenu)
  (keymap-set evil-normal-state-map "<SPC> s" 'consult-ripgrep)

  (keymap-set evil-normal-state-map "<SPC> w" 'ace-window)

  (keymap-set evil-normal-state-map "<SPC> g" 'magit-status)
  (keymap-set evil-normal-state-map "<SPC> a a" 'org-agenda)
  (keymap-set evil-normal-state-map "<SPC> a c" 'org-capture)

  (keymap-set evil-normal-state-map "<SPC> c" 'compile)

  (keymap-set evil-normal-state-map "<SPC> #" 'comment-line)
  (keymap-set evil-visual-state-map "<SPC> #" 'comment-line)

  (keymap-set evil-normal-state-map "C-u" 'evil-scroll-up)
  (keymap-set evil-visual-state-map "C-u" 'evil-scroll-up)

  (keymap-set evil-normal-state-map "<SPC> o" 'consult-outline)
  ;; Instead of C-u
  (keymap-set evil-normal-state-map "<SPC> u" 'universal-argument)
  (keymap-set evil-insert-state-map "C-l" 'yas-expand-from-trigger-key)

  (keymap-set evil-normal-state-map "<SPC> l" 'perspective-map)

  ;; Github jump
  (keymap-set evil-normal-state-map "<SPC> m b" 'dy-open-in-github-branch)
  (keymap-set evil-normal-state-map "<SPC> m B" 'dy-open-in-github-rev)

  (keymap-set evil-visual-state-map "<SPC> m b" 'dy-open-in-github-branch)
  (keymap-set evil-visual-state-map "<SPC> m B" 'dy-open-in-github-rev)

  ;; fast function
  (keymap-set evil-normal-state-map "<SPC> ~" 'dy-set-fast-function)
  (keymap-set evil-visual-state-map "<SPC> ~" 'dy-set-fast-function)

  ;; insert pair
  (keymap-set evil-visual-state-map "<SPC> q" 'dy-insert-pair-completion)

  (defun dy-function-not-found ()
    "Function is not find"
    (interactive)
  (error "Fast function is not defined: use dy-set-fast-function"))

  (keymap-set evil-normal-state-map "<SPC> `" 'dy-function-not-found)

  (defun dy-goto-next-error ()
    "Go to next error not depends from fly-* mode."
    (interactive)
    (cond
     ((and (symbolp flymake-mode) (symbol-value flymake-mode)) (flymake-goto-next-error))
     ((and (symbolp flycheck-mode) (symbol-value flycheck-mode)) (flycheck-next-error))
     (t (progn (message "no fly backend") nil))))

  (defun dy-goto-prev-error ()
    "Go to prev error not depends from fly-* mode."
    (interactive)
    (cond
     ((and (symbolp flymake-mode) (symbol-value flymake-mode)) (flymake-goto-prev-error))
     ((and (symbolp flycheck-mode) (symbol-value flycheck-mode)) (flycheck-previous-error))
     (t (progn (message "no fly backend") nil))))

  (keymap-set evil-normal-state-map "<SPC> ." 'dy-goto-next-error)
  (keymap-set evil-normal-state-map "<SPC> ," 'dy-goto-prev-error)

  (keymap-set evil-visual-state-map ">" 'dy-evil-shift-right-visual)
  (keymap-set evil-visual-state-map "<" 'dy-evil-shift-left-visual)
  (defun dy-evil-shift-left-visual ()
    (interactive)
    (evil-shift-left (region-beginning) (region-end))
    (evil-normal-state)
    (evil-visual-restore))
  
  (defun dy-evil-shift-right-visual ()
    (interactive)
    (evil-shift-right (region-beginning) (region-end))
    (evil-normal-state)
    (evil-visual-restore))
  )

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package evil-string-inflection
  :after evil
  :ensure t
)

(use-package evil-escape
  :after evil
  :ensure t
  :config
  (setq-default evil-escape-key-sequence "fd")
  (evil-escape-mode 1))

(use-package evil-multiedit
  :ensure t
  :config
  (require 'evil-multiedit)
  ;; Highlights all matches of the selection in the buffer.
  (keymap-set evil-visual-state-map "R" 'evil-multiedit-match-all)
  
  ;; Match the word under cursor (i.e. make it an edit region). Consecutive presses will
  ;; incrementally add the next unmatched match.
  (keymap-set evil-normal-state-map "M-d" 'evil-multiedit-match-and-next)
  ;; Match selected region.
  (keymap-set evil-visual-state-map "M-d" 'evil-multiedit-match-and-next)
  ;; Insert marker at point
  (keymap-set evil-insert-state-map "M-d" 'evil-multiedit-toggle-marker-here)
   ;; Ex command that allows you to invoke evil-multiedit with a regular expression, e.g.
  (evil-ex-define-cmd "ie[dit]" 'evil-multiedit-ex-match))

;; Vertico
(use-package vertico
:ensure t
:init
(vertico-mode))

;; Orderless
(use-package orderless
  :ensure t
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion emacs22 basic)))))

;; Savehist
(use-package savehist
  :init
  (savehist-mode))

(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; Alternatively try `consult-completing-read-multiple'.
  (defun crm-indicator (args)
    (cons (concat "[CRM] " (car args)) (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)
  (setq enable-recursive-minibuffers t))


;; Marginalia
(use-package marginalia
  :ensure t
  ;; Either bind `marginalia-cycle` globally or only in the minibuffer
  :bind (("M-A" . marginalia-cycle)
         :map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

;; Consult
(use-package consult
:ensure t
:config
(setq consult-preview-key nil)
(setq consult-ripgrep-args "rg --null --line-buffered --color=never --max-columns=1000 --path-separator /   --smart-case --no-heading --with-filename --line-number --search-zip --hidden"))

;; Embark
(use-package embark
:ensure t
:bind
(("C-." . embark-act)
 ("C-h B" . embark-bindings)))

(use-package embark-consult
:after embark
:ensure t)

;; Magit
(use-package magit
  :ensure t
  :commands magit-status
  :config
  (setq magit-display-buffer-function 'magit-display-buffer-traditional)
  ;; (setq magit-display-buffer-function 'magit-display-buffer-fullframe-status-v1)
  (defun dy-git-commit-setup ()
    (let ((current-branch-name (upcase (magit-get-current-branch))))
      (if (string-match-p (regexp-quote "WEBDEV") current-branch-name)
	  (let ((issue-number (format "WEBDEV%s" (cadr (split-string current-branch-name "WEBDEV")))))
	    (insert (format " %s\n\nhttps://zyrl.atlassian.net/browse/%s" issue-number issue-number))
	    (goto-char 0)
	    (evil-insert 0)))

      (if (string-match-p (regexp-quote "VTBCLOUD") current-branch-name)
	  (when (string-match "\\(VTBCLOUD-\[0-9\]+\\)-\\(.*\\)" current-branch-name)
	    (let ((issue-number (match-string 1 current-branch-name))
		  (default-commit-message (dy-capitalize-first-char (replace-regexp-in-string "-" " " (downcase (match-string 2 current-branch-name))))))
	      (insert (format "%s: %s\n" issue-number default-commit-message))
	      (evil-previous-line 1)
	      (evil-end-of-line)
	      (evil-visual-state 1)
              (evil-backward-char (- (length default-commit-message) 1)))))

      (if (string-match-p (regexp-quote "PCS") current-branch-name)
	  (when (string-match "\\(PCS-\[0-9\]+\\)-\\(.*\\)" current-branch-name)
	    (let ((issue-number (match-string 1 current-branch-name))
		  (default-commit-message (dy-capitalize-first-char (replace-regexp-in-string "-" " " (downcase (match-string 2 current-branch-name))))))
	      (insert (format "%s: %s\n" issue-number default-commit-message))
	      (evil-previous-line 1)
	      (evil-end-of-line)
	      (evil-visual-state 1)
              (evil-backward-char (- (length default-commit-message) 1)))))

      (if (string-match-p (regexp-quote "A2205190") current-branch-name)
	  (when (string-match "\\(A2205190-\[0-9\]+\\)-\\(.*\\)" current-branch-name)
	    (let ((issue-number (match-string 1 current-branch-name))
		  (default-commit-message (dy-capitalize-first-char (replace-regexp-in-string "-" " " (downcase (match-string 2 current-branch-name))))))
	      (insert (format "%s: %s\n" issue-number default-commit-message))
	      (evil-previous-line 1)
	      (evil-end-of-line)
	      (evil-visual-state 1)
              (evil-backward-char (- (length default-commit-message) 1)))))))

  (add-hook 'git-commit-setup-hook 'dy-git-commit-setup))


;; Corfu (replace company mode)
(use-package corfu
  :ensure t
  ;; Optional customizations
  :custom
  ;; (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  ;; (corfu-separator ?\s)          ;; Orderless field separator
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect-first nil)    ;; Disable candidate preselection
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  ;; (corfu-echo-documentation nil) ;; Disable documentation in the echo area
  ;; (corfu-scroll-margin 5)        ;; Use scroll margin

  ;; Enable Corfu only for certain modes.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))

  ;; Recommended: Enable Corfu globally.
  ;; This is recommended since Dabbrev can be used globally (M-/).
  ;; See also `corfu-excluded-modes'.
  :init
  (global-corfu-mode))

(use-package emacs
  :init
  ;; TAB cycle if there are only few candidates
  (setq completion-cycle-threshold 3)
  (setq tab-always-indent 'complete))

;; GO
(use-package go-mode
  :ensure t
  :config
  (add-hook 'go-mode-hook 'eglot-ensure)
  (add-hook
   'go-mode-hook
   (lambda()
     (keymap-set evil-normal-state-local-map "<SPC> t" 'go-test-current-test)
     (keymap-set evil-normal-state-local-map "<SPC> =" 'eglot-format-buffer))))

(use-package gotest
  :ensure t
  :config)


;; Ansi-color
(use-package ansi-color
  :ensure t
  :config 
  (defun colorize-compilation-buffer ()
      (ansi-color-apply-on-region compilation-filter-start (point)))
  (add-hook 'compilation-filter-hook 'colorize-compilation-buffer))

;; Restclient
(use-package restclient
:ensure t
:mode ("\\.http\\'" . restclient-mode))

;; project.el
(use-package project
  :config 
  (define-key project-prefix-map (kbd "C") 'dy-run-cmd)
  (keymap-set evil-normal-state-map "<SPC> p" project-prefix-map))

;; Docker
(use-package dockerfile-mode
  :ensure t
  :mode ("\\Dockerfile\\'" . dockerfile-mode))

;; Which-key
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;; Docker-compose
(use-package docker-compose-mode
  :ensure t
  :mode ("\\Dockerfile\\'" . dockerfile-mode))

;; Yasnippet
(use-package yasnippet
  :ensure t
  :custom
  (yas-snippet-dirs  '("~/.emacs.d/snippets") "Set yasnippet dir")
  :config
  (yas-global-mode 1))

;; Plantuml
(use-package plantuml-mode
  :ensure t
  :defer t
  :mode ("\\plantuml\\'" . plantuml-mode)
  :custom
  (plantuml-jar-path "/home/dyens/.emacs.d/plantuml.jar")
  (org-plantuml-jar-path "/home/dyens/.emacs.d/plantuml.jar"))


;; Expand-region
(use-package expand-region
  :ensure t
  :config
  (keymap-set evil-normal-state-map "<SPC> e" 'er/expand-region))

;; Aspell
(setq ispell-program-name "aspell")

;; Google translate
(use-package popup
    :ensure t
 )
(use-package google-translate
    :ensure t
    :custom
    (google-translate-backend-method 'curl)
    :config
    ;; https://github.com/atykhonov/google-translate/issues/52#issuecomment-727920888
    (defun google-translate--search-tkk () "Search TKK." (list 430675 2721866130))
    (keymap-set evil-normal-state-map "<SPC> r r" 'dy-google-translate)
    (keymap-set evil-normal-state-map "<SPC> r R" 'dy-google-translate-reverse)

    (keymap-set evil-visual-state-map "<SPC> r r" 'dy-google-translate)
    (keymap-set evil-visual-state-map "<SPC> r R" 'dy-google-translate-reverse)

    (keymap-set evil-normal-state-map "<SPC> r q" 'google-translate-query-translate)
    (keymap-set evil-normal-state-map "<SPC> r Q" 'google-translate-query-translate-reverse)
    (setq google-translate-default-source-language "en")
    (setq google-translate-default-target-language "ru"))



;; Smerge
(add-hook
'smerge-mode-hook
(lambda()
    (keymap-set evil-normal-state-local-map "<SPC> j" 'smerge-next)
    (keymap-set evil-normal-state-local-map "<SPC> k" 'smerge-prev)
    (keymap-set evil-normal-state-local-map "<SPC> <SPC>" 'smerge-keep-current)
    (keymap-set evil-normal-state-local-map "<SPC> h" 'smerge-keep-other)
    (keymap-set evil-normal-state-local-map "<SPC> l" 'smerge-keep-mine)))

;; SLY
(use-package sly
  :ensure t)

;; Tree sitter
(use-package tree-sitter
  :ensure t
  :config
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs
  :ensure t)

;; Window monocle
(use-package emacs
  :config
  (defvar dy-window-configuration nil
    "Current window configuration.
Intended for use by `dy-window-monocle'.")

  (define-minor-mode dy-window-single-toggle
    "Toggle between multiple windows and single window.
This is the equivalent of maximising a window.  Tiling window
managers such as DWM, BSPWM refer to this state as 'monocle'."
    :lighter " [M]"
    :global nil
    (if (one-window-p)
        (when dy-window-configuration
          (set-window-configuration dy-window-configuration))
      (setq dy-window-configuration (current-window-configuration))
      (delete-other-windows)))

  (keymap-set evil-normal-state-map "<SPC> z" 'dy-window-single-toggle))

;; Lua
(use-package lua-mode
  :ensure t)

;; dired
(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom (
    (dired-listing-switches "-agho --group-directories-first")
    (dired-dwim-target t)
  )
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer)

(setq dired-guess-shell-alist-user
      '(("\\.\\(png\\|jpe?g\\|tiff\\)" "feh" "xdg-open")
        ("\\.\\(mp[34]\\|m4a\\|ogg\\|flac\\|webm\\|mkv\\)" "mplayer" "xdg-open")
		(".*" "xdg-open"))))



(use-package dired-single
  :ensure t)

(use-package dired-open
  :ensure t
  :config
  ;; Doesn't work as expected!
  ;(add-to-list 'dired-open-functions #'dired-open-xdg t)
  (setq dired-open-extensions '(("png" . "feh")
                                ("mp4" . "mplayer"))))




;; Eshell
;; From SystemCrafters
;; https://github.com/daviwil/emacs-from-scratch/blob/bbfbc77b3afab0c14149e07d0ab08d275d4ba575/Emacs.org#terminals
(defun dy-configure-eshell ()
  ;; Save command history when commands are entered
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

  ;; Truncate buffer for performance
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  ;; Bind some useful keys for evil-mode
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-r") 'counsel-esh-history)
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "<home>") 'eshell-bol)
  (evil-normalize-keymaps)

  (setq eshell-history-size         10000
        eshell-buffer-maximum-lines 10000
        eshell-hist-ignoredups t
        eshell-scroll-to-bottom-on-input t))

(use-package eshell-git-prompt
 :ensure t)

(use-package eshell
  :hook (eshell-first-time-mode . dy-configure-eshell)
  :config

  (with-eval-after-load 'esh-opt
    (setq eshell-destroy-buffer-when-process-dies t)
    (setq eshell-visual-commands '("htop" "zsh" "vi")))

  (eshell-git-prompt-use-theme 'powerline))


;; Vterm
(use-package vterm
  :ensure t
  :custom
  (vterm-shell "zsh"))

;; Multi-Vterm
(use-package multi-vterm
  :after vterm
  :ensure t)

;; RG
(use-package rg
  :ensure t)

;; Ace window
(use-package ace-window
  :ensure t)

;; Dape
(use-package dape
  :ensure t
  :config
    (add-to-list 'dape-configs
    `(debugpy-remote-attach-port
    modes (python-mode python-ts-mode)
    host (lambda () (read-string "Host: " "127.0.0.1"))
    port (lambda () (read-number "Port:" 5678))
    :request "attach"
    :type "python"
    :pathMappings [(:localRoot (lambda ()
                                    (read-directory-name "Local source directory: "
                                                        (funcall dape-cwd-fn)))
                    :remoteRoot (lambda ()
                                    (read-string "Remote source directory: ")))]
    :justMyCode nil
    :showReturnValue t)))

;; Nov (epub reading)
(use-package nov
  :ensure t
  :config
   (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))

;; PDF
(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install))

;; Vue
(use-package vue-mode
  :ensure t
  :config
  (setq js-indent-level 2)
  (setq css-indent-offset 2)
)

;; Run command
(use-package run-command
  :ensure t
  :config
    (defun run-command-recipe-example ()
    (list
    ;; Run a simple command
    (list :command-name "say-hello"
            :command-line "echo Hello, World!")))
    (setq run-command-recipes '(run-command-recipe-example)))


;; Terraform
(use-package terraform-mode
  :ensure t
)


;; Type script
(use-package typescript-mode
  :ensure t
  :config
  (setq typescript-indent-level 2)
)

;; Geiser (guile lisp)
(use-package geiser
  :ensure t
)

(use-package geiser-guile
  :ensure t
  :config
  (setq geiser-guile-binary "guile3.0")
  (when (executable-find "guix")
  (add-to-list 'geiser-guile-load-path
              (expand-file-name "~/.config/guix/current/share/guile/site/3.0")
              (expand-file-name "~/.guix-profile/share/guile/3.0/")
  ))
)


;; Prefect margin (center current screen)
(use-package perfect-margin
  :ensure t
  :config
  (perfect-margin-mode 1))

;; Lilypond
(setq load-path (append (list (expand-file-name "lilypond" init-dir)) load-path))
(autoload 'LilyPond-mode "lilypond-mode" "LilyPond Editing Mode" t)
(add-to-list 'auto-mode-alist '("\\.ly$" . LilyPond-mode))
(add-to-list 'auto-mode-alist '("\\.ily$" . LilyPond-mode))
(add-hook 'LilyPond-mode-hook (lambda () (turn-on-font-lock)))

