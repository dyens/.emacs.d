;; -*- lexical-binding: t; -*-
(require 'transient)
(require 'url)

(setq managed-vaults
      '(d3 "http://dc1-v-msvault001.infra.dev.01.vmw.t1.loc"
        d32 "https://vault-01-dev-p1.ms.t1.cloud"))

(setq kaas-proxies
      '(
        d3 "http://10.13.240.5:3128"
        d32 "http://10.15.13.107:3128"
        prod "http://10.13.77.164:3128"))


(setq kaas-kubeconfig-paths
      '(
        d3 "/home/dyens/k8s/d3kaas"
        d32 "/home/dyens/k8s/d32kaas"
        prod "/home/dyens/k8s/prodkaas"))


;; DEPREACTEDD!
;; (defun kaas-create-config (file proxy-url)
;;   (find-file file)
;;   (delete-region (point-min) (point-max))
;;   (clipboard-yank)
;;   (goto-char (point-min))
;;   (search-forward "content\": ")
;;   (delete-region (point-min) (+ (point) 1))
;;   (search-forward "\"")
;;   (delete-region (- (point) 1) (point-max))
;;   (base64-decode-region (point-min) (point-max))
;;   (goto-line 5)
;;   (insert (format "    proxy-url: %s\n" proxy-url)))
;; 
(defun kaas-user-config ()
  (interactive)
  (error "deprecated")
  (let* ((user-kube-secret (s-trim (shell-command-to-string "kubectl get secrets | grep cluster.x-k8s.io/secret | grep kubeconfig | awk  '{print $1}'" )))
         (kube-config (shell-command-to-string (format "kubectl get secrets %s  -o jsonpath='{.data.value}' | base64 -d" user-kube-secret))))
    (f-write-text kube-config 'utf-8 "/home/dyens/k8s/kaasuser")))
;; 
;; 
;; 
;; (defun kaas-d3 ()
;;   (interactive)
;;   (kaas-create-config "/home/dyens/k8s/d3kaas" "http://10.13.240.5:3128"))
;; 
;; (defun kaas-d3-2region ()
;;   (interactive)
;;   (kaas-create-config "/home/dyens/k8s/d3kaas" "http://10.15.13.107:3128"))
;; 
;; (defun kaas-prod ()
;;   (interactive)
;;   (kaas-create-config "/home/dyens/k8s/prodkaas" "http://10.13.77.164:3128"))




(defun vault-get-kubeconfig (stand item-id)
  (interactive)
  (let ((url (plist-get managed-vaults stand)))
  (with-temp-buffer 
    (call-process "vault" nil (current-buffer) nil
                  "kv" "get" "-address" url
                  "-format" "json"
                  (format "cloud-solution/kaas/rpc-kaas-provisioning/%s/kubeconfig" item-id))
    (let* ((js (json-read-from-string (buffer-substring-no-properties (point-min) (point-max))))
           (content (cdr (assq 'content (cdr (assq 'data (cdr (assq 'data js ))))))))
      (base64-decode-string content)))))

(defun kubeconfig-substitute-proxy (stand kubeconfig)
  (with-temp-buffer 
    (insert kubeconfig)
    (goto-line 5)
    (insert (format "    proxy-url: %s\n" (plist-get kaas-proxies stand)))
    (buffer-substring-no-properties (point-min) (point-max))))

(defun save-kubeconfig-to-file (stand kubeconfig)
  (let ((fpath (plist-get kaas-kubeconfig-paths stand)))
    (find-file fpath)
    (delete-region (point-min) (point-max))
    (insert kubeconfig)))


(defun get-and-save-kubeconfig (stand item-id)
  (save-kubeconfig-to-file stand 
  (kubeconfig-substitute-proxy stand
  (vault-get-kubeconfig stand item-id))))

(defun get-and-save-kubeconfig-transient (&optional args)
  (interactive (list (transient-args transient-current-command)))
  (get-and-save-kubeconfig (intern (transient-arg-value "--stand=" args))
                           (transient-arg-value "--item-id=" args)))



(transient-define-prefix vault-kubeconfig ()
  ["Arguments"
   ("-id" "Item ID" "--item-id="
         :allow-empty nil)
   ("-stand" "Stand" "--stand="
         :allow-empty nil
         :choices ("d3" "d32" "prod"))]
  ["Commands"
   ("e" "execute" get-and-save-kubeconfig-transient)])


(defun get-hostname-from-url (url)
  (let ((parsed-url (url-generic-parse-url url)))
    (url-host parsed-url)))

(defun get-vault-login-cmd (stand)
  (interactive)
  (let* (
         (url (plist-get managed-vaults stand))
         (auth-secret (car (auth-source-search  :host (get-hostname-from-url url))))
         (user (plist-get auth-secret :user))
         (get-password (plist-get auth-secret :secret))
         (password (funcall get-password))
         (cmd (format "vault login -address %s -method=userpass username=%s password=%s" url user password)))
    (kill-new  cmd)
    cmd))

(defun get-kaas-item-id (url)
  (interactive)
  (with-environment-variables (("VIRTUAL_ENV" "/home/dyens/dev/croc/t1/.venv"))
    (let ((item-id (s-trim (shell-command-to-string (format "cd /home/dyens/dev/croc/t1 && uv run python get_kaas_id.py \"%s\"" url)))))
    (kill-new item-id)
    item-id)))

;; (get-and-save-kubeconfig 'd3 (get-kaas-item-id "https://d3-portal-front.portal.cloud-d3.k8s.dev.01.vmw.t1.loc/managed_kaas/d36c7e6a-8b8c-4c4b-970e-61fbc77e8acc?page=0&perPage=25&context=proj-dn9anix1w0txl9v&type=project&org=org-ltole97t&tab=information"))

(provide 'dy-kaas)
