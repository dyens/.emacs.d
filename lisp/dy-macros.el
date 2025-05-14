;; -*- lexical-binding: t; -*-
;; F3(c-x () start macros
;; F4(c-x )) end macros
;; F4(c-x e) execute macros
;; M-x name-last-kbd-macro
;; M-x insert-kbd-macro
(defalias 'kaas-config
   (kmacro "v j j f \" f \" f \" d $ h v j j j j d SPC e M-x base64-decode-region <return> j j o SPC SPC SPC SPC proxy-url: SPC http://10.13.240.5:3128 ESC"))


(provide 'dy-macros)
