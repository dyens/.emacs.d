;; -*- lexical-binding: t; -*-
(use-package ellama
  :ensure t
  :bind ((:map evil-normal-state-map ("<SPC> ?" . ellama-transient-main-menu)))
  :hook (org-ctrl-c-ctrl-c-final . ellama-chat-send-last-message)
  :init (setopt ellama-auto-scroll t)
  :config
  (ellama-context-header-line-global-mode +1))

;; (use-package aider
;;   :ensure t
;;   :config
;;   (setq aider-args '("--model" "ollama_chat/deepseek-r1:32b" "--no-auto-accept-architect"))
;;   (global-set-key (kbd "C-c a") 'aider-transient-menu))

(use-package gptel
  :ensure t
  :config
  (setq gptel-model 'gpt-4.1-mini
        gptel-log-level 'debug
        gptel-max-tokens 1000
        gptel-backend (gptel-make-openai "dy-openai"
                                          :stream t
                                          :models '(gpt-4.1-mini)
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
   :category "emacs"))



(use-package copilot
  :ensure t
  :config
  (setopt copilot-lsp-settings '(:github-enterprise (:uri "http://copilot.croc.ru/continue")))
  (setopt copilot-server-log-level 4)
  (setq process-environment (cons "GH_COPILOT_TOKEN=T09SPC1GLSFsZkB0N1BSbjxKWSphWjxPaVBHTU1fTWN5Yn5QXVZ1ZVY=:676b92e05ce15b53284bcbe4" process-environment))
  (setq process-environment (cons "NODE_DEBUG=true" process-environment))
  (setq process-environment (cons "DEBUG=true" process-environment))
  )


(provide 'dy-ellama)

