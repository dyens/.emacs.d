;; -*- lexical-binding: t; -*-

(defvar lilypond-keys
  '(C (:type is :notes ())
      a (:type is :notes ())
      G (:type is :notes ("f"))
      e (:type is :notes ("f"))
      D (:type is :notes ("f" "c"))
      b (:type is :notes ("f" "c"))
      A (:type is :notes ("f" "c" "g"))
      fis (:type is :notes ("f" "c" "g"))
      E (:type is :notes ("f" "c" "g" "d"))
      cis (:type is :notes ("f" "c" "g" "d"))
      B (:type is :notes ("f" "c" "g" "d" "a"))
      gis (:type is :notes ("f" "c" "g" "d" "a"))
      Fis (:type is :notes ("f" "c" "g" "d" "a" "e"))
      dis (:type is :notes ("f" "c" "g" "d" "a" "e"))
      Des^ (:type is :notes ("f" "c" "g" "d" "a" "e" "b"))
      b^ (:type is :notes ("f" "c" "g" "d" "a" "e" "b"))

      F (:type es :notes ("b"))
      d (:type es :notes ("b"))
      B (:type es :notes ("b" "e"))
      g (:type es :notes ("b" "e"))
      Es (:type es :notes ("b" "e" "a"))
      c (:type es :notes ("b" "e" "a"))
      As (:type es :notes ("b" "e" "a" "d"))
      f (:type es :notes ("b" "e" "a" "d"))
      Des (:type es :notes ("b" "e" "a" "d" "g"))
      b (:type es :notes ("b" "e" "a" "d" "g"))
      Ges (:type es :notes ("b" "e" "a" "d" "g" "c"))
      es (:type es :notes ("b" "e" "a" "d" "g" "c"))
      B^ (:type es :notes ("b" "e" "a" "d" "g" "c" "f"))
      gis^ (:type es :notes ("b" "e" "a" "d" "g" "c" "f")))
  "Tonalities")


;; (defvar current-key 'B)

(defun lilypond-enrich-key (begin end)
  "Enrich lilypond notes key with signatures."
  (interactive "r")
  (unless current-key (error "set lilypond-current-key variable"))
  (save-excursion 
    (save-restriction
      (narrow-to-region begin end)
      (goto-char (point-min))
      (let ((tonality (plist-get lilypond-keys current-key)))
        (while 
            ;; "\\([c,d,e,f,g,a,b]\\)\\(is\\|es\\)?\\(['_]?\\)\\(1\\|2\\|4\\|8\\|16\\|32\\)?\\(\\.\\)? "
            (re-search-forward
             (rx
              (group (or "c" "d" "e" "f" "g" "a" "b"))
              (group (optional (or (seq "es") (seq "is"))))
              (group (optional (or "'" ",")))
              (group (optional (or "1" "2" "4" "8" "16" "32")))
              (group (optional "\."))
              (or " " "\n" "\r\n"))
             nil t 1)
          (let ((note (match-string 1))
                (sign (match-string 2))
                (up-down (match-string 3))
                (duration (match-string 4))
                (dot (match-string 5)))
            (when (equal sign "")
              (when (seq-contains-p (plist-get tonality :notes) note)
                (replace-match (format "%s%s%s%s%s "
                                       note
                                       (symbol-name (plist-get tonality :type))
                                       up-down
                                       duration
                                       dot))))))))))


(provide 'dy-lilypond)
