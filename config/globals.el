(setq init-dir "~/.emacs.d")

;; Set custom set variables path
(setq custom-file "~/.emacs.d/custom-set-vars.el")


;; Deffered compilation
;; https://masteringemacs.org/article/speed-up-emacs-libjansson-native-elisp-compilation
(setq comp-deferred-compilation t)

;; Set credentials
(setq user-full-name "Alexander Kapustin")
(setq user-mail-address "dyens@mail.ru")

;; Disable beep
(setq ring-bell-function 'ignore)

;; Be sure to just ask for y/n instead of yes/no.
(fset 'yes-or-no-p 'y-or-n-p)

;; Disable startup secreen.
(setq inhibit-startup-screen t)

;; Scrolling
(setq mouse-wheel-scroll-amount '(1)    ; scroll gentle
      mouse-wheel-progressive-speed nil ; don't accelerate
      scroll-conservatively 101         ; don't jump to the middle of screen
      hscroll-margin 1                  ; don't you scroll that early!
      hscroll-step 1                    ; but scroll just a bit
      scroll-preserve-screen-position t) ; try to keep cursor in its position

;; Search for non ascii characters
;; https://endlessparentheses.com/new-in-emacs-25-1-easily-search-non-ascii-characters.html
(setq search-default-mode #'char-fold-to-regexp)

;; Warning level
;; (setq warning-minimum-level :emergency)

;; For LSP performance
(setq read-process-output-max (* 1024 1024))

;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)

;; Global keybidings
(keymap-global-set "C-x C-p" 'eval-print-last-sexp)

;; Backup
;; This is one of the things people usually want to change right away. By
;; default, Emacs saves backup files in the current directory. These are
;; the files ending in ~ that are cluttering up your directory lists. The
;; following code stashes them all in ~/.emacs.d/backups, where I can
;; find them with C-x C-f (find-file) if I really need to.
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;; Disk space is cheap. Save lots. 
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;; History
;; This is one of the things people usually want to change right away. By
;; default, Emacs saves backup files in the current directory. These are
;; the files ending in ~ that are cluttering up your directory lists. The
;; following code stashes them all in ~/.emacs.d/backups, where I can
;; find them with C-x C-f (find-file) if I really need to.
(setq savehist-file "~/.emacs.d/savehist")
(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring))

;; World time
(custom-set-variables
 '(zoneinfo-style-world-list
   '(("Etc/UTC" "ITC")
     ("Europe/Moscow" "Moscow")
     ("Asia/Irkutsk" "Irkutsk")
     ("America/New_York" "New York"))))

(setq shell-file-name "zsh")

;; Buffers position
(add-to-list 'display-buffer-alist
             (cons "\\`\\*compilation\\*\\'"
                   (cons 'display-buffer-reuse-window
                         '((reusable-frames . visible)
                           (inhibit-switch-frame . nil)))))

;; ggtags
(use-package ggtags
  :ensure nil
  :custom
  (ggtags-extra-args '("--accept-dotfiles")))
