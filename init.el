(package-initialize) 

(require 'org)
(require 'ob-tangle)


(setq init-dir (file-name-directory (or load-file-name (buffer-file-name))))

(org-babel-load-file (expand-file-name "main.org" init-dir))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (flycheck yapfify winum which-key wakatime-mode use-package treepy smex restclient racer pytest py-isort projectile lsp-ui let-alist gruber-darker-theme eyebrowse evil-magit elpy dracula-theme doom-themes dockerfile-mode docker-compose-mode dap-mode counsel company-lsp closql))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
