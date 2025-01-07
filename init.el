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
(require 'dy-macros)


  (use-package elfeed
    :ensure t
    :custom
    (elfeed-db-directory
     (expand-file-name "elfeed" user-emacs-directory))
    (elfeed-show-entry-switch 'display-buffer)
    (elfeed-feeds '(
                    ("https://www.reddit.com/r/linux.rss" reddit linux)
                    ("https://habr.com/ru/rss/flows/develop/articles/?fl=ru" harbor)
                    ("https://www.linux.org.ru/section-rss.jsp?section=1" linux lor)
                    ("https://www.linux.org.ru/section-rss.jsp?section=3" linux lor)
                    ))

)
