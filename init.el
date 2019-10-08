

;; Make startup faster
(defvar file-name-handler-alist-old file-name-handler-alist)
(setq package-enable-at-startup nil
      file-name-handler-alist nil
      message-log-max 16384
      gc-cons-threshold 402653184
      gc-cons-percentage 0.6
      auto-window-vscroll nil
      package--init-file-ensured t)

(add-hook 'after-init-hook
          `(lambda ()
             (setq file-name-handler-alist file-name-handler-alist-old
                   gc-cons-threshold 800000
                   gc-cons-percentage 0.1)) t)


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
 '(company-tooltip-align-annotations t)
 '(custom-safe-themes
   (quote
    ("0fe9f7a04e7a00ad99ecacc875c8ccb4153204e29d3e57e9669691e6ed8340ce" "fe76f3d5094967034192f6a505085db8db6deb0e135749d9a54dc488d6d3ee2f" "66d53738cc824d0bc5b703276975581b8de2b903d6ce366cd62207b5dd6d3d13" "cdb3e7a8864cede434b168c9a060bf853eeb5b3f9f758310d2a2e23be41a24ae" "2878517f049b28342d7a360fd3f4b227086c4be8f8409f32e0f234d129cee925" "001c2ff8afde9c3e707a2eb3e810a0a36fb2b466e96377ac95968e7f8930a7c5" "2d392972cbe692ee4ac61dc79907af65051450caf690a8c4d36eb40c1857ba7d" "e7666261f46e2f4f42fd1f9aa1875bdb81d17cc7a121533cad3e0d724f12faf2" "728eda145ad16686d4bbb8e50d540563573592013b10c3e2defc493f390f7d83" "c8f959fb1ea32ddfc0f50db85fea2e7d86b72bb4d106803018be1c3566fd6c72" "2a3ffb7775b2fe3643b179f2046493891b0d1153e57ec74bbe69580b951699ca" "fefab1b6d3366a959c78b4ed154018d48f4ec439ce652f4748ef22945ca7c2d5" "018c8326bced5102b4c1b84e1739ba3c7602019c645875459f5e6dfc6b9d9437" default)))
 '(elpy-rpc-backend "jedi" t)
 '(global-display-line-numbers-mode t)
 '(org-agenda-files (quote ("~/org/agenda.org")))
 '(org-confirm-babel-evaluate nil)
 '(org-display-inline-images t t)
 '(org-plantuml-jar-path "/home/dyens/.emacs.d/plantuml.jar")
 '(org-redisplay-inline-images t t)
 '(org-startup-with-inline-images "inlineimages")
 '(package-selected-packages
   (quote
    (all-the-icons-dired all-the-icons challenger-deep-theme lilypond-mode evil-matchit3 evil-matchit engine-mode yapfify winum which-key wakatime-mode use-package treepy smex restclient racer pytest py-isort projectile plantuml-mode lsp-ui gruber-darker-theme flycheck eyebrowse evil-magit elpy dracula-theme doom-themes dockerfile-mode docker-tramp docker-compose-mode dap-mode counsel company-lsp closql)))
 '(plantuml-jar-path "/home/dyens/.emacs.d/plantuml.jar" t)
 '(python-shell-interpreter "ipython")
 '(python-shell-interpreter-args "-i --simple-prompt")
 '(rust-format-on-save t)
 '(shell-file-name "bash")
 '(yas-snippet-dirs (quote ("~/.emacs.d/snippets"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
