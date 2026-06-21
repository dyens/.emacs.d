;; -*- lexical-binding: t; -*-
;; For debug use M-x buffer-list, M-x Buffer-menu-toggle-internal

(require 'cl-lib)

(defvar dhttp-debug t "When non nil, write responses to *dhttp-response* buffer.")
(defvar dhttp-default-headers '() "Default headers for HTTP requests.")
(defvar dhttp-history-size 50 "Max number of entries in request history.")
(defvar dhttp--history (make-ring 50) "Ring of recent request/response plists.")
(defvar dhttp--keycloak-credentials nil "Stored keycloak credentials for auto-refresh.")

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

(defun dhttp-parse-json (resp)
  "Parse :response of RESP as JSON if it is a string.
Return a new plist with parsed :response."
  (let ((body (plist-get resp :response)))
    (if (stringp body)
        (plist-put (copy-sequence resp) :response (json-read-from-string body))
      resp)))

(cl-defun dhttp-req (method url &key path query json-body body headers raw)
  "Perform HTTP request with METHOD to URL.
When RAW is non-nil, always return response body as string.
Otherwise auto-parse JSON responses.
Return plist (:status CODE :response BODY :headers ALIST)."
  (let* ((url-request-method method)
         (response-headers '())
         response-body
         response-status
         (base-url (if path (format "%s/%s" url path) url))
         (full-url (if query
                       (format "%s?%s" base-url (dhttp-form-encode query))
                     base-url))
         (url-request-data
          (if json-body
              (encode-coding-string (json-encode json-body) 'utf-8)
            body))
         (extra-headers (or headers dhttp-default-headers))
         (url-request-extra-headers
          (if (and json-body (not (assoc "Content-Type" extra-headers)))
              (cons '("Content-Type" . "application/json") extra-headers)
            extra-headers)))

    (let ((buf (url-retrieve-synchronously full-url nil nil 10)))
      (unwind-protect
          (with-current-buffer buf
            (message "dhttp request: %s" (buffer-name buf))
            (setq response-status url-http-response-status)
            (goto-char (point-min))
            (forward-line 1)

            (while (re-search-forward "^\\([^:\n]+\\): \\([^\n]+\\)$" url-http-end-of-headers t)
              (push `(,(downcase (match-string-no-properties 1)) . ,(match-string-no-properties 2)) response-headers))

            (goto-char url-http-end-of-headers)
            (forward-line 1)
            (setq response-body (buffer-substring-no-properties (point) (point-max))))
        (kill-buffer buf)))
    (let* ((result `(:status ,response-status :response ,response-body :headers ,response-headers))
           (result (if (and (not raw)
                            (assoc "content-type" response-headers)
                            (string-match-p "application/json"
                                            (cdr (assoc "content-type" response-headers))))
                       (dhttp-parse-json result)
                     result)))
      (ring-insert dhttp--history
                   `(:method ,method :url ,full-url :status ,response-status
                     :response ,(plist-get result :response) :headers ,response-headers))
      (when dhttp-debug
        (with-current-buffer (get-buffer-create "*dhttp-response*")
          (fundamental-mode)
          (erase-buffer)
          (insert (format "%s %s\nStatus: %s\n\n" method full-url response-status))
          (insert (if (stringp (plist-get result :response))
                      (plist-get result :response)
                    (pp-to-string (plist-get result :response))))))
      result)))


(defmacro dhttp-defverb (name method)
  "Define HTTP verb wrapper NAME forwarding to `dhttp-req' with METHOD.
The wrapper exposes the same `&key' arguments as `dhttp-req' so that
eldoc shows them in the signature."
  (let ((keys '(path query json-body body headers raw)))
    `(cl-defun ,name (url &key ,@keys)
       (dhttp-req ,method url
                  ,@(mapcan (lambda (k)
                              (list (intern (format ":%s" k)) k))
                            keys)))))

(dhttp-defverb dhttp-get    "GET")
(dhttp-defverb dhttp-post   "POST")
(dhttp-defverb dhttp-put    "PUT")
(dhttp-defverb dhttp-patch  "PATCH")
(dhttp-defverb dhttp-delete "DELETE")

(defun dhttp-bearer (token)
  "Set Bearer TOKEN in `dhttp-default-headers'."
  (setq dhttp-default-headers
        (cons `("Authorization" . ,(format "Bearer %s" token))
              (assoc-delete-all "Authorization" dhttp-default-headers))))

(defun dhttp-jq (resp &rest path)
  "Navigate RESP plist by PATH.
Symbols do alist-get, integers do aref.
Example: (dhttp-jq resp 'data 0 'name)"
  (let ((node (plist-get resp :response)))
    (dolist (key path node)
      (setq node (if (integerp key)
                     (aref node key)
                   (alist-get key node))))))

(defun dhttp-form-encode (alist)
  "Encode ALIST as application/x-www-form-urlencoded string."
  (mapconcat (lambda (pair)
               (format "%s=%s"
                       (url-hexify-string (format "%s" (car pair)))
                       (url-hexify-string (format "%s" (cdr pair)))))
             alist "&"))



;; --- history ---

(defun dhttp-history (&optional n)
  "Return last N entries from request history (default all).
Each entry is a plist (:method :url :status :response :headers)."
  (let ((len (ring-length dhttp--history))
        (n (or n (ring-length dhttp--history)))
        entries)
    (dotimes (i (min n len))
      (push (ring-ref dhttp--history i) entries))
    (nreverse entries)))

;; --- inspect ---

(defun dhttp-inspect ()
  "Show *dhttp-response* buffer."
  (interactive)
  (let ((buf (get-buffer "*dhttp-response*")))
    (unless buf
      (user-error "No *dhttp-response* buffer. Make a request with dhttp-debug set to t"))
    (pop-to-buffer buf)
    (goto-char (point-min))))

;; --- auth refresh ---

(defun dhttp-keycloak-token (keycloak-url realm client-id client-secret)
  "Get access token from Keycloak and set it in `dhttp-default-headers'.
Stores credentials for `dhttp-auth-refresh'. Return the token string."
  (setq dhttp--keycloak-credentials
        (list :url keycloak-url :realm realm :client-id client-id :client-secret client-secret))
  (let* ((url (format "%s/realms/%s/protocol/openid-connect/token" keycloak-url realm))
         (resp (dhttp-post url
                           :body (dhttp-form-encode
                                  `((client_id . ,client-id)
                                    (client_secret . ,client-secret)
                                    (grant_type . "client_credentials")))
                           :headers '(("Content-Type" . "application/x-www-form-urlencoded"))))
         (status (plist-get resp :status))
         (data (plist-get resp :response)))
    (unless (= status 200)
      (error "Keycloak token error %s: %s" status data))
    (let ((token (alist-get 'access_token data)))
      (dhttp-bearer token)
      (message "dhttp: keycloak token set, expires_in=%ss" (alist-get 'expires_in data))
      token)))

(defun dhttp-auth-refresh ()
  "Re-fetch Keycloak token using stored credentials."
  (interactive)
  (unless dhttp--keycloak-credentials
    (user-error "No stored keycloak credentials. Call dhttp-keycloak-token first"))
  (let ((c dhttp--keycloak-credentials))
    (dhttp-keycloak-token
     (plist-get c :url) (plist-get c :realm)
     (plist-get c :client-id) (plist-get c :client-secret))))

;; --- curl ---

(cl-defun dhttp-curl (method url &key path query json-body body headers)
  "Generate curl command string from request parameters.
Accepts same keyword args as `dhttp-req'. Returns the command and copies to kill ring."
  (let* ((headers (or headers dhttp-default-headers))
         (base-url (if path (format "%s/%s" url path) url))
         (full-url (if query
                       (format "%s?%s" base-url (dhttp-form-encode query))
                     base-url))
         (parts (list "curl" "-X" method (format "'%s'" full-url))))
    (dolist (h headers)
      (push (format "-H '%s: %s'" (car h) (cdr h)) parts))
    (when json-body
      (unless (assoc "Content-Type" headers)
        (push "-H 'Content-Type: application/json'" parts))
      (push (format "-d '%s'" (json-encode json-body)) parts))
    (when body
      (push (format "-d '%s'" body) parts))
    (let ((cmd (string-join (nreverse parts) " ")))
      (kill-new cmd)
      (message "Copied: %s" cmd)
      cmd)))


;; --- download ---

(cl-defun dhttp-download (url file &key path query headers)
  "Download URL to FILE as binary.
Return plist (:status CODE :file FILE :headers ALIST)."
  (let* ((url-request-method "GET")
         (response-headers '())
         response-status
         (base-url (if path (format "%s/%s" url path) url))
         (full-url (if query
                       (format "%s?%s" base-url (dhttp-form-encode query))
                     base-url))
         (url-request-extra-headers (or headers dhttp-default-headers)))
    (let ((buf (url-retrieve-synchronously full-url nil nil 30)))
      (unwind-protect
          (with-current-buffer buf
            (setq response-status url-http-response-status)
            (goto-char (point-min))
            (forward-line 1)
            (while (re-search-forward "^\\([^:\n]+\\): \\([^\n]+\\)$" url-http-end-of-headers t)
              (push `(,(downcase (match-string-no-properties 1)) . ,(match-string-no-properties 2)) response-headers))
            (goto-char url-http-end-of-headers)
            (forward-line 1)
            (let ((coding-system-for-write 'binary))
              (write-region (point) (point-max) file nil 'silent)))
        (kill-buffer buf)))
    (message "dhttp: saved %s (%s bytes)" file (file-attribute-size (file-attributes file)))
    `(:status ,response-status :file ,file :headers ,response-headers)))


(provide 'dy-http)


;; Example!
;; Render HTML
;;
;; (dhttp-get "https://httpbin.dev/html")
;; (shr-render-buffer  "*dhttp-response*")

;; Download file
;; (dhttp-download "https://httpbin.dev/gzip" "~/aa.zip")


;; Json
;; (dhttp-get "https://httpbin.dev/json")
;; (alist-get  'slideshow
;;             (json-read-from-string
;;              (plist-get (dhttp-get "https://httpbin.dev/json") :response)))


;; Use keycloak
;; (require 'dy-tools)
;;
;; (let ((kc-url "https://d3-auth.portal.cloud-d3.k8s.dev.01.vmw.t1.loc/auth")
;;       (realm "Portal")
;;       (client "cloud_cloud-audit-config-sync"))
;;   (dhttp-keycloak-token kc-url realm client (dy-authinfo-get-secret kc-url :user client)))


;; (defun get-some-project ()
;;   (let* ((base "https://d3-api.portal.cloud-d3.k8s.dev.01.vmw.t1.loc")
;;          (org "org-ltole97t")
;;          (url (format "%s/resource-manager/api/v1/organizations/%s/projects" base org)))
;;     (dhttp-jq (dhttp-get url) 'data 0 'name)))

;; (get-some-project)
