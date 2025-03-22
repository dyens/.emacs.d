(defun kaas-create-config (file proxy-url)
  (find-file file)
  (delete-region (point-min) (point-max))
  (clipboard-yank)
  (goto-char (point-min))
  (search-forward "content\": ")
  (delete-region (point-min) (+ (point) 1))
  (search-forward "\"")
  (delete-region (- (point) 1) (point-max))
  (base64-decode-region (point-min) (point-max))
  (goto-line 5)
  (insert (format "    proxy-url: %s\n" proxy-url)))

(defun kaas-d3 ()
  (interactive)
  (kaas-create-config "/home/dyens/k8s/d3kaas" "http://10.13.240.5:3128"))


(defun kaas-prod ()
  (interactive)
  (kaas-create-config "/home/dyens/k8s/prodkaas" "http://10.13.77.164:3128"))


(defun kaas-user-config ()
  (interactive)
  (let* ((user-kube-secret (s-trim (shell-command-to-string "kubectl get secrets | grep cluster.x-k8s.io/secret | grep kubeconfig | awk  '{print $1}'" )))
         (kube-config (shell-command-to-string (format "kubectl get secrets %s  -o jsonpath='{.data.value}' | base64 -d" user-kube-secret))))
    (f-write-text kube-config 'utf-8 "/home/dyens/k8s/kaasuser")))

(provide 'dy-kaas)
