;; Make startup faster
(defvar file-name-handler-alist-old file-name-handler-alist)
(setq package-enable-at-startup nil
      file-name-handler-alist nil
      message-log-max 16384
      gc-cons-threshold 402653184
      gc-cons-percentage 0.6
      auto-window-vscroll nil
      package--init-file-ensured t)

(add-hook 'after-init-hook
          `(lambda ()
             (setq file-name-handler-alist file-name-handler-alist-old
                   gc-cons-threshold 800000
                   gc-cons-percentage 0.1)) t)


(package-initialize) 

(require 'org)
(require 'ob-tangle)


(setq init-dir (file-name-directory (or load-file-name (buffer-file-name))))

(org-babel-load-file (expand-file-name "main.org" init-dir))
