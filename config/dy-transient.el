;; -*- lexical-binding: t; -*-
(use-package transient
  :hook
  ((transient-exit-hook . transient-save)))

(provide 'dy-transient)
