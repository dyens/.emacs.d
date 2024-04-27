;; If in compilation buffer there are many lines it start to be a very slow
(add-hook 'compilation-filter-hook 'comint-truncate-buffer)
(setq comint-buffer-maximum-size 2000)

;; Scroll to the first error in compilation buffer
(setq compilation-scroll-output 'first-error)

;; Notifications
(defcustom dy-notify-after-compilation nil "Notifcation after compilation" :type 'hook :options '(t nil) :group 'dy-settings)
(custom-set-variables '(dy-notify-after-compilation t))

(setq compilation-finish-functions
      (append compilation-finish-functions
          '(dy-local-notify-compilation-finish)))

(defcustom dy-compilation-notify nil
  "Non-nil means automatically frobnicate all buffers."
  :type 'boolean
  :require 'compilation-mode
  :group 'dy-custom)

(defun dy-local-notify-compilation-finish (buffer status)
  "Notify compilation finish."
  (if dy-notify-after-compilation
      (dy-notify "Compilation finished in Emacs" status)))
