;; Use package
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

(mapc
 (lambda (string)
   (add-to-list 'load-path (locate-user-emacs-file string)))
 '("lisp" "config"))

(require 'dy-compilation)
(require 'dy-cpp)
(require 'dy-eglot)
(require 'dy-globals)
(require 'dy-go)
(require 'dy-gui)
(require 'dy-org)
(require 'dy-packages)
(require 'dy-python)
(require 'dy-tools)
