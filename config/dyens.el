;; From https://protesilaos.com/codelog/2020-08-03-emacs-custom-functions-galore/
(defconst dy-insert-pair-alist
'(("' Single quote" . (39 39))           ; ' '
    ("\" Double quotes" . (34 34))         ; " "
    ("` Elisp quote" . (96 39))            ; ` '
    ("‘ Single apostrophe" . (8216 8217))  ; ‘ ’
    ("“ Double apostrophes" . (8220 8221)) ; “ ”
    ("( Parentheses" . (40 41))            ; ( )
    ("{ Curly brackets" . (123 125))       ; { }
    ("[ Square brackets" . (91 93))        ; [ ]
    ("< Angled brackets" . (60 62))        ; < >
    ("« tree brakets" . (171 187)))        ; « »
"Alist of pairs for use with.")

;; From https://protesilaos.com/codelog/2020-08-03-emacs-custom-functions-galore/
(defun dy-insert-pair-completion (&optional arg)
"Insert pair from."
(interactive "P")
(let* ((data dy-insert-pair-alist)
        (chars (mapcar #'car data))
        (choice (completing-read "Select character: " chars nil t))
        (left (cadr (assoc choice data)))
        (right (caddr (assoc choice data))))
    (insert-pair arg left right)))

(defun dy-capitalize-first-char (&optional string)
  "Capitalize only the first character of the input STRING."
  (when (and string (> (length string) 0))
    (let ((first-char (substring string nil 1))
          (rest-str   (substring string 1)))
      (concat (capitalize first-char) rest-str))))


(defun dy-run-cmd (cmd)
  "Run command defined in dy-project-commands"
  (interactive (list (completing-read "CMD: " dy-project-commands)))
  (let ((default-directory (project-root (project-current t)))
        (compilation-buffer-name-function
         (or project-compilation-buffer-name-function
             compilation-buffer-name-function)))
    (compile cmd))
)

(defun dy-reload-dir-locals-for-current-buffer ()
  "reload dir locals for the current buffer"
  (interactive)
  (let ((enable-local-variables :all))
    (hack-dir-local-variables-non-file-buffer)))

(defun dy-reload-dir-locals-for-all-buffer-in-this-directory ()
  "For every buffer with the same `default-directory` as the 
current buffer's, reload dir-locals."
  (interactive)
  (let ((dir default-directory))
    (dolist (buffer (buffer-list))
      (with-current-buffer buffer
        (when (equal default-directory dir)
          (dy-reload-dir-locals-for-current-buffer))))))

(defun dy-erc ()
  "Run erc. Default erc does not work."
  (interactive)
   (erc :server "irc.libera.chat" :full-name "Alexander Kapustin" :user "dyens"))

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

(defun dy-screaming-to-camel (s)
  "Convert screaming to camel case.
  Example:
      HELLO_WORLD -> HelloWorld
  " 
  (mapconcat 'capitalize (split-string s "_") ""))

(defun dy-set-fast-function (fn_name)
  "Set some function on <SPC> ` in evil normal state map."
  (interactive "aBind function name: ")
  (keymap-set evil-normal-state-map "<SPC> `" fn_name)
  )

;; https://protesilaos.com/codelog/2021-07-24-emacs-misc-custom-commands/
;; A variant of this is present in the crux.el package by Bozhidar
;; Batsov.
(defun dy-rename-file-and-buffer (name)
  "Apply NAME to current file and rename its buffer.
Do not try to make a new directory or anything fancy."
  (interactive
   (list (read-string "Rename current file: " (buffer-file-name))))
  (let ((file (buffer-file-name)))
    (if (vc-registered file)
        (vc-rename-file file name)
      (rename-file file name))
    (set-visited-file-name name t t)))

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




(defun dy-include-cpp-header ()
  "Include cpp header."
  (interactive)
  (save-excursion
    (let ((bname (replace-regexp-in-string "[.]" "_" (string-inflection-upcase-function (buffer-name)))))
      (goto-char (point-min))
      (insert (format "#ifndef %s\n#define %s\n\n" bname bname))
      (goto-char (point-max))
      (insert (format "\n#endif //%s" bname)))))


