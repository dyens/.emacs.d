(use-package ellama
  :ensure t
  :bind ((:map evil-normal-state-map ("<SPC> ?" . ellama-transient-main-menu)))
  :hook (org-ctrl-c-ctrl-c-final . ellama-chat-send-last-message)
  :init (setopt ellama-auto-scroll t)
  :config
  (ellama-context-header-line-global-mode +1))



(provide 'dy-ellama)
