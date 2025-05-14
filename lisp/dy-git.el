;; -*- lexical-binding: t; -*-
(defun dy-get-git-origin-url ()
  "Return current git origin url"
  (let ((url (magit-git-output "config" "--get" "remote.origin.url")))
    (cond
     ((string-match "git@\\(.*\\):\\(.*\\)\.git" url) (format "https://%s/%s" (match-string 1 url) (match-string 2 url)))
     ((string-match "\\(.*\\)\.git" url) (match-string 1 url) )
     (t (error "Can not detect origin"))
     )))


(defun dy-open-in-github (github-url  &optional mode)
  "Open source file in github."
  (interactive)
  (let (
	(github-url (if (null github-url) (dy-get-git-origin-url) (github-url)))
	(github-path
	 (cond
	  ((eq mode nil) (magit-get-current-branch))
	  ((eq mode 'dev) "dev")
	  ((eq mode 'branch) (magit-get-current-branch))
	  ((eq mode 'rev) (magit-rev-abbrev "HEAD"))))

	(project-file (magit-file-relative-name ( buffer-file-name)) )
	(highlight
	 (if (use-region-p)
             (let ((l1 (line-number-at-pos (region-beginning)))
                   (l2 (line-number-at-pos (- (region-end) 1))))
               (format "#L%d-L%d" l1 l2))
           ""))
	(url))
    (setq url (format "%s/blob/%s/%s%s" github-url github-path project-file highlight))
    (shell-command (concat "firefox " url))))

;;;###autoload
(defun dy-open-in-github-branch()
    (interactive)
    (dy-open-in-github nil 'branch))

;;;###autoload
(defun dy-open-in-github-rev()
    (interactive)
    (dy-open-in-github nil 'rev))

(provide 'dy-git)
