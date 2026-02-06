;; -*- lexical-binding: t; -*-
;; Themes
(defun dy-modus-theme () 
  (setq modus-themes-italic-constructs t
      modus-themes-region '(bg-only)
      modus-themes-bold-constructs t
      modus-themes-syntax '( faint yellow-comments green-strings alt-syntax)
      modus-themes-paren-match '(bold intense underline)
      modus-themes-mode-line '(accented borderless))
   (load-theme 'modus-operandi t))

(defun dy-light-theme ()
    (scroll-bar-mode 0)
    (fringe-mode 0)
    (set-face-attribute 'mode-line nil :box nil)
    (set-face-attribute 'mode-line-inactive nil :box nil)
    (set-face-attribute 'mode-line nil :background "#c6edf9")
    (set-face-attribute 'mode-line-inactive nil :background "#FAFAFA")
    (set-face-background 'vertical-border "gray")
    (set-face-foreground 'vertical-border (face-background 'vertical-border)))

;; (dy-light-theme)

(use-package ef-themes
  :ensure t
)

;; (load-theme 'ef-symbiosis t)
;; (load-theme 'ef-dream t)
(load-theme 'ef-reverie t)

;; Pretty symbols
(global-prettify-symbols-mode 1)

;; Font
(set-face-attribute 'default nil
                    :family "Iosevka Fixed SS04"
                    :height 113
                    :weight 'bold)

;; Display line numbers
(customize-set-variable 'display-line-numbers-type 'relative)
(global-display-line-numbers-mode)

;; Display fill column indicator
(global-display-fill-column-indicator-mode)
(setq fill-column 80)


;; Disable bars
;; (menu-bar-mode -1)
;; (tool-bar-mode -1)
;; (scroll-bar-mode -1)
;; (display-time-mode -1)

;; Fix gaps in DWM
(setq frame-resize-pixelwise t)

;; Paren mode
(show-paren-mode)

;; Mode line 
(defvar-local dy-modeline-major-mode
    '(:eval
      (list
       (propertize (format "%s " (symbol-name major-mode)) 'face 'shadow)))
  "Mode line construct to display the major mode.")

(put 'dy-modeline-major-mode 'risky-local-variable t)

(defun dy-buffer-name ()
  "Buffer name with lock if readonly."
  (let ((name (buffer-name)))
  (if buffer-read-only
          (format "%s%s" (char-to-string #xE0A2) name)
        name)
  ))

(defvar-local dy-modeline-buffer-name
    '(:eval
      (list
       (propertize (format "%s " (dy-buffer-name)) 'face 'bold)))
  "Mode line construct to display buffer name.")

(put 'dy-modeline-buffer-name 'risky-local-variable t)


(defun dy-vc-branch-name ()
  "Return VC branch name."
  (let* ((file (buffer-file-name))
         (backend (vc-backend file)))
  (when-let* ((backend backend) ; backend should not be nil
             (rev (vc-working-revision file backend))
             (branch (or (vc-git--symbolic-ref file)
                         (substring rev 0 7))))
    branch)))

(defvar-local dy-modeline-branch-name
    '(:eval
      (list
       (propertize (format "⮑%s " (or (dy-vc-branch-name) "E")) 'face 'bold)))
  "Mode line construct to display buffer name.")

(put 'dy-modeline-branch-name 'risky-local-variable t)



(setq-default mode-line-format
              '("%e"
                dy-modeline-buffer-name
                dy-modeline-major-mode
                dy-modeline-branch-name
                mode-line-misc-info mode-line-end-spaces))

(provide 'dy-gui)
