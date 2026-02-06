;; -*- lexical-binding: t; -*-
(use-package ellama
  :ensure t
  :bind ((:map evil-normal-state-map ("<SPC> ?" . ellama-transient-main-menu)))
  :hook (org-ctrl-c-ctrl-c-final . ellama-chat-send-last-message)
  :init (setopt ellama-auto-scroll t)
  :config
  (ellama-context-header-line-global-mode +1))

(use-package aider
  :ensure t
  :config
  ;; (setq aider-args '("--model" "ollama_chat/deepseek-r1:32b" "--no-auto-accept-architect"))
  (global-set-key (kbd "C-c a") 'aider-transient-menu))




(use-package mcp
  :ensure t
  :after gptel
  :custom (mcp-hub-servers
           `(("filesystem" . (:command "npx" :args ("-y" "@modelcontextprotocol/server-filesystem" "/home/dyens/dev/")))
             ("fetch" . (:command "uvx" :args ("mcp-server-fetch")))
             ("playwright" . (:command "npx" :args ("@playwright/mcp@latest" "--browser" "firefox")))
             ("context7" . (:command "npx" :args ("@upstash/context7-mcp" "--api-key" ,(dy-authinfo-get-secret "context7"))))
             ))
  ;; :hook (after-init . mcp-hub-start-all-server)
  :config (require 'mcp-hub))

(use-package gptel
  :ensure t
  :custom
  (gptel-default-mode 'org-mode)
  :config
  (require 'gptel-integrations)
  (setq gptel-model 'gpt-5-mini
        gptel-log-level 'debug
        gptel-max-tokens 1000
        gptel-backend (gptel-make-openai "dy-openai"
                                          :stream t
                                          :models '(gpt-4.1-mini gpt-5 gpt-5-mini gpt-5.1)
                                          :key #'gptel-api-key
                                          :protocol "https"
                                          :host "api.proxyapi.ru"
                                          :endpoint "/openai/v1/chat/completions"))

  (gptel-make-tool
   :name "read_buffer"
   :function (lambda (buffer)
               (unless (buffer-live-p (get-buffer buffer))
                 (error "error: buffer %s is not live." buffer))
               (with-current-buffer buffer
                 (buffer-substring-no-properties (point-min) (point-max))))
   :description "return the contents of an emacs buffer"
   :args (list '(:name "buffer"
                 :type string            ; :type value must be a symbol
                 :description "the name of the buffer whose contents are to be retrieved"))
   :category "emacs")

 (gptel-make-tool
   :name "execute_shell_cmd"
   :function (lambda (shell-cmd)
               (shell-command-to-string shell-cmd))
   :description "execute shell command and return result string"
   :args (list '(:name "shell-cmd"
                 :type string
                 :description "shell command string"))
   :category "shell"
   :confirm t)
  )


 
;; (setq copilot-token "T09SPC1GLSFsZkB0N1BSbjxKWSphWjxPaVBHTU1fTWN5Yn5QXVZ1ZVY=:676b92e05ce15b53284bcbe4")

;; (gptel-make-gh-copilot "dy-copilot"
;;   :host "copilot.croc.ru"
;;   :endpoint "/continue"
;;   :header (lambda () `(("authorization" . ,(concat "Bearer " copilot-token))))
;;   :curl-args '("-k")
;;   )

(use-package eca :ensure t)



(provide 'dy-ellama)

