;; Startup
(load "~/.emacs.d/config/startup.el")

;; Config
(load "~/.emacs.d/config/config.el")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(dy-notify-after-compilation t)
 '(package-selected-packages
   '(yapfify which-key vue-mode vertico use-package typescript-mode
             tree-sitter-langs terraform-mode tempel telega
             spacious-padding snow sly rustic run-command ruff-format
             rg restclient pytest pyenv-mode pydoc py-isort
             plantuml-mode pkg-info persp-projectile perfect-margin
             pdf-tools paredit org-roam org-present org-modern
             org-mime org-jira org-contrib orderless ob-mermaid nov
             multi-vterm mu4e-alert marginalia magit lua-mode
             kubernetes-evil gotest google-translate go-mode ggtags
             geiser-guile flymake-ruff flycheck expand-region
             evil-text-object-python evil-string-inflection
             evil-multiedit evil-escape evil-collection
             eshell-git-prompt embark-consult elpy eglot ef-themes
             dockerfile-mode docker-compose-mode dired-single
             dired-open dape dap-mode corfu cmake-mode clang-format
             blacken))
 '(pytest-project-root-files '("setup.py" ".hg" ".git"))
 '(safe-local-variable-values
   '((run-command-recipe-proj lambda nil
                              (list
                               (list :command-name "build tensorflow"
                                     :command-line
                                     "make docker-build -C jupyter3.11 TAG=local")
                               (list :command-name "build js"
                                     :command-line
                                     "make docker-build -C tensorflow-gpu3.10 TAG=0.0.12")
                               (list :command-name "push js"
                                     :command-line
                                     "docker push gitlab-registry-dev.t1.cloud/cloud-solution/ai-cloud/images/ai-jupyter-3.11:local")
                               (list :command-name "run tensorflow"
                                     :command-line
                                     "docker run --rm -it --gpus all storage.devcroc.cloud:5000/ai-tensorflow-gpu-3.10:0.0.12 /bin/bash")
                               (list :command-name "prepare debug"
                                     :command-line
                                     "docker export $(docker create gitlab-registry-dev.t1.cloud/cloud-solution/ai-cloud/images/ai-jupyter-3.11:local) | tar -xC /tmp/debugjs")))
     (run-command-recipe-proj lambda nil
                              (list
                               (list :command-name "build tensorflow"
                                     :command-line
                                     "make docker-build -C jupyter3.11 TAG=local")
                               (list :command-name "build js"
                                     :command-line
                                     "make docker-build -C tensorflow-gpu3.10 TAG=0.0.12")
                               (list :command-name "push js"
                                     :command-line
                                     "docker push gitlab-registry-dev.t1.cloud/cloud-solution/ai-cloud/images/ai-jupyter-3.11:local")
                               (list :command-name "run tensorflow"
                                     :command-line
                                     "docker run --rm -it --gpus all storage.devcroc.cloud:5000/ai-tensorflow-gpu-3.10:0.0.12 /bin/bash")))
     (eval progn (setenv "GITLAB_TOKEN" "glpat-_zLU39jCr-NENfNt466s"))
     (eval progn (setenv "RUSER" "ai")
           (setenv "RPASS" "glpat-bsLzPGouMXKBpDqbWQ7u")
           (setenv "RNAME"
                   "gitlab-registry-dev.t1.cloud/cloud-solution/ai-cloud/images/ai-pyk-3.11:latest")
           (setq dy-project-commands
                 '("/usr/bin/time -v go run cmd/ich.go -t 5m -u kapustin -p \"DvvKEDtMtyVEs7XNmA-z\"  git-registry.service.t1-cloud.ru/cloud-solution/ai-cloud/images/ai-pyk-3.11:latest"
                   "go run cmd/ich/ich.go -t 5m -u $RUSER -p $RPASS -f output.json gitlab-registry-dev.t1.cloud/cloud-solution/ai-cloud/images/ai-pyk-3.11:latest"
                   "go run cmd/ich/ich.go -t 5m -u $RUSER -p $RPASS -f output.json gitlab-registry-dev.t1.cloud/cloud-solution/ai-cloud/images/ai-pyk-tf-3.10:latest"
                   "go run cmd/gif/gif.go  gitlab-registry-dev.t1.cloud/cloud-solution/ai-cloud/images/ai-pyk-3.11:latest"
                   "go run cmd/gif/gif.go  gitlab-registry-dev.t1.cloud/cloud-solution/ai-cloud/images/ai-pyk-3.11:latest gitlab-registry-dev.t1.cloud/cloud-solution/ai-cloud/images/ai-pyk-tf-3.10:latest"
                   "docker build . -t ich:local"
                   "docker run --rm  ich:local -t 5m -u kapustin -p DvvKEDtMtyVEs7XNmA-z git-registry.service.t1-cloud.ru/cloud-solution/ai-cloud/images/ai-pyk-3.11:latest"
                   "dlv debug cmd/ich/ich.go  -- -t 5m -u kapustin -p DvvKEDtMtyVEs7XNmA-z git-registry.service.t1-cloud.ru/cloud-solution/ai-cloud/images/ai-pyk-3.11:latest"
                   "docker rmi gitlab-registry-dev.t1.cloud/cloud-solution/ai-cloud/images/ai-pyk-3.11:latest gitlab-registry-dev.t1.cloud/cloud-solution/ai-cloud/images/ai-pyk-tf-3.10:latest")))
     (dy-pyenv-packages . "/usr/lib/python3.10/site-packages")
     (dy-pyvenv-packages format "%s/lib/python3.10/site-packages"
                         (getenv "VIRTUAL_ENV"))
     (dy-pytest-arguments . "")
     (run-command-recipe-proj lambda nil
                              (list
                               (list :command-name "build tensorflow"
                                     :command-line
                                     "make docker-build -C jupyter3.11 TAG=latest")
                               (list :command-name "build js"
                                     :command-line
                                     "make docker-build -C tensorflow-gpu3.10 TAG=0.0.12")
                               (list :command-name "push js"
                                     :command-line
                                     "docker push gitlab-registry-dev.t1.cloud/cloud-solution/ai-cloud/images/ai-jupyter-3.11:latest")
                               (list :command-name "run tensorflow"
                                     :command-line
                                     "docker run --rm -it --gpus all storage.devcroc.cloud:5000/ai-tensorflow-gpu-3.10:0.0.12 /bin/bash")))
     (eval progn
           (setenv "DOCKER_CONFIG_JSON"
                   "eyJhdXRocyI6eyJnaXRsYWItcmVnaXN0cnktZGV2LnQxLmNsb3VkIjp7InVzZXJuYW1lIjoiYWkiLCJwYXNzd29yZCI6ImdscGF0LWJzTHpQR291TVhLQnBEcWJXUTd1In19fQ==")
           (setenv "INGRESS_HOST" "t1.aicloud.vtb.devcroc.cloud")
           (setenv "TLS_SECRET_NAME"
                   "t1.aicloud.vtb.devcroc.cloud-tls")
           (setq dy-project-commands '("echo hello")))
     (eval progn
           (setenv "DOCKER_CONFIG_JSON"
                   "eyJhdXRocyI6eyJnaXRsYWItcmVnaXN0cnktZGV2LnQxLmNsb3VkIjp7InVzZXJuYW1lIjoiYWkiLCJwYXNzd29yZCI6ImdscGF0LWJzTHpQR291TVhLQnBEcWJXUTd1In19fQ==")
           (setenv "INGRESS_HOST" "xxx")
           (setq dy-project-commands '("echo hello")))
     (eval progn
           (setenv "NOVA_GITLAB_URL"
                   "https://git.int.nova-platform.io")
           (setenv "NOVA_GITLAB_TOKEN" "glpat-NcDHWA7ifbzjwgLz8imt")
           (setenv "NOVA_GITLAB_TOKEN" "glpat-YVnNTrA4sxreqAS8fmGA")
           (setenv "NOVA_STORAGE_ACCESS_KEY"
                   "nova-public:csi@croc.container.platform")
           (setenv "NOVA_STORAGE_SECRET_KEY" "QvFkBwrYTBqSEowYj8HkEA")
           (setq dy-project-commands
                 '("poetry run python -m nova_deps starts-from  1.0.3"
                   "poetry run python -m nova_deps version develop"
                   "poetry run python -m nova_deps puppetfile develop"
                   "poetry run python -m nova_deps universe-update 2.0.0-rc.2 --universe-project-id=88"
                   "poetry run python -m nova_deps universe-update 2.0.0-rc.13")))
     (eval progn (setenv "RUSER" "ai")
           (setenv "RPASS" "glpat-bsLzPGouMXKBpDqbWQ7u")
           (setenv "RNAME"
                   "gitlab-registry-dev.t1.cloud/cloud-solution/ai-cloud/images/ai-pyk-3.11:latest")
           (setq dy-project-commands
                 '("/usr/bin/time -v go run cmd/ich.go -t 5m -u kapustin -p \"DvvKEDtMtyVEs7XNmA-z\"  git-registry.service.t1-cloud.ru/cloud-solution/ai-cloud/images/ai-pyk-3.11:latest"
                   "go run cmd/ich/ich.go -t 5m -u $RUSER -p $RPASS -f output.json gitlab-registry-dev.t1.cloud/cloud-solution/ai-cloud/images/ai-pyk-3.11:latest"
                   "go run cmd/ich/ich.go -t 5m -u $RUSER -p $RPASS -f output.json gitlab-registry-dev.t1.cloud/cloud-solution/ai-cloud/images/ai-pyk-tf-3.10:latest"
                   "go run cmd/gif/gif.go  gitlab-registry-dev.t1.cloud/cloud-solution/ai-cloud/images/ai-pyk-3.11:latest"
                   "go run cmd/gif/gif.go  gitlab-registry-dev.t1.cloud/cloud-solution/ai-cloud/images/ai-pyk-3.11:latest gitlab-registry-dev.t1.cloud/cloud-solution/ai-cloud/images/ai-pyk-tf-3.10:latest"
                   "docker build . -t ich:local"
                   "docker run --rm  ich:local -t 5m -u kapustin -p DvvKEDtMtyVEs7XNmA-z git-registry.service.t1-cloud.ru/cloud-solution/ai-cloud/images/ai-pyk-3.11:latest"
                   "dlv debug cmd/ich/ich.go  -- -t 5m -u kapustin -p DvvKEDtMtyVEs7XNmA-z git-registry.service.t1-cloud.ru/cloud-solution/ai-cloud/images/ai-pyk-3.11:latest")))
     (eval progn
           (setenv "DOCKER_CONFIG_JSON"
                   "eyJhdXRocyI6eyJnaXRsYWItcmVnaXN0cnktZGV2LnQxLmNsb3VkIjp7InVzZXJuYW1lIjoiYWkiLCJwYXNzd29yZCI6ImdscGF0LWJzTHpQR291TVhLQnBEcWJXUTd1In19fQ==")
           (setq dy-project-commands '("echo hello")))
     (run-command-recipe-proj lambda nil
                              (list
                               (list :command-name "make docker-build"
                                     :command-line
                                     "make docker-build CONTROLLER_IMG=aaa CONTROLLER_IMG_TAG=latest GITLAB_TOKEN=2xLenrza1sqp5rM7Dt1J")))
     (dy-pytest-arguments . "--kernel-stress -x --ff")))
 '(zoneinfo-style-world-list
   '(("Etc/UTC" "ITC") ("Europe/Moscow" "Moscow")
     ("Asia/Irkutsk" "Irkutsk") ("America/New_York" "New York"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
