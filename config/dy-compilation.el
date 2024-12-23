(use-package compile
  :ensure nil
  :hook
  ;; If in compilation buffer there are many lines it start to be a very slow
  (compilation-filter . comint-truncate-buffer)
  :custom
  (comint-buffer-maximum-size 2000)
  ;; Scroll to the first error in compilation buffer
  (compilation-scroll-output 'first-error)
  :config
  ;; Notifications
  (defcustom dy-notify-after-compilation nil "Notifcation after compilation" :type 'hook :options '(t nil) :group 'dy-settings)
  (custom-set-variables '(dy-notify-after-compilation t))

  (require 'dy-notify)
  (defun dy-local-notify-compilation-finish (buffer status)
    "Notify compilation finish."
    (if dy-notify-after-compilation
        (dy-notify "Compilation finished in Emacs" status)))

  (setq compilation-finish-functions
        (append compilation-finish-functions
            '(dy-local-notify-compilation-finish))))

(provide 'dy-compilation)
