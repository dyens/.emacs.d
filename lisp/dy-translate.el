;; -*- lexical-binding: t; -*-
;;;###autoload
(defun dy-google-translate ()
  (interactive)
  (let* ((langs (google-translate-read-args nil nil))
         (source-language (car langs))
         (target-language (cadr langs)))
    (if (use-region-p)
	(google-translate-translate
	 source-language target-language
	 (buffer-substring-no-properties (region-beginning) (region-end)))
      (google-translate-at-point))))


;;;###autoload
(defun dy-google-translate-reverse ()
  (interactive)
  (let* ((langs (google-translate-read-args nil nil))
         (source-language (cadr langs))
         (target-language (car langs))
	 (p1 (region-beginning))
	 (p2 (region-end)))
    (if (use-region-p)
	(google-translate-translate
	 source-language target-language
	 (buffer-substring-no-properties p1 p2))
      (google-translate-at-point-reverse))))


(provide 'dy-translate)
