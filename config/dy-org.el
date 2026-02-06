;; -*- lexical-binding: t; -*-
(use-package org
  :ensure nil
  :after evil
  :custom
  (shell-file-name "bash" "default shell is bash")
  (org-confirm-babel-evaluate nil "Eval withour confirm")
  (org-display-inline-images t)
  (org-redisplay-inline-images t)
  (org-startup-with-inline-images "inlineimages")
  (org-startup-folded t)
  (org-directory "~/org")
  ;; (org-agenda-files (list "agenda.org" "~/.org-jira"))
  (org-agenda-files (list "agenda.org"))
  (org-log-done 'time)
  ;; Remove tab useless source block identation
  (org-src-preserve-indentation nil)
  (org-edit-src-content-indentation 0)
  (org-clock-sound "~/.emacs.d/alarm.wav")
  :hook
  ((org-mode . (lambda()
     (keymap-set evil-normal-state-local-map "<SPC> m f" 'dy-clear-image-cache)))
   (org-babel-after-execute . org-redisplay-inline-images)
   (org-clock-in . dy-clock-in)
   (org-clock-out . dy-clock-out))

  :config
  (defun dy-clear-image-cache ()
    "Clear cached images"
    (interactive)
    (clear-image-cache))

  (setq org-file-apps
        (append '(("drawio" . "drawio %s")) org-file-apps))

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (shell . t)
     (emacs-lisp . t)
     (plantuml . t)
     (C . t)
;;     (mermaid . t)
     (mypy . t)
     (k8s . t)
     (k8s . t)))

  (defcustom dy-pomodoro-timer nil
    "Pomodoro timer for agenda tasks")
  
  (defun dy-clock-in ()
    "Clock in hook."
    (setq dy-pomodoro-timer
          (run-with-timer (* 60 20) (+ (* 60 20) 5) (lambda () (org-notify "Нужно отдохнуть 5 мин" "/home/dyens/.emacs.d/alarm.wav")))))
  
  (defun dy-clock-out ()
    "Clock out hook."
    (cancel-timer dy-pomodoro-timer))

  (add-to-list 'org-src-lang-modes (cons "mypy" 'python))
  (add-to-list 'org-src-lang-modes (cons "k8s" 'yaml))
  (add-to-list 'org-src-lang-modes (cons "dk8s" 'yaml))
)

(use-package org-agenda
  :ensure nil
  :after evil
  :commands (org-agenda)
  :bind
  ((:map evil-normal-state-map
         ("<SPC> a a" . org-agenda))))

(use-package org-capture
  :ensure nil
  :after evil
  :commands (org-capture)
  :custom
  (org-capture-templates
   '(("t" "Tasks" entry (file+headline "~/org/agenda.org" "Tasks")
      "* TODO %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+1d\"))\n" )
     ("m" "Meetings" entry (file+headline "~/org/agenda.org" "Meetings")
      "* Meeting: %(org-insert-time-stamp (org-read-date nil t \"\"))\n%?" )
     ("c" "Captures" entry (file+headline "~/org/agenda.org" "Captures")
      "* Capture %?\n%(org-insert-time-stamp (org-read-date nil t \"\"))\n%c" )))
  :bind
  ((:map evil-normal-state-map
         ("<SPC> a c" . org-capture))))
 

(use-package org-mime
  :ensure t)
 
(use-package org-tempo
  :ensure nil
  :after org
  :config
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python")))
  

;; Org Roam
(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/org_roam")
  (org-roam-completion-everywhere t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         :map org-mode-map
         ("C-M-i"    . completion-at-point))
  :config
  (org-roam-setup))


;; Org mermaid
;; (use-package ob-mermaid
;;   :ensure t
;;   :custom
;;   (ob-mermaid-cli-path "/home/dyens/.nvm/versions/node/v18.7.0/bin/mmdc"))


;; org-krita
(when (not (require 'org-krita nil 'noerror))
  (message "Install org-krita")
  (package-vc-install "https://github.com/lepisma/org-krita"))

(use-package denote
  :ensure t
  :hook (dired-mode . denote-dired-mode)
  :bind
  (("C-c b n" . denote)
   ("C-c b r" . denote-rename-file)
   ("C-c b l" . denote-link)
   ("C-c b b" . denote-backlinks)
   ("C-c b d" . denote-dired)
   ("C-c b g" . denote-grep))
  :config
  (setq denote-directory (expand-file-name "~/dev/blog/pages"))
  (setq denote-known-keywords '("blog" "linux" "emacs" "python" "guile"))
  (denote-rename-buffer-mode 1))


(provide 'dy-org)
