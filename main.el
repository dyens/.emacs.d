
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
                    :family "FiraCode"
                    :height 130
                    :weight 'regular
                    :width 'normal)

(require 'evil)
(evil-mode 1)

(require 'evil)
(define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
(define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)

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

(require 'elpy)
(elpy-enable)

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

(require 'elpy)
(eval-after-load 'python 
                 '(elpy-set-test-runner 'elpy-test-pytest-runner))
(eval-after-load 'python 
                 '(define-key evil-normal-state-map (kbd "<SPC> t") 'elpy-test))

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
(define-key evil-normal-state-map (kbd "<SPC> l 0") 'eyebrowse-switch-to-window-config-0)
(define-key evil-normal-state-map (kbd "<SPC> l 1") 'eyebrowse-switch-to-window-config-1)
(define-key evil-normal-state-map (kbd "<SPC> l 2") 'eyebrowse-switch-to-window-config-2)
(define-key evil-normal-state-map (kbd "<SPC> l 3") 'eyebrowse-switch-to-window-config-3)
(define-key evil-normal-state-map (kbd "<SPC> l 4") 'eyebrowse-switch-to-window-config-4)
(define-key evil-normal-state-map (kbd "<SPC> l 5") 'eyebrowse-switch-to-window-config-5)
(define-key evil-normal-state-map (kbd "<SPC> l 6") 'eyebrowse-switch-to-window-config-6)
(define-key evil-normal-state-map (kbd "<SPC> g") 'magit-status)

(define-key ivy-minibuffer-map (kbd "<escape>") 'minibuffer-keyboard-quit)
; (define-key swiper-map (kbd "<escape>") 'minibuffer-keyboard-quit)
