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

(provide 'dy-ellama)
