
(setq user-full-name "Alexander Kapustin")
(setq user-mail-address "dyens@mail.ru")

(fset 'yes-or-no-p 'y-or-n-p)

(setq inhibit-startup-screen t)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(load-theme 'gruber-darker t)

(global-prettify-symbols-mode 1)

(set-face-attribute 'default nil
                    :family "Source Code Pro"
                    :height 130
                    :weight 'normal
                    :width 'normal)

(require 'evil)
(evil-mode 1)

(setq evil-want-C-u-scroll t)

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

(require 'elpy)
(elpy-enable)

(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt")

(require 'elpy)
 (eval-after-load 'python 
                  '(define-key evil-normal-state-map (kbd "<SPC> r") 'elpy-rgrep-symbol))

(require 'elpy)
 (eval-after-load 'python 
                  '(define-key evil-normal-state-map (kbd "g d") 'elpy-goto-definition))

(require 'elpy)
 (eval-after-load 'python 
                  '(define-key evil-normal-state-map (kbd "<SPC> m R") 'elpy-shell-switch-to-shell))
 (eval-after-load 'python 
                  '(define-key evil-normal-state-map (kbd "<SPC> m b") 'elpy-shell-send-region-or-buffer))
 (eval-after-load 'python 
                  '(define-key evil-visual-state-map (kbd "<SPC> m r") 'elpy-shell-send-region-or-buffer))

(require 'evil)
(define-key evil-normal-state-map (kbd "<SPC> b") 'ivy-switch-buffer)
(define-key evil-normal-state-map (kbd "<SPC> f") 'counsel-find-file)
(define-key evil-normal-state-map (kbd "<SPC> s") 'swiper)

(define-key ivy-minibuffer-map (kbd "<escape>") 'minibuffer-keyboard-quit)
; (define-key swiper-map (kbd "<escape>") 'minibuffer-keyboard-quit)
