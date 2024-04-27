;;   ;; First sudo dnf install maildir-utils
;;   ;; Setup mbrsync
;;   ;; Then init mu
;;   ;; mu init --maildir=~/mailbox --my-address=alexander.kapustin@quantumsoft.ru --my-address=akapustin@ambrahealth.com --my-address=dyens@mail.ru
;;   ;; mu index

;; (defun dy-emails-set-all-as-read ()
;; "Make all emails read."
;; (interactive)
;; (require 'mu4e-contrib)
;; (with-temp-buffer
;;     (mu4e-headers-search-bookmark "flag:unread AND NOT flag:trashed")
;;     (sleep-for 0.15)
;;     (mu4e-headers-mark-all-unread-read)
;;     (mu4e-mark-execute-all 'no-confirmation)))

;; (add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")


;; (defun enter-mu4e-context-mail ()
;; (setq mu4e-drafts-folder   "/mail/drafts"
;;         mu4e-sent-folder "/mail/sent"
;;         ;; mu4e-refile-folder  "/mail/[Gmail]/All Mail"
;;         mu4e-trash-folder  "/mail/trash"
;;         mu4e-maildir-shortcuts
;;         '((:maildir "/mail/inbox" :key ?i)
;;         (:maildir "/mail/sent"  :key ?s)
;;         (:maildir "/mail/trash" :key ?t))))

;; (defun enter-mu4e-context-ambra ()
;; (setq mu4e-drafts-folder   "/ambra/[Gmail]/Drafts"
;;         mu4e-sent-folder "/ambra/[Gmail]/Sent Mail"
;;         ;; mu4e-refile-folder  "/ambra/[Gmail]/All Mail"
;;         mu4e-trash-folder  "/ambra/[Gmail]/Trash"
;;         mu4e-maildir-shortcuts
;;         '((:maildir "/ambra/inbox" :key ?i)
;;         (:maildir "/ambra/[Gmail]/Sent Mail" :key ?s)
;;         (:maildir "/ambra/[Gmail]/Trash" :key ?t))))

;; (defun enter-mu4e-context-quantumsoft ()
;; (setq mu4e-drafts-folder   "/quantumsoft/[Gmail]/Drafts"
;;         mu4e-sent-folder "/quantumsoft/[Gmail]/Sent Mail"
;;         ;; mu4e-refile-folder  "/quantumsoft/[Gmail]/All Mail"
;;         mu4e-trash-folder  "/quantumsoft/[Gmail]/Trash"
;;         mu4e-maildir-shortcuts
;;         '((:maildir "/quantumsoft/inbox" :key ?i)
;;         (:maildir "/quantumsoft/[Gmail]/Sent Mail" :key ?s)
;;         (:maildir "/quantumsoft/[Gmail]/Trash" :key ?t))))

;; (setq dy-mu4e-bookmarks-mail
;;     '(("maildir:/mail/inbox" "Inbox" ?i)
;;         ("flag:unread AND to:dyens@mail.ru" "Unread messages" ?u)
;;         ("date:today..now AND to:dyens@mail.ru" "Today's messages" ?t)
;;         ("date:7d..now AND to:dyens@mail.ru" "Last 7 days" ?w)
;;         ("mime:image/* AND to:dyens@mail.ru" "Messages with images" ?p)))


;; (setq dy-mu4e-bookmarks-ambra
;;     '(("maildir:/ambra/inbox" "Inbox" ?i)
;;         ("flag:unread AND to:akapustin@ambrahealth.com" "Unread messages" ?u)
;;         ("date:today..now AND to:akapustin@ambrahealth.com" "Today's messages" ?t)
;;         ("date:7d..now AND to:akapustin@ambrahealth.com" "Last 7 days" ?w)
;;         ("mime:image/* AND to:akapustin@ambrahealth.com" "Messages with images" ?p)))


;; (setq dy-mu4e-bookmarks-quantumsoft
;;     '(("maildir:/quantumsoft/inbox" "Inbox" ?i)
;;         ("flag:unread AND to:akapustin@quantumsofthealth.ru" "Unread messages" ?u)
;;         ("date:today..now AND to:akapustin@quantumsofthealth.ru" "Today's messages" ?t)
;;         ("date:7d..now AND to:akapustin@quantumsofthealth.ru" "Last 7 days" ?w)
;;         ("mime:image/* AND to:akapustin@quantumsofthealth.ru" "Messages with images" ?p)))


