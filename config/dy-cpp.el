;; Clang-Format
;; clang-format --style=google --dump-config > .clang-format 
(use-package clang-format
  :ensure t
  :after evil
  :defer t
  :commands (clang-format-buffer clang-format-region)
  :config
  (add-hook
   'c++-mode-hook
   (lambda()
     (keymap-set evil-normal-state-map "<SPC> =" 'clang-format-buffer))))

;; Cmake
(use-package cmake-mode
  :ensure t)

(provide 'dy-cpp)
