;; -*- lexical-binding: t; -*-

;; json tools
(defun dhttp-json-from-str (begin end)
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region begin end)
      (goto-char (point-min))
      (let ((point-max-before (point-max)))
        (insert (format "\n%s" (json-read)))
        (pp-28 point-max-before (point-max))))))


(defun dhttp-json-print (obj)
  (insert (format "%s\n" (json-encode obj))))
;; ---

(setq dhttp-debug t)

(defun dhttp-req (method url &rest kwargs)
  (let* ((url-request-method method)
         (response-headers '())
         response-body
         response-status
         (path (or (plist-get kwargs :path) nil))
         (full-url (if path (format "%s/%s" url path) url))
         (json-resp (or (plist-get kwargs :json-resp) nil))
         (json-body (or (plist-get kwargs :json-body) nil))
         (body (or (plist-get kwargs :body) nil))
         (url-request-data
          (if json-body
              (encode-coding-string (json-encode json-body) 'utf-8)
            body))
         (url-request-extra-headers (or (plist-get kwargs :headers) DHTTP_DEFAULT_HEADERS)))

    (with-current-buffer (url-retrieve-synchronously full-url nil nil 10)
      (message "dhttp request: %s" (buffer-name (current-buffer)))
      (setq response-status url-http-response-status)
      (goto-char (point-min))
      (forward-line 1)

      (while (re-search-forward "^\\([^:\n]+\\): \\([^\n]+\\)$" url-http-end-of-headers t)
        (push `(,(downcase (match-string-no-properties 1)) . ,(match-string-no-properties 2)) response-headers))

      (goto-char (point-min))
      (goto-char url-http-end-of-headers)
      ;; Empty line before body
      (forward-line 1)
      (setq response-body
            (prog1
                (if json-resp 
                    (json-read) 
                  (buffer-substring-no-properties (point) (point-max)))
              (if (not dhttp-debug) (kill-buffer))
              ))
      )
    `(:status ,response-status :response ,response-body :headers ,response-headers)))


(defun dhttp-get (url &rest kwargs)
  (apply #'dhttp-req "GET" url kwargs))


(defun dhttp-post (url &rest kwargs)
  (apply #'dhttp-req "POST" url kwargs))


(provide 'dy-http)
