;; Clang-Format
;; clang-format --style=google --dump-config > .clang-format 
(use-package clang-format
  :ensure t
)

;; Bidnings
(add-hook
 'c++-mode-hook
 (lambda()
   (keymap-set evil-normal-state-map "<SPC> =" 'clang-format-buffer)
   (keymap-set evil-normal-state-map "<SPC> m d" 'dy-dox-fn)
   ))

;; Ggtags
(use-package ggtags
  :ensure t
  :config
;; With lsp is good to use default evil go to definition
;; 
;;    (add-hook 'c-mode-common-hook
;;            (lambda ()
;;                (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
;;                (ggtags-mode 1))))
  )

;; (keymap-set ggtags-mode-map "C-c g s" 'ggtags-find-other-symbol)
;; (keymap-set ggtags-mode-map "C-c g h" 'ggtags-view-tag-history)
;; (keymap-set ggtags-mode-map "C-c g r" 'ggtags-find-reference)
;; (keymap-set ggtags-mode-map "C-c g f" 'ggtags-find-file)
;; (keymap-set ggtags-mode-map "C-c g c" 'ggtags-create-tags)
;; (keymap-set ggtags-mode-map "C-c g u" 'ggtags-update-tags)
;; 
;; (keymap-set ggtags-mode-map "M-," 'pop-tag-mark)

;; Cmake
(use-package cmake-mode
  :ensure t)