;; ;; (setq mu4e-alert-mu4e-header-func-var  "A")
;; (use-package mu4e-alert
;;     :ensure t
;;     :config
;;     (mu4e-alert-set-default-style 'libnotify)
;;     (add-hook 'after-init-hook #'mu4e-alert-enable-notifications)
;; )

;; (use-package mu4e
;; :ensure nil
;; :config

;; ;; This is set to 't' to avoid mail syncing issues when using mbsync
;; (setq mu4e-change-filenames-when-moving t)

;; ;; Refresh mail using isync every 10 minutes
;; (setq mu4e-update-interval (* 10 60))
;; (setq mu4e-get-mail-command "mbsync -a")
;; (setq mu4e-maildir "~/mailbox")
;; (setq mu4e-bookmarks dy-mu4e-bookmarks-mail)

;; (setq message-send-mail-function 'smtpmail-send-it
;;         starttls-use-gnutls t
;;         smtpmail-starttls-credentials
;;         '(("smtp.gmail.com" 587 nil nil))
;;         smtpmail-auth-credentials
;;         (expand-file-name "~/.authinfo")
;;         smtpmail-default-smtp-server "smtp.gmail.com"
;;         smtpmail-smtp-server "smtp.gmail.com"
;;         smtpmail-smtp-service 587
;;         smtpmail-debug-info t)

;; (setq mu4e-contexts
;;       `(
;;         ;; Mail personal
;;         ,(make-mu4e-context
;;           :name "Mail"
;;           :match-func
;;           (lambda (msg)
;;             (when msg
;;               (string-prefix-p "/mail" (mu4e-message-field msg :maildir))))
;;           :vars `((user-mail-address . "dyens@mail.ru")
;;                   (smtpmail-starttls-credentials . '(("smtp.mail.com" 465 nil nil)))
;;                   (smtpmail-auth-credentials . (expand-file-name "~/.authinfo"))
;;                   (smtpmail-smtp-service . 465)
;;                   (smtpmail-smtp-user . "dyens@mail.ru")
;;                   (smtpmail-smtp-server . "smtp.mail.ru" )
;;                   (smtpmail-stream-type . ssl)
;;                   (mu4e-bookmarks . ,dy-mu4e-bookmarks-mail)
;;                   (user-full-name . "Kapustin Alexander"))
;;           :enter-func (lambda () (progn
;;                               (mu4e-message "Entering Mail Context")
;;                               (enter-mu4e-context-mail)))
;;           :leave-func (lambda () (mu4e-message "Leave Mail Context")))

;;         ;; Ambra work account
;;         ;; ,(make-mu4e-context
;;         ;;  :name "Ambra"
;;         ;;  :match-func
;;         ;;    (lambda (msg)
;;         ;;      (when msg
;;         ;;        (string-prefix-p "/ambra" (mu4e-message-field msg :maildir))))
;;         ;;  :vars `((user-mail-address . "akapustin@ambrahealth.com")
;;         ;;            (smtpmail-smtp-user . "akapustin@ambrahealth.com")
;;         ;;            (smtpmail-smtp-server . "smtp.gmail.com" )
;;         ;;          (mu4e-bookmarks . ,dy-mu4e-bookmarks-ambra)
;;         ;;          (user-full-name    . "Kapustin Alexander"))
;;         ;;  :enter-func (lambda () (progn
;;         ;;                      (mu4e-message "Entering Ambra Context")
;;         ;;                      (enter-mu4e-context-ambra)))
;;         ;;  :leave-func (lambda () (mu4e-message "Leave Ambra Context")))

;;         ;; Quantumsoft work account
;;         ,(make-mu4e-context
;;           :name "Quantumsoft"
;;           :match-func
;;           (lambda (msg)
;;             (when msg
;;               (string-prefix-p "/quantumsoft" (mu4e-message-field msg :maildir))))
;;           :vars `((user-mail-address . "alexander.kapustin@quantumsoft.ru")
;;                   (smtpmail-smtp-user . "alexander.kapustin@quantumsoft.ru")
;;                   (smtpmail-smtp-server . "smtp.gmail.com" )
;;                   (mu4e-bookmarks . ,dy-mu4e-bookmarks-quantumsoft)
;;                   (user-full-name    . "Kapustin Alexander"))
;;           :enter-func (lambda () (progn
;;                               (mu4e-message "Entering Quantumsoft Context")
;;                               (enter-mu4e-context-quantumsoft)))
;;           :leave-func (lambda () (mu4e-message "Leave Quantumsoft Context"))))))
