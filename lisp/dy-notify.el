;; -*- lexical-binding: t; -*-
(defun dy-notify (text &optional body)
  "Desktop notify.

  After next building emacs (build with bus) use:
      (notifications-notify :text \"test\")
  "
  (interactive)
  (unless body (setq body ""))
  (call-process "notify-send" nil nil nil
		"-t" "5000"
		"-i" "emacs"
		text
		body)

  (play-sound-file "/home/dyens/.emacs.d/alarm.wav"))


(provide 'dy-notify)
