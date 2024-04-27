(use-package org
  :ensure t
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
  :config

  (defun dy-clear-image-cache ()
  "Clear cached images"
  (interactive)
  (clear-image-cache))

  (add-hook
   'org-mode-hook
   (lambda()
     (keymap-set evil-normal-state-local-map "<SPC> m f" 'dy-clear-image-cache)
     (setq org-file-apps (append '(
        ("drawio" . "drawio %s")
     ) org-file-apps ))
  ))

  (org-babel-do-load-languages
   'org-babel-load-languages
   '(
     (python . t)
     (shell . t)
     (emacs-lisp . t)
     (plantuml . t)
     (C . t)
     (mermaid . t)
     ))
  ; (use-package ob-translate
  ; :ensure t
  ; :config
  ; (org-babel-do-load-languages
  ;  'org-babel-load-languages
  ;  '((translate . t))))
  (setq org-clock-sound "~/.emacs.d/alarm.wav")
  (add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)
  (setq org-capture-templates
         '(("t" "Tasks" entry (file+headline "~/org/agenda.org" "Tasks")
  	  "* TODO %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+1d\"))\n" )
	   ("m" "Meetings" entry (file+headline "~/org/agenda.org" "Meetings")
  	  "* Meeting: %(org-insert-time-stamp (org-read-date nil t \"+1d\"))\n%?" )
	   ("c" "Captures" entry (file+headline "~/org/agenda.org" "Captures")
  	  "* Capture %?\n%(org-insert-time-stamp (org-read-date nil t \"+1d\"))\n%c" )
	   )
	 )
)

(use-package org-mime
  :ensure t
 )
 
(require 'org-tempo)
(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))

(defcustom dy-pomodoro-timer nil
  "Pomodoro timer for agenda tasks")

(defun dy-clock-in ()
  "Clock in hook."
  (setq dy-pomodoro-timer
        (run-with-timer (* 60 20) (+ (* 60 20) 5) (lambda () (org-notify "Нужно отдохнуть 5 мин" "/home/dyens/.emacs.d/alarm.wav"))))
  )

(defun dy-clock-out ()
  "Clock out hook."
  (cancel-timer dy-pomodoro-timer)
  )

(add-hook 'org-clock-in-hook 'dy-clock-in)
(add-hook 'org-clock-out-hook 'dy-clock-out)


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
(use-package ob-mermaid
  :ensure t
  :config
  (setq ob-mermaid-cli-path "/home/dyens/.nvm/versions/node/v18.7.0/bin/mmdc"))
