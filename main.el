
(setq user-full-name "Alexander Kapustin")
(setq user-mail-address "dyens@mail.ru")

(fset 'yes-or-no-p 'y-or-n-p)

(setq inhibit-startup-screen t)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

(setq savehist-file "~/.emacs.d/savehist")
(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(display-time-mode 1)

(load-theme 'gruber-darker t)

(global-prettify-symbols-mode 1)

(set-face-attribute 'default nil
                    :family "Source Code Pro"
                    :height 100
                    :weight 'normal
                    :width 'normal)

(require 'evil)
(evil-mode 1)

(require 'ivy)
(ivy-mode 1)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

(global-set-key (kbd "M-x") 'counsel-M-x)

(require 'yasnippet)
(setq yas-snippet-dirs
  '(
     "~/.emacs.d/snippets"                 ;; personal snippets
 ))

(yas-global-mode 1)

(require 'winum)
(winum-mode)

(require 'eyebrowse)
(eyebrowse-mode)

(require 'magit)

(require 'evil-magit)

(require 'yapfify)
(eval-after-load 'python 
                 '(define-key evil-normal-state-map (kbd "<SPC> =") 'yapfify-buffer))

(require 'py-isort)
(eval-after-load 'python 
                 '(define-key evil-normal-state-map (kbd "<SPC> i") 'py-isort-buffer))

(require 'elpy)
(elpy-enable)

(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt")

(require 'elpy)
(eval-after-load 'python 
                 '(define-key evil-normal-state-map (kbd "<SPC> r") 'elpy-rgrep-symbol))

(require 'elpy)
(setq elpy-rpc-backend "jedi")

(require 'elpy)
 (eval-after-load 'python 
                  '(define-key evil-normal-state-map (kbd "g d") 'elpy-goto-assignment))

(require 'elpy)
 (eval-after-load 'python 
                  '(define-key evil-normal-state-map (kbd "<SPC> m R") 'elpy-shell-switch-to-shell))
 (eval-after-load 'python 
                  '(define-key evil-normal-state-map (kbd "<SPC> m b") 'elpy-shell-send-region-or-buffer))
 (eval-after-load 'python 
                  '(define-key evil-visual-state-map (kbd "<SPC> m r") 'elpy-shell-send-region-or-buffer))

(defun pipenvenv ()
  (interactive)
  (setenv "WORKON_HOME" "/home/dyens/.local/share/virtualenvs")
    )
(defun poetryenv ()
  (interactive)
  (setenv "WORKON_HOME" "/home/dyens/.cache/pypoetry/virtualenvs/")
  )
;; default env
(poetryenv)

(require 'pytest)
(eval-after-load 'python 
                 '(define-key evil-normal-state-map (kbd "<SPC> t t") 'pytest-one))

(eval-after-load 'python 
                 '(define-key evil-normal-state-map (kbd "<SPC> t a") 'pytest-all))

(eval-after-load 'python 
                 '(define-key evil-normal-state-map (kbd "<SPC> t b") 'pytest-pdb-one))

(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region compilation-filter-start (point))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

(require 'restclient)
(add-to-list 'auto-mode-alist '("\\.http\\'" . restclient-mode))

(require 'projectile)
(projectile-mode +1)
(define-key evil-normal-state-map (kbd "<SPC> p") 'projectile-command-map)
(setq projectile-completion-system 'ivy)

(require 'evil)
(define-key evil-normal-state-map (kbd "<SPC> b") 'ivy-switch-buffer)
(define-key evil-normal-state-map (kbd "<SPC> f") 'counsel-find-file)
(define-key evil-normal-state-map (kbd "<SPC> s") 'swiper)

(define-key evil-normal-state-map (kbd "<SPC> 1") 'winum-select-window-1)
(define-key evil-normal-state-map (kbd "<SPC> 2") 'winum-select-window-2)
(define-key evil-normal-state-map (kbd "<SPC> 3") 'winum-select-window-3)
(define-key evil-normal-state-map (kbd "<SPC> 4") 'winum-select-window-4)
(define-key evil-normal-state-map (kbd "<SPC> 5") 'winum-select-window-5)
(define-key evil-normal-state-map (kbd "<SPC> 6") 'winum-select-window-6)

(define-key compilation-mode-map (kbd "<SPC> 1") 'winum-select-window-1)
(define-key compilation-mode-map (kbd "<SPC> 2") 'winum-select-window-2)
(define-key compilation-mode-map (kbd "<SPC> 3") 'winum-select-window-3)
(define-key compilation-mode-map (kbd "<SPC> 4") 'winum-select-window-4)
(define-key compilation-mode-map (kbd "<SPC> 5") 'winum-select-window-5)
(define-key compilation-mode-map (kbd "<SPC> 6") 'winum-select-window-6)

(define-key evil-normal-state-map (kbd "<SPC> l 0") 'eyebrowse-switch-to-window-config-0)
(define-key evil-normal-state-map (kbd "<SPC> l 1") 'eyebrowse-switch-to-window-config-1)
(define-key evil-normal-state-map (kbd "<SPC> l 2") 'eyebrowse-switch-to-window-config-2)
(define-key evil-normal-state-map (kbd "<SPC> l 3") 'eyebrowse-switch-to-window-config-3)
(define-key evil-normal-state-map (kbd "<SPC> l 4") 'eyebrowse-switch-to-window-config-4)
(define-key evil-normal-state-map (kbd "<SPC> l 5") 'eyebrowse-switch-to-window-config-5)
(define-key evil-normal-state-map (kbd "<SPC> l 6") 'eyebrowse-switch-to-window-config-6)
(define-key evil-normal-state-map (kbd "<SPC> g") 'magit-status)
(define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
(define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)

(define-key ivy-minibuffer-map (kbd "<escape>") 'minibuffer-keyboard-quit)
;; (define-key ido-completion-map (kbd "<escape") 'ido-exit-minibuffer
