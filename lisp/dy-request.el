;; -*- lexical-binding: t; -*-
(defun dy-request ()
  "Make url retrieve."
  (let ((buf (url-retrieve-synchronously url))
        content)
    (setq content (get-buffer-string  buf))
    (with-current-buffer (get-buffer-create "*HTTP-RESULT*")
      (erase-buffer)
      (insert (decode-coding-string content 'utf-8)))))
 

;; Make http requests in emacs

  

(defvar token-oauth nil
  "Oauth2 token")


(defun dy-set-ift1-token ()
  "ift1 oauth2 token"
  (interactive)
  (setq token-oauth
    (oauth2-auth
            "https://ift1-auth.apps.cloud.k8s.test.01.vmw.t1.loc/auth/realms/Portal/protocol/openid-connect/auth"
            "https://ift1-auth.apps.cloud.k8s.test.01.vmw.t1.loc/auth/realms/Portal/protocol/openid-connect/token"
            "portal-front"
            ""
            "openid"
            ""
            "https://ift1-portal-front.apps.cloud.k8s.test.01.vmw.t1.loc")))
 


(defun dy-set-dev-token ()
  "dev oauth2 token"
  (interactive)
  (setq token-oauth
    (oauth2-auth
            "https://d2-auth.apps.cloud.k8s.dev.01.vmw.t1.loc/auth/realms/Portal/protocol/openid-connect/auth"
            "https://d2-auth.apps.cloud.k8s.dev.01.vmw.t1.loc/auth/realms/Portal/protocol/openid-connect/token"
            "portal-front"
            ""
            "openid"
            ""
            "https://d2-portal-front.apps.cloud.k8s.dev.01.vmw.t1.loc")))
 

(defun dy-oauth-request-example()
(let ((url "https://d2-api.apps.cloud.k8s.dev.01.vmw.t1.loc/ai-api/api/v1/projects/proj-123/order-service/orders")
      (url-request-method "GET")
      (url-request-extra-headers
        '(("Content-Type" . "application/json")))
       (url-request-data
        (encode-coding-string
         (json-encode
          '(:messages [(:role "user"
                        :content "qual é o melhor editor, vim ou emacs?")]))
         'utf-8)))
  (dy-oauth-request)))


(provide 'dy-request)