(defun dy-get-git-origin-url ()
  "Return current git origin url"
  (let ((url (magit-git-output "config" "--get" "remote.origin.url")))
    (cond
     ((string-match "git@\\(.*\\):\\(.*\\)\.git" url) (format "https://%s/%s" (match-string 1 url) (match-string 2 url)))
     ((string-match "\\(.*\\)\.git" url) (match-string 1 url) )
     (t (error "Can not detect origin"))
     )))


(defun dy-open-in-github (github-url  &optional mode)
  "Open source file in github."
  (interactive)
  (let (
	(github-url (if (null github-url) (dy-get-git-origin-url) (github-url)))
	(github-path
	 (cond
	  ((eq mode nil) (magit-get-current-branch))
	  ((eq mode 'dev) "dev")
	  ((eq mode 'branch) (magit-get-current-branch))
	  ((eq mode 'rev) (magit-rev-abbrev "HEAD"))))

	(project-file (magit-file-relative-name ( buffer-file-name)) )
	(highlight
	 (if (use-region-p)
             (let ((l1 (line-number-at-pos (region-beginning)))
                   (l2 (line-number-at-pos (- (region-end) 1))))
               (format "#L%d-L%d" l1 l2))
           ""))
	(url))
    (setq url (format "%s/blob/%s/%s%s" github-url github-path project-file highlight))
    (shell-command (concat "firefox " url))))

(defun dy-open-in-github-branch()
    (interactive)
    (dy-open-in-github nil 'branch))

(defun dy-open-in-github-rev()
    (interactive)
    (dy-open-in-github nil 'rev))

(defun dy-args-to-attributes ()
  "Add class attributes from method args."
  (interactive)
  (save-excursion
    (re-search-backward "def \\([a-zA-Z0-9_]*\\)(\\([a-zA-Z0-9 \n\t_,]*\\)):")
    (let* ((args-string (buffer-substring-no-properties (match-beginning 2) (match-end 2)))
	   (args (mapcar 's-trim  (s-split ","  args-string)))
	   (not-self-args (cdr args)))
      
      (search-forward ":")
      (mapc (lambda (arg)
	      (if (not (= (length arg) 0 ))
		  (progn
		    (evil-open-below 0)
		    (insert (format "self._%s = %s" arg arg))
		    (evil-normal-state)
		    ))
	      )
	    not-self-args))))

;; Usefull function for template subs
(defun dy-template-sub ()
  (interactive)
  (let ((tmpl "
if %aExists && vm2.Initialization().%b() != %a {
	t.Fatalf(\"got Unexpected output from the %b (%%s) init field \", vm2.Initialization().%b())
}
  ")
  (var (thing-at-point 'word 'no-properties))
  (current (point))
  )
  (goto-char (point-max))
  (insert (format-spec tmpl `((?a . ,var) (?b . ,(upcase-initials var)))))
  (goto-char current)
  ))



;; sudo tail -n 0 -f /var/log/messages > audit.txt
;; :v/SECC/d - filter only seccomp messages
;; sed -e 's/.*syscall=\(.*\) compat.*/\1/g' audit.txt | sort | uniq > audit_keys.txt
;; 
;; sed -e '/syscall/!d'   -e 's/.*syscall=\(.*\) compat.*/\1/g' dev1 | sort |uniq
;; scp ai.json root@ai-dev1:/var/lib/kubelet/seccomp/ai.json


(defun dy-add-syscal-names ()
  "Add syscall names for numbers
    from 
      0
      1
      10
    to
      0 sys_read
      1 sys_write
      10 sys_mprotect
   "
  (interactive)
  (let* (
	 (start (region-beginning))
	 (end (region-end))
	 (syscalls-string (buffer-substring start end))
	 (syscalls (read (format "(%s)" syscalls-string)))
	 )
    (delete-region start end)
    (mapc
     (lambda (x)
       (insert (format "%s %s" x (gethash x linux-sys-calls) ) )
       (newline)
       )
     syscalls
     )))



;; from /linux/arch/x86/entry/syscalls/syscall_64.tbl
(setq linux-sys-calls
      #s(hash-table test equal data(
		     0 "sys_read"
		     1 "sys_write"
		     2 "sys_open"
		     3 "sys_close"
		     4 "sys_newstat"
		     5 "sys_newfstat"
		     6 "sys_newlstat"
		     7 "sys_poll"
		     8 "sys_lseek"
		     9 "sys_mmap"
		     10 "sys_mprotect"
		     11 "sys_munmap"
		     12 "sys_brk"
		     13 "sys_rt_sigaction"
		     14 "sys_rt_sigprocmask"
		     15 "sys_rt_sigreturn"
		     16 "sys_ioctl"
		     17 "sys_pread64"
		     18 "sys_pwrite64"
		     19 "sys_readv"
		     20 "sys_writev"
		     21 "sys_access"
		     22 "sys_pipe"
		     23 "sys_select"
		     24 "sys_sched_yield"
		     25 "sys_mremap"
		     26 "sys_msync"
		     27 "sys_mincore"
		     28 "sys_madvise"
		     29 "sys_shmget"
		     30 "sys_shmat"
		     31 "sys_shmctl"
		     32 "sys_dup"
		     33 "sys_dup2"
		     34 "sys_pause"
		     35 "sys_nanosleep"
		     36 "sys_getitimer"
		     37 "sys_alarm"
		     38 "sys_setitimer"
		     39 "sys_getpid"
		     40 "sys_sendfile64"
		     41 "sys_socket"
		     42 "sys_connect"
		     43 "sys_accept"
		     44 "sys_sendto"
		     45 "sys_recvfrom"
		     46 "sys_sendmsg"
		     47 "sys_recvmsg"
		     48 "sys_shutdown"
		     49 "sys_bind"
		     50 "sys_listen"
		     51 "sys_getsockname"
		     52 "sys_getpeername"
		     53 "sys_socketpair"
		     54 "sys_setsockopt"
		     55 "sys_getsockopt"
		     56 "sys_clone"
		     57 "sys_fork"
		     58 "sys_vfork"
		     59 "sys_execve"
		     60 "sys_exit"
		     61 "sys_wait4"
		     62 "sys_kill"
		     63 "sys_newuname"
		     64 "sys_semget"
		     65 "sys_semop"
		     66 "sys_semctl"
		     67 "sys_shmdt"
		     68 "sys_msgget"
		     69 "sys_msgsnd"
		     70 "sys_msgrcv"
		     71 "sys_msgctl"
		     72 "sys_fcntl"
		     73 "sys_flock"
		     74 "sys_fsync"
		     75 "sys_fdatasync"
		     76 "sys_truncate"
		     77 "sys_ftruncate"
		     78 "sys_getdents"
		     79 "sys_getcwd"
		     80 "sys_chdir"
		     81 "sys_fchdir"
		     82 "sys_rename"
		     83 "sys_mkdir"
		     84 "sys_rmdir"
		     85 "sys_creat"
		     86 "sys_link"
		     87 "sys_unlink"
		     88 "sys_symlink"
		     89 "sys_readlink"
		     90 "sys_chmod"
		     91 "sys_fchmod"
		     92 "sys_chown"
		     93 "sys_fchown"
		     94 "sys_lchown"
		     95 "sys_umask"
		     96 "sys_gettimeofday"
		     97 "sys_getrlimit"
		     98 "sys_getrusage"
		     99 "sys_sysinfo"
		     100 "sys_times"
		     101 "sys_ptrace"
		     102 "sys_getuid"
		     103 "sys_syslog"
		     104 "sys_getgid"
		     105 "sys_setuid"
		     106 "sys_setgid"
		     107 "sys_geteuid"
		     108 "sys_getegid"
		     109 "sys_setpgid"
		     110 "sys_getppid"
		     111 "sys_getpgrp"
		     112 "sys_setsid"
		     113 "sys_setreuid"
		     114 "sys_setregid"
		     115 "sys_getgroups"
		     116 "sys_setgroups"
		     117 "sys_setresuid"
		     118 "sys_getresuid"
		     119 "sys_setresgid"
		     120 "sys_getresgid"
		     121 "sys_getpgid"
		     122 "sys_setfsuid"
		     123 "sys_setfsgid"
		     124 "sys_getsid"
		     125 "sys_capget"
		     126 "sys_capset"
		     127 "sys_rt_sigpending"
		     128 "sys_rt_sigtimedwait"
		     129 "sys_rt_sigqueueinfo"
		     130 "sys_rt_sigsuspend"
		     131 "sys_sigaltstack"
		     132 "sys_utime"
		     133 "sys_mknod"
		     134 ""
		     135 "sys_personality"
		     136 "sys_ustat"
		     137 "sys_statfs"
		     138 "sys_fstatfs"
		     139 "sys_sysfs"
		     140 "sys_getpriority"
		     141 "sys_setpriority"
		     142 "sys_sched_setparam"
		     143 "sys_sched_getparam"
		     144 "sys_sched_setscheduler"
		     145 "sys_sched_getscheduler"
		     146 "sys_sched_get_priority_max"
		     147 "sys_sched_get_priority_min"
		     148 "sys_sched_rr_get_interval"
		     149 "sys_mlock"
		     150 "sys_munlock"
		     151 "sys_mlockall"
		     152 "sys_munlockall"
		     153 "sys_vhangup"
		     154 "sys_modify_ldt"
		     155 "sys_pivot_root"
		     156 "sys_ni_syscall"
		     157 "sys_prctl"
		     158 "sys_arch_prctl"
		     159 "sys_adjtimex"
		     160 "sys_setrlimit"
		     161 "sys_chroot"
		     162 "sys_sync"
		     163 "sys_acct"
		     164 "sys_settimeofday"
		     165 "sys_mount"
		     166 "sys_umount"
		     167 "sys_swapon"
		     168 "sys_swapoff"
		     169 "sys_reboot"
		     170 "sys_sethostname"
		     171 "sys_setdomainname"
		     172 "sys_iopl"
		     173 "sys_ioperm"
		     174 ""
		     175 "sys_init_module"
		     176 "sys_delete_module"
		     177 ""
		     178 ""
		     179 "sys_quotactl"
		     180 ""
		     181 ""
		     182 ""
		     183 ""
		     184 ""
		     185 ""
		     186 "sys_gettid"
		     187 "sys_readahead"
		     188 "sys_setxattr"
		     189 "sys_lsetxattr"
		     190 "sys_fsetxattr"
		     191 "sys_getxattr"
		     192 "sys_lgetxattr"
		     193 "sys_fgetxattr"
		     194 "sys_listxattr"
		     195 "sys_llistxattr"
		     196 "sys_flistxattr"
		     197 "sys_removexattr"
		     198 "sys_lremovexattr"
		     199 "sys_fremovexattr"
		     200 "sys_tkill"
		     201 "sys_time"
		     202 "sys_futex"
		     203 "sys_sched_setaffinity"
		     204 "sys_sched_getaffinity"
		     205 ""
		     206 "sys_io_setup"
		     207 "sys_io_destroy"
		     208 "sys_io_getevents"
		     209 "sys_io_submit"
		     210 "sys_io_cancel"
		     211 ""
		     212 "sys_lookup_dcookie"
		     213 "sys_epoll_create"
		     214 ""
		     215 ""
		     216 "sys_remap_file_pages"
		     217 "sys_getdents64"
		     218 "sys_set_tid_address"
		     219 "sys_restart_syscall"
		     220 "sys_semtimedop"
		     221 "sys_fadvise64"
		     222 "sys_timer_create"
		     223 "sys_timer_settime"
		     224 "sys_timer_gettime"
		     225 "sys_timer_getoverrun"
		     226 "sys_timer_delete"
		     227 "sys_clock_settime"
		     228 "sys_clock_gettime"
		     229 "sys_clock_getres"
		     230 "sys_clock_nanosleep"
		     231 "sys_exit_group"
		     232 "sys_epoll_wait"
		     233 "sys_epoll_ctl"
		     234 "sys_tgkill"
		     235 "sys_utimes"
		     236 ""
		     237 "sys_mbind"
		     238 "sys_set_mempolicy"
		     239 "sys_get_mempolicy"
		     240 "sys_mq_open"
		     241 "sys_mq_unlink"
		     242 "sys_mq_timedsend"
		     243 "sys_mq_timedreceive"
		     244 "sys_mq_notify"
		     245 "sys_mq_getsetattr"
		     246 "sys_kexec_load"
		     247 "sys_waitid"
		     248 "sys_add_key"
		     249 "sys_request_key"
		     250 "sys_keyctl"
		     251 "sys_ioprio_set"
		     252 "sys_ioprio_get"
		     253 "sys_inotify_init"
		     254 "sys_inotify_add_watch"
		     255 "sys_inotify_rm_watch"
		     256 "sys_migrate_pages"
		     257 "sys_openat"
		     258 "sys_mkdirat"
		     259 "sys_mknodat"
		     260 "sys_fchownat"
		     261 "sys_futimesat"
		     262 "sys_newfstatat"
		     263 "sys_unlinkat"
		     264 "sys_renameat"
		     265 "sys_linkat"
		     266 "sys_symlinkat"
		     267 "sys_readlinkat"
		     268 "sys_fchmodat"
		     269 "sys_faccessat"
		     270 "sys_pselect6"
		     271 "sys_ppoll"
		     272 "sys_unshare"
		     273 "sys_set_robust_list"
		     274 "sys_get_robust_list"
		     275 "sys_splice"
		     276 "sys_tee"
		     277 "sys_sync_file_range"
		     278 "sys_vmsplice"
		     279 "sys_move_pages"
		     280 "sys_utimensat"
		     281 "sys_epoll_pwait"
		     282 "sys_signalfd"
		     283 "sys_timerfd_create"
		     284 "sys_eventfd"
		     285 "sys_fallocate"
		     286 "sys_timerfd_settime"
		     287 "sys_timerfd_gettime"
		     288 "sys_accept4"
		     289 "sys_signalfd4"
		     290 "sys_eventfd2"
		     291 "sys_epoll_create1"
		     292 "sys_dup3"
		     293 "sys_pipe2"
		     294 "sys_inotify_init1"
		     295 "sys_preadv"
		     296 "sys_pwritev"
		     297 "sys_rt_tgsigqueueinfo"
		     298 "sys_perf_event_open"
		     299 "sys_recvmmsg"
		     300 "sys_fanotify_init"
		     301 "sys_fanotify_mark"
		     302 "sys_prlimit64"
		     303 "sys_name_to_handle_at"
		     304 "sys_open_by_handle_at"
		     305 "sys_clock_adjtime"
		     306 "sys_syncfs"
		     307 "sys_sendmmsg"
		     308 "sys_setns"
		     309 "sys_getcpu"
		     310 "sys_process_vm_readv"
		     311 "sys_process_vm_writev"
		     312 "sys_kcmp"
		     313 "sys_finit_module"
		     314 "sys_sched_setattr"
		     315 "sys_sched_getattr"
		     316 "sys_renameat2"
		     317 "sys_seccomp"
		     318 "sys_getrandom"
		     319 "sys_memfd_create"
		     320 "sys_kexec_file_load"
		     321 "sys_bpf"
		     322 "sys_execveat"
		     323 "sys_userfaultfd"
		     324 "sys_membarrier"
		     325 "sys_mlock2"
		     326 "sys_copy_file_range"
		     327 "sys_preadv2"
		     328 "sys_pwritev2"
		     329 "sys_pkey_mprotect"
		     330 "sys_pkey_alloc"
		     331 "sys_pkey_free"
		     332 "sys_statx"
		     333 "sys_io_pgetevents"
		     334 "sys_rseq"
		     424 "sys_pidfd_send_signal"
		     425 "sys_io_uring_setup"
		     426 "sys_io_uring_enter"
		     427 "sys_io_uring_register"
		     428 "sys_open_tree"
		     429 "sys_move_mount"
		     430 "sys_fsopen"
		     431 "sys_fsconfig"
		     432 "sys_fsmount"
		     433 "sys_fspick"
		     434 "sys_pidfd_open"
		     435 "sys_clone3"
		     436 "sys_close_range"
		     437 "sys_openat2"
		     438 "sys_pidfd_getfd"
		     439 "sys_faccessat2"
		     440 "sys_process_madvise"
		     441 "sys_epoll_pwait2"
		     442 "sys_mount_setattr"
		     443 "sys_quotactl_fd"
		     444 "sys_landlock_create_ruleset"
		     445 "sys_landlock_add_rule"
		     446 "sys_landlock_restrict_self"
		     447 "sys_memfd_secret"
		     448 "sys_process_mrelease"
		     449 "sys_futex_waitv"
		     450 "sys_set_mempolicy_home_node"
		     512 "compat_sys_rt_sigaction"
		     513 "compat_sys_x32_rt_sigreturn"
		     514 "compat_sys_ioctl"
		     515 "sys_readv"
		     516 "sys_writev"
		     517 "compat_sys_recvfrom"
		     518 "compat_sys_sendmsg"
		     519 "compat_sys_recvmsg"
		     520 "compat_sys_execve"
		     521 "compat_sys_ptrace"
		     522 "compat_sys_rt_sigpending"
		     523 "compat_sys_rt_sigtimedwait_time64"
		     524 "compat_sys_rt_sigqueueinfo"
		     525 "compat_sys_sigaltstack"
		     526 "compat_sys_timer_create"
		     527 "compat_sys_mq_notify"
		     528 "compat_sys_kexec_load"
		     529 "compat_sys_waitid"
		     530 "compat_sys_set_robust_list"
		     531 "compat_sys_get_robust_list"
		     532 "sys_vmsplice"
		     533 "sys_move_pages"
		     534 "compat_sys_preadv64"
		     535 "compat_sys_pwritev64"
		     536 "compat_sys_rt_tgsigqueueinfo"
		     537 "compat_sys_recvmmsg_time64"
		     538 "compat_sys_sendmmsg"
		     539 "sys_process_vm_readv"
		     540 "sys_process_vm_writev"
		     541 "sys_setsockopt"
		     542 "sys_getsockopt"
		     543 "compat_sys_io_setup"
		     544 "compat_sys_io_submit"
		     545 "compat_sys_execveat"
		     546 "compat_sys_preadv64v2"
		     547 "compat_sys_pwritev64v2"
)))


(defun random-alnum ()
  (let* ((alnum "abcdefghijklmnopqrstuvwxyz0123456789")
         (i (% (abs (random)) (length alnum))))
    (substring alnum i (1+ i))))

(defun insert-random-string (len)
  "Insert random string.
   Use c-U 10 M-x insert-random-string
   "
  (interactive "p")
  (message (format "%d" len))
  (dotimes (i len)
  (insert (random-alnum))))

;; Make http requests in emacs

(defvar token-oauth nil
  "Oauth2 token")

(defun dy-request ()
  "Make url retrieve."
  (let ((buf (url-retrieve-synchronously url))
        content)
    (setq content (get-buffer-string  buf))
    (with-current-buffer (get-buffer-create "*HTTP-RESULT*")
      (erase-buffer)
      (insert (decode-coding-string content 'utf-8)))))
   


(defun dy-set-ift1-token ()
  "ift1 oauth2 token"
  (interactive)
  (setq token-oauth
    (oauth2-auth
            "https://ift1-auth.apps.cloud.k8s.test.01.vmw.t1.loc/auth/realms/Portal/protocol/openid-connect/auth"
            "https://ift1-auth.apps.cloud.k8s.test.01.vmw.t1.loc/auth/realms/Portal/protocol/openid-connect/token"
            "portal-front"
            ""
            "openid"
            ""
            "https://ift1-portal-front.apps.cloud.k8s.test.01.vmw.t1.loc")))
 


(defun dy-set-dev-token ()
  "dev oauth2 token"
  (interactive)
  (setq token-oauth
    (oauth2-auth
            "https://d2-auth.apps.cloud.k8s.dev.01.vmw.t1.loc/auth/realms/Portal/protocol/openid-connect/auth"
            "https://d2-auth.apps.cloud.k8s.dev.01.vmw.t1.loc/auth/realms/Portal/protocol/openid-connect/token"
            "portal-front"
            ""
            "openid"
            ""
            "https://d2-portal-front.apps.cloud.k8s.dev.01.vmw.t1.loc")))
 

(defun dy-oauth-request-example()
(let ((url "https://d2-api.apps.cloud.k8s.dev.01.vmw.t1.loc/ai-api/api/v1/projects/proj-123/order-service/orders")
      (url-request-method "GET")
      (url-request-extra-headers
        '(("Content-Type" . "application/json")))
       (url-request-data
        (encode-coding-string
         (json-encode
          '(:messages [(:role "user"
                        :content "qual é o melhor editor, vim ou emacs?")]))
         'utf-8)))
  (dy-oauth-request))
)
