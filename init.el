(package-initialize) 

(require 'org)
(require 'ob-tangle)


(setq init-dir (file-name-directory (or load-file-name (buffer-file-name))))

(org-babel-load-file (expand-file-name "main.org" init-dir))


;(org-babel-load-file (expand-file-name "gcal-config.org" init-dir))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("018c8326bced5102b4c1b84e1739ba3c7602019c645875459f5e6dfc6b9d9437" "728eda145ad16686d4bbb8e50d540563573592013b10c3e2defc493f390f7d83" "274fa62b00d732d093fc3f120aca1b31a6bb484492f31081c1814a858e25c72e" default)))
 '(ivy-mode t)
 '(package-selected-packages
   (quote
    (use-package doom-themes dracula-theme leuven-theme racer rust-mode smex docker-compose-mode dockerfile-mode pytest bind-key py-isort yapfify projectile restclient evil-magit magit eyebrowse winum counsel ivy evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
